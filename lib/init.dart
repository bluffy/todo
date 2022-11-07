import 'package:blutodo/data/notes_repository.dart';
import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'core/environment.dart';

/// Initializer, which prepares the app for execution.
///
/// Tests can use an alternative implementation, instead of the
/// [DefaultAppInitializer].
abstract class AppInitializer {
  static Future<void>? _initialized;

  /// Ensures that the app is initialized. Can be called multiple times.
  Future<void> ensureInitialized() => _initialized ??= initialize();

  /// Performs the actual initialization.
  Future<void> initialize();

  /// Returns the root dependencies of the app.
  RootDependencies get rootDependencies;
}

/// The dependencies which are provided at the root of the app.
class RootDependencies {
  RootDependencies({required this.notesRepository});

  final NotesRepository notesRepository;
}

/// Provides the [RootDependencies] to the widget tree below.
class ProvideRootDependencies extends StatelessWidget {
  const ProvideRootDependencies({
    Key? key,
    required this.dependencies,
    required this.child,
  }) : super(key: key);

  final RootDependencies dependencies;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: dependencies.notesRepository),
        ],
        child: child,
      );
}

/// The default [AppInitializer], which fully initializes the app for production
/// or live development.
class DefaultAppInitializer extends AppInitializer {
  late final AsyncDatabase _database;

  @override
  Future<void> initialize() async {
    await TracingDelegate.install(DevToolsTracing());

    await Future.wait([
      AppEnvironment.init(),
      CouchbaseLiteFlutter.init(),
    ]);

    _setupCouchbaseLogging();
    await _openDatabase();
    await _database.createIndex(
      // Any existing index, with the same name, will be replaced with
      // a new index, with the new configuration.
      'note-fts',
      FullTextIndexConfiguration(
        // We want both the title and body of the note to be indexed.
        ['title'],
        // By selecting the language, that is primarily used in the
        // indexed fields, users will get better search results.
        language: FullTextLanguage.english,
      ),
    );
  }

  void _setupCouchbaseLogging() {
    Database.log
      // For Flutter apps `Database.log.custom` is setup with a logger, which
      // logs to `print`, but only at log level `warning`.
      ..custom!.level = kReleaseMode ? LogLevel.none : LogLevel.info
      ..file.config = LogFileConfiguration(
        directory: appEnvironment.cblLogsDirectory,
        usePlainText: !kReleaseMode,
      );
  }

  Future<void> _openDatabase() async {
    /*
    _database = await Database.openAsync(
      // A new database is opened each time the app starts to ensure multiple
      // instances of the app, running in parallel, do not use the same
      // database. This is necessary because two or more replicators accessing
      // the same database can cause issues with locking of the database.
      'counters-${Random().nextInt(0xFFFFFF)}',
    );
    */
    _database = await Database.openAsync(
      // A new database is opened each time the app starts to ensure multiple
      // instances of the app, running in parallel, do not use the same
      // database. This is necessary because two or more replicators accessing
      // the same database can cause issues with locking of the database.
      'counters',
    );
  }

  @override
  RootDependencies get rootDependencies => RootDependencies(
        notesRepository: NotesRepository(database: _database),
      );
}

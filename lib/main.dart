import 'package:flutter/material.dart';
import 'pages/initialization_page.dart';
import 'init.dart';
import 'core/context.dart';
import 'pages/notes_page.dart';

void main() {
  runApp(NotesApp(initializer: DefaultAppInitializer()));
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key, required this.initializer}) : super(key: key);

  final AppInitializer initializer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      navigatorKey: navigatorKey,
      builder: (context, child) => InitializationPage(
        initialize: initializer.ensureInitialized,
        builder: (context) => ProvideRootDependencies(
          dependencies: initializer.rootDependencies,
          child: child!,
        ),
      ),
      home: const NotesPage(),
      //home: NotesPage.withProviders(id: 'A'),
    );
  }
}

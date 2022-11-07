import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:collection/collection.dart';

//import 'package:rxdart/rxdart.dart';

//import '../core/environment.dart';

class NotesRepository {
  NotesRepository({required this.database});

  final AsyncDatabase database;
  Future<MutableDocument> createNote({
    required String title,
  }) async {
    // In Couchbase Lite, data is stored in JSON like documents. The default
    // constructor of MutableDocument creates a new document with a randomly
    // generated id.
    final doc = MutableDocument({
      // Since documents of different types are all stored in the same database,
      // it is customary to store the type of the document in the `type` field.
      'type': 'note',
      'title': title,
    });

    // Now save the new note in the database.
    await database.saveDocument(doc);

    return doc;
  }

  /// Returns the current value of the counter with the given [id] from the
  /// database.
  Future<int> counterValue(String id) async {
    final query = _buildCounterValueQuery();
    await query.setParameters(Parameters({'COUNTER_ID': id}));
    final resultSet = await query.execute();
    return _countValueQueryResult(resultSet);
  }

  AsyncQuery _buildCounterValueQuery() {
    final counterId = Expression.property('counterId');
    var deltaSum = Function_.sum(Expression.property('delta'));

    return QueryBuilder.createAsync()
        .select(SelectResult.expression(deltaSum))
        .from(DataSource.database(database))
        .where(counterId.equalTo(Expression.parameter('COUNTER_ID')))
        .groupBy(counterId);
  }

  Future<int> _countValueQueryResult(ResultSet resultSet) async {
    final results = await resultSet.allResults();
    return results.firstOrNull?.integer(0) ?? 0;
  }

  Future<List<NoteSearchResult>> searchNotes(/*Query queryString*/) async {
    // Creating a query has some overhead and if a query is executed
    // many times, it should be created once and reused. For simplicity
    // we don't do that here.
    /*
    final query = await Query.fromN1ql(
      database,
      r'''
    SELECT META().id AS id, title
    FROM _
    WHERE type = 'note' AND match(note-fts, $query)
    ORDER BY rank(note-fts)
    LIMIT 10
    ''',
    );
    */
    final query = await Query.fromN1ql(
      database,
      r'''
    SELECT META().id AS id, title
    FROM _
    WHERE type = 'note'
    ORDER BY 'title'
    LIMIT 100
    ''',
    );

    // Query parameters are defined by prefixing an identifier with `$`.
    //await query.setParameters(Parameters({'query': '$queryString*'}));

    // Each time a query is executed, its results are returned in a ResultSet.
    final resultSet = await query.execute();

    // To create the NoteSearchResults, we turn the ResultSet into a stream
    // and collect the results into a List, after transforming them into
    // NoteSearchResults.
    return resultSet.asStream().map(NoteSearchResult.fromResult).toList();
  }
}

class NoteSearchResult {
  NoteSearchResult({required this.id, required this.title});

  /// This method creates a NoteSearchResult from a query result.
  static NoteSearchResult fromResult(Result result) => NoteSearchResult(
        // The Result type has typed getters, to extract values from a result.
        id: result.string('id')!,
        title: result.string('title')!,
      );

  final String id;
  final String title;
}

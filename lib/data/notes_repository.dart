import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:collection/collection.dart';

//import 'package:rxdart/rxdart.dart';

//import '../core/environment.dart';

class NotesRepository {
  NotesRepository({required this.database});

  final AsyncDatabase database;

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
}

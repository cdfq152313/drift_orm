import 'package:drift/drift.dart';

typedef WhereFilter<T extends Table> = Expression<bool> Function(T table);

class OrmTable<T> extends Table {
  List<Join> getJoins(Map<String, OrmTable> tableMap) {
    final joins = <Join>[];
    final joinInfo = buildJoinInfo(tableMap);

    joins.addAll(joinInfo.entries.map((entry) {
      final column = entry.key;
      final table = entry.value;
      return leftOuterJoin(table, column.equalsExp(table.primaryKey!.first));
    }));

    joins.addAll(joinInfo.values.expand((table) => table.getJoins(tableMap)));

    return joins;
  }

  Map<Column, OrmTable> buildJoinInfo(Map<String, OrmTable> tableMap) {
    return {};
  }

  T extractRow(Map<String, OrmTable> tableMap, TypedResult row) {
    throw UnimplementedError();
  }

  void saveRow(Batch batch, Map<String, OrmTable> tableMap, T instance) {
    throw UnimplementedError();
  }
}

mixin OrmDatabaseMixin on GeneratedDatabase {
  late final Map<String, OrmTable> tableMap = _getTableMap();
  Map<String, OrmTable> _getTableMap() {
    final tableMap = <String, OrmTable>{};
    for (final table in allTables.whereType<OrmTable>()) {
      tableMap[(table as TableInfo).actualTableName] = table;
    }
    return tableMap;
  }
}

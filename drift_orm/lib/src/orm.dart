import 'package:drift/drift.dart';

typedef WhereFilter<T extends Table> = Expression<bool> Function(T table);

class OrmTable<T> extends Table {
  List<JoinPart> getJoins(
    DatabaseConnectionUser accessor,
    String prefix,
    Map<String, OrmTable> tableMap,
  ) {
    return [];
  }

  T? extractRow(List<JoinPart> joinParts, TypedResult row) {
    throw UnimplementedError();
  }

  void saveRows(Batch batch, Map<String, OrmTable> tableMap, List<T> instance) {
    throw UnimplementedError();
  }
}

class JoinPart {
  final String columnName;
  final Table aliasTable;
  final Join join;
  final List<JoinPart> children;
  JoinPart(this.columnName, this.aliasTable, this.join, this.children);

  void _addJoins(List<Join> joins) {
    joins.add(join);
    for (final child in children) {
      child._addJoins(joins);
    }
  }
}

extension AllJoinParts on List<JoinPart> {
  List<Join> get allJoins {
    final joins = <Join>[];
    for (final part in this) {
      part._addJoins(joins);
    }
    return joins;
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

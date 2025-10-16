import 'package:drift/drift.dart';

typedef WhereFilter<T extends Table> = Expression<bool> Function(T table);

class OrmTable extends Table {
  List<Join> getJoins() {
    final joins = <Join>[];
    final joinInfo = buildJoinInfo();

    joins.addAll(joinInfo.keys.map((column) {
      final table = joinInfo[column]!;
      return leftOuterJoin(table, column.equalsExp(table.primaryKey!.first));
    }));

    joins.addAll(joinInfo.values.expand((table) => table.getJoins()));

    return joins;
  }

  Map<GeneratedColumn, OrmTable> buildJoinInfo() {
    return {};
  }
}

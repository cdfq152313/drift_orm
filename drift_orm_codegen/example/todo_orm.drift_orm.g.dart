// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'todo_orm.dart';

// **************************************************************************
// EntityGenerator
// **************************************************************************

@UseRowClass(TodoOrm)
class TodoOrms extends OrmTable<TodoOrm> {
  late final id = text()();
  late final createdAt = integer().map(const MyConverter()).nullable()();
  late final isDone = boolean().nullable().withDefault(Constant(false))();
  late final extraFieldId = integer().references(Extras, #id).nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  Map<Column, OrmTable> buildJoinInfo(Map<String, OrmTable> tableMap) {
    return {extraFieldId: tableMap['extras']!};
  }

  @override
  TodoOrm? extractRow(Map<String, OrmTable> tableMap, TypedResult row) {
    final result = row.readTableOrNull(this as TableInfo) as TodoOrm?;
    if (result == null) {
      return null;
    }
    result.extraField = tableMap['extras']!.extractRow(tableMap, row);
    return result;
  }

  @override
  void saveRows(
    Batch batch,
    Map<String, OrmTable> tableMap,
    List<TodoOrm> instances,
  ) {
    final extraFields =
        instances.map((e) => e.extraField).whereType<Extra>().toList();
    if (extraFields.isNotEmpty) {
      tableMap['extras']!.saveRows(batch, tableMap, extraFields);
    }
    batch.insertAll(
      this as TableInfo,
      instances,
      mode: InsertMode.insertOrReplace,
    );
  }
}

mixin _$TodoOrmOrmRowMixin {
  Extra? get extraField;
  int? get extraFieldId => extraField?.id;
}

mixin _$TodoOrmsOrmMixin on _$TodoOrmsDaoMixin {
  Future<void> upsert(TodoOrm instance) {
    return batch((batch) {
      todoOrms.saveRows(batch, db.tableMap, [instance]);
    });
  }

  Future<void> upsertAll(List<TodoOrm> instances) {
    return batch((batch) {
      todoOrms.saveRows(batch, db.tableMap, instances);
    });
  }

  Future<List<TodoOrm>> loadAll({
    WhereFilter<TodoOrms>? where,
    int? limit,
    int? offset,
    List<OrderClauseGenerator<TodoOrms>>? orderBy,
  }) {
    final statement = select(todoOrms);
    if (where != null) {
      statement.where(where);
    }
    if (orderBy != null) {
      statement.orderBy(orderBy);
    }
    final joins = todoOrms.getJoins(db.tableMap);
    if (joins.isEmpty) {
      if (limit != null) {
        statement.limit(limit, offset: offset);
      }
      return statement.get();
    } else {
      final joinedStatement = statement.join(joins);
      if (limit != null) {
        joinedStatement.limit(limit, offset: offset);
      }
      return joinedStatement.get().then((rows) {
        return rows
            .map((row) => todoOrms.extractRow(db.tableMap, row)!)
            .toList();
      });
    }
  }

  Future<TodoOrm?> load(key) async {
    final statement = select(todoOrms);
    statement.where((table) => table.primaryKey.first.equals(key));
    final joins = todoOrms.getJoins(db.tableMap);
    final list = await (joins.isEmpty
        ? statement.get()
        : statement.join(joins).get().then((rows) {
            return rows
                .map((row) => todoOrms.extractRow(db.tableMap, row)!)
                .toList();
          }));
    return list.isNotEmpty ? list.first : null;
  }

  Future<int> partialUpdate(
    TodoOrmsCompanion companion, {
    WhereFilter<TodoOrms>? where,
  }) {
    final statement = update(todoOrms);
    if (where != null) {
      statement.where(where);
    }
    return statement.write(companion);
  }
}

@UseRowClass(Extra)
class Extras extends OrmTable<Extra> {
  late final id = integer()();
  late final info = text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  Map<Column, OrmTable> buildJoinInfo(Map<String, OrmTable> tableMap) {
    return {};
  }

  @override
  Extra? extractRow(Map<String, OrmTable> tableMap, TypedResult row) {
    final result = row.readTableOrNull(this as TableInfo) as Extra?;
    if (result == null) {
      return null;
    }

    return result;
  }

  @override
  void saveRows(
    Batch batch,
    Map<String, OrmTable> tableMap,
    List<Extra> instances,
  ) {
    batch.insertAll(
      this as TableInfo,
      instances,
      mode: InsertMode.insertOrReplace,
    );
  }
}

mixin _$ExtraOrmRowMixin {}

mixin _$ExtrasOrmMixin on _$ExtrasDaoMixin {
  Future<void> upsert(Extra instance) {
    return batch((batch) {
      extras.saveRows(batch, db.tableMap, [instance]);
    });
  }

  Future<void> upsertAll(List<Extra> instances) {
    return batch((batch) {
      extras.saveRows(batch, db.tableMap, instances);
    });
  }

  Future<List<Extra>> loadAll({
    WhereFilter<Extras>? where,
    int? limit,
    int? offset,
    List<OrderClauseGenerator<Extras>>? orderBy,
  }) {
    final statement = select(extras);
    if (where != null) {
      statement.where(where);
    }
    if (orderBy != null) {
      statement.orderBy(orderBy);
    }
    final joins = extras.getJoins(db.tableMap);
    if (joins.isEmpty) {
      if (limit != null) {
        statement.limit(limit, offset: offset);
      }
      return statement.get();
    } else {
      final joinedStatement = statement.join(joins);
      if (limit != null) {
        joinedStatement.limit(limit, offset: offset);
      }
      return joinedStatement.get().then((rows) {
        return rows.map((row) => extras.extractRow(db.tableMap, row)!).toList();
      });
    }
  }

  Future<Extra?> load(key) async {
    final statement = select(extras);
    statement.where((table) => table.primaryKey.first.equals(key));
    final joins = extras.getJoins(db.tableMap);
    final list = await (joins.isEmpty
        ? statement.get()
        : statement.join(joins).get().then((rows) {
            return rows
                .map((row) => extras.extractRow(db.tableMap, row)!)
                .toList();
          }));
    return list.isNotEmpty ? list.first : null;
  }

  Future<int> partialUpdate(
    ExtrasCompanion companion, {
    WhereFilter<Extras>? where,
  }) {
    final statement = update(extras);
    if (where != null) {
      statement.where(where);
    }
    return statement.write(companion);
  }
}

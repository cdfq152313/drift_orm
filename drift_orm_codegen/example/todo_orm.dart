import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

import 'drift_orm_codegen_example.dart';

part 'todo_orm.drift_orm.g.dart';
part 'todo_orm.g.dart';

@Entity()
class TodoOrm with _$TodoOrmOrmRowMixin, $TodoOrmsTableToColumns {
  @EntityPrimaryKey()
  String id;

  @EntityColumn(converter: MyConverter)
  DateTime? createdAt;

  @EntityColumn(defaultValue: false)
  bool isDone = false;

  @EntityToOne()
  Extra? extraField;

  TodoOrm({required this.id});

  Future<void> save() async {}
}

@Entity()
class Extra with _$ExtraOrmRowMixin, $ExtrasTableToColumns {
  @EntityPrimaryKey()
  int id;

  @EntityColumn()
  String? info;
  Extra({required this.id, this.info});

  Future<void> save() async {}
}

class MyConverter extends TypeConverter<DateTime, int> {
  const MyConverter();

  @override
  DateTime fromSql(int fromDb) {
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int toSql(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

@DriftAccessor(tables: [TodoOrms])
class TodoOrmsDao extends DatabaseAccessor<AppDatabase>
    with _$TodoOrmsDaoMixin, _$TodoOrmsOrmMixin {
  TodoOrmsDao(super.db);
}

@DriftAccessor(tables: [Extras])
class ExtrasDao extends DatabaseAccessor<AppDatabase>
    with _$ExtrasDaoMixin, _$ExtrasOrmMixin {
  ExtrasDao(super.db);
}

mixin _$TodoOrmsOrmMixin222 on _$TodoOrmsDaoMixin {
  Future<List<TodoOrm>> limitTodos(int limit, {int? offset}) {
    return (select(todoOrms)..limit(limit, offset: offset)).get();
  }

  Future upsert(TodoOrm instance) {
    return transaction(() async {
      await into(todoOrms).insert(instance, mode: InsertMode.insertOrReplace);
    });
  }

  Future upsertAll(List<TodoOrm> instances) async {
    await batch((b) =>
        b.insertAll(todoOrms, instances, mode: InsertMode.insertOrReplace));
  }

  Future<List<TodoOrm>> loadAll(
      {WhereFilter<TodoOrms>? where,
      int? limit,
      int? offset,
      List<OrderClauseGenerator<TodoOrms>>? orderBy}) {
    final statement = select(todoOrms);
    if (where != null) {
      statement.where(where);
    }
    if (orderBy != null) {
      statement.orderBy(orderBy);
    }
    final joins = todoOrms.getJoins();
    if (joins.length == 0) {
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
        return rows.map((row) => row.readTable(todoOrms)).toList();
      });
    }
  }

  Future<TodoOrm?> load(key) async {
    final statement = select(todoOrms);
    statement.where((table) => table.primaryKey.first.equals(key));
    final joins = todoOrms.getJoins();
    final list = await (joins.length == 0
        ? statement.get()
        : statement.join(joins).get().then((rows) {
            return rows.map((row) => row.readTable(todoOrms)).toList();
          }));
    return list.length > 0 ? list.first : null;
  }

  Future<int> partialUpdate(TodoOrmsCompanion companion,
      {WhereFilter<TodoOrms>? where}) {
    final statement = update(todoOrms);
    if (where != null) {
      statement.where(where);
    }
    return statement.write(companion);
  }

  List<TableInfo> get tables => [todoOrms];
}

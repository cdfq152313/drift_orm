import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_orm/drift_orm.dart';

import 'todo_auto.dart';
import 'todo_custom.dart';
import 'todo_orm.dart';

part 'drift_orm_codegen_example.g.dart';

@DriftDatabase(
  daos: [TodoAutosDao, TodoCustomsDao, TodoOrmsDao, ExtrasDao],
  tables: [TodoAutos, TodoCustoms, TodoOrms, Extras],
)
class AppDatabase extends _$AppDatabase with OrmDatabaseMixin {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}

void main(List<String> args) async {
  final database = AppDatabase(NativeDatabase.memory());
  await database.todoOrmsDao.upsert(TodoOrm(id: "")..extraField = Extra(id: 1));
  final data = await database.todoOrmsDao.loadAll();
  print(data);
}

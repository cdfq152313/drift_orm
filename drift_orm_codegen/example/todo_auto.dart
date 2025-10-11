import 'package:drift/drift.dart';

import 'drift_orm_codegen_example.dart';

part 'todo_auto.g.dart';

class TodoAutos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftAccessor(tables: [TodoAutos])
class TodoAutosDao extends DatabaseAccessor<AppDatabase>
    with _$TodoAutosDaoMixin {
  TodoAutosDao(super.db);
}

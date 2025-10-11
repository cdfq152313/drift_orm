import 'package:drift/drift.dart';

import 'drift_orm_codegen_example.dart';

part 'todo_custom.g.dart';

class TodoCustom {
  int id;
  String title;
  String content;
  DateTime? createdAt;
  TodoCustom(
      {required this.id,
      required this.title,
      required this.content,
      this.createdAt});
}

@UseRowClass(TodoCustom)
class TodoCustoms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftAccessor(tables: [TodoCustoms])
class TodoCustomsDao extends DatabaseAccessor<AppDatabase>
    with _$TodoCustomsDaoMixin {
  TodoCustomsDao(super.db);
}

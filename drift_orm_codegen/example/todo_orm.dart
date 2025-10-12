import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

part 'todo_orm.drift_orm.g.dart';

@Entity()
class TodoOrm {
  @EntityPrimaryKey()
  String id;

  @EntityColumn(converter: MyConverter)
  DateTime? createdAt;

  TodoOrm({required this.id});
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

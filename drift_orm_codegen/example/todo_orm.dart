import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

part 'todo_orm.drift_orm.g.dart';

@Entity()
class TodoOrm {
  @EntityPrimaryKey()
  String id;

  @EntityColumn(converter: MyConverter)
  DateTime? createdAt;

  @EntityColumn(defaultValue: false)
  bool isDone = false;

  @EntityToOne()
  Extra? extraField;

  TodoOrm({required this.id});
}

@Entity()
class Extra {
  @EntityPrimaryKey()
  int id;

  @EntityColumn()
  String? info;
  Extra({required this.id, this.info});
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

import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

part 'todo_orm.drift_orm.g.dart';

@Entity()
class TodoOrm {
  @EntityPrimaryKey()
  String id;

  TodoOrm({required this.id});
}

import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

part 'todo_orm.drift_orm.g.dart';

@Entity()
class Event {
  @EntityPrimaryKey()
  String id;

  Event({required this.id});
}

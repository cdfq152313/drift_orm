import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';

part 'drift_orm_codegen_example.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}



@Entity()
class Event {
  @EntityPrimaryKey()
  String id;

  Event({required this.id});
}

@GenerateHelloWorld(name: 'Dart Developer')
class MyService {
  void doSomething() {
    print('MyService is doing something...');
  }
}

@GenerateHelloWorld() // 使用預設的 'World'
class AnotherService {
  void performTask() {
    print('AnotherService is performing a task...');
  }
}

void main() {
  print('=== Drift ORM Code Generation Example ===');

  final service = MyService();
  service.doSomething();
  service.printHello(); // 這個方法會被生成

  print('Generated greeting: ${service.sayHello()}'); // 這個方法也會被生成

  print('---');

  final anotherService = AnotherService();
  anotherService.performTask();
  anotherService.printHello(); // 這個方法會被生成

  print('Generated greeting: ${anotherService.sayHello()}'); // 這個方法也會被生成
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'drift_orm_codegen_example.dart';

// **************************************************************************
// HelloWorldGenerator
// **************************************************************************

extension MyServiceHelloWorldExtension on MyService {
  String sayHello() {
    return "Hello, Dart Developer! Generated for MyService";
  }

  void printHello() {
    print(sayHello());
  }
}

extension AnotherServiceHelloWorldExtension on AnotherService {
  String sayHello() {
    return "Hello, World! Generated for AnotherService";
  }

  void printHello() {
    print(sayHello());
  }
}

// **************************************************************************
// EntityGenerator
// **************************************************************************

class TodoItem2s extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

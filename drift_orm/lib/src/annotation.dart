import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Entity {
  const Entity({this.constructor});
  final String? constructor;
}

abstract class EntityColumnBase {
  /// Name of the column in database
  String? get name;

  bool get isNullable;

  bool get auto;
}

@Target({TargetKind.field})
class EntityColumn implements EntityColumnBase {
  /// Name of the column in database
  final String? name;

  final bool isNullable;

  final bool auto;

  final Type? converter;

  final Object? defaultValue;
  final Object? clientDefault;

  const EntityColumn({
    this.name,
    this.isNullable = true,
    this.auto = false,
    this.converter,
    this.defaultValue,
    this.clientDefault,
  });
}

/// Annotation to declare a model property as primary key in database table
@Target({TargetKind.field})
class EntityPrimaryKey implements EntityColumnBase {
  /// Name of the column in database
  final String? name;

  final bool isNullable = false;

  final bool auto;

  const EntityPrimaryKey({
    this.name,
    this.auto = false,
  });
}

abstract class ForeignBase implements EntityColumnBase {}

@Target({TargetKind.field})
class EntityToOne implements ForeignBase {
  /// Name of the column in database
  final String? name;

  final bool isNullable;

  final bool auto = false;

  /// The field/column in the foreign bean
  final String refCol;

  const EntityToOne({
    this.name,
    this.isNullable = true,
    this.refCol = 'id',
  });
}

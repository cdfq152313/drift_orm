import 'package:analyzer/dart/element/element.dart';

/// Data class to hold primary key field information
class PrimaryKeyRecord {
  final FieldElement field;
  final bool autoIncrement;

  PrimaryKeyRecord(this.field, this.autoIncrement);

  @override
  String toString() =>
      'PrimaryKeyRecord(${field.name}, autoIncrement: $autoIncrement)';
}

/// Data class to hold to-one relationship field information
class ToOneRecord {
  final FieldElement field;
  final String targetType;
  final String? joinColumn;

  ToOneRecord(this.field, this.targetType, this.joinColumn);

  @override
  String toString() =>
      'ToOneRecord(${field.name}, target: $targetType, joinColumn: $joinColumn)';
}

/// Data class to hold column field information
class ColumnRecord {
  final FieldElement field;
  final String? columnName;
  final bool nullable;

  ColumnRecord(this.field, this.columnName, this.nullable);

  @override
  String toString() =>
      'ColumnRecord(${field.name}, name: $columnName, nullable: $nullable)';
}

class TableRecord {
  final String tableName;
  final String className;

  TableRecord(this.tableName, this.className);

  @override
  String toString() => 'TableRecord($tableName, class: $className)';
}

class OrmInfo {
  final ClassElement classElement;
  final String tableName;
  final List<PrimaryKeyRecord> primaryKeys = [];
  final List<ToOneRecord> toOneFields = [];
  final List<ColumnRecord> columnFields = [];

  OrmInfo(this.classElement, this.tableName);

  @override
  String toString() {
    return '''
EntityInfo(
  class: ${classElement.name}
  tableName: $tableName
  primaryKeys: $primaryKeys
  toOneFields: $toOneFields
  columnFields: $columnFields
)''';
  }
}

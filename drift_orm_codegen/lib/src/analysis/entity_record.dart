import 'package:analyzer/dart/element/type.dart';
import 'package:drift_orm/drift_orm.dart';

abstract class FieldRecord {
  FieldRecord({required this.fieldName, required this.type});
  final String fieldName;
  final DartType type;

  String toRow();
}

class PrimaryKeyRecord extends FieldRecord {
  PrimaryKeyRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
  });

  final EntityPrimaryKey annotation;

  @override
  String toRow() {
    return '// PrimaryKey($fieldName, type: $type, autoIncrement: ${annotation.auto})';
  }
}

class EntityColumnRecord extends EntityColumn {
  EntityColumnRecord({
    required super.name,
    required super.isNullable,
    required super.auto,
    super.length,
    this.converterType,
    super.defaultValue,
  });

  // Workaround to hold the converter type. Original annotation only holds Type.
  final DartType? converterType;
}

class ColumnRecord extends FieldRecord {
  ColumnRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
  });
  final EntityColumnRecord annotation;

  @override
  String toRow() {
    return '// Column($fieldName, type: $type, isNullable: ${annotation.isNullable}, auto: ${annotation.auto}, length: ${annotation.length}, defaultValue: ${annotation.defaultValue})';
  }
}

class ToOneRecord extends FieldRecord {
  ToOneRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
  });
  final EntityToOne annotation;

  @override
  String toRow() {
    return '// ToOne($fieldName, type: $type)';
  }
}

class TableRecord {
  final String tableName;
  final String tableClassName;
  final String rowClassName;

  TableRecord({
    required this.tableName,
    required this.tableClassName,
    required this.rowClassName,
  });
}

class OrmInfo {
  final TableRecord tableRecord;
  final List<FieldRecord> fields;

  OrmInfo({
    required this.tableRecord,
    required this.fields,
  });
}

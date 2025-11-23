import 'package:drift_orm/drift_orm.dart';
import 'package:recase/recase.dart';

sealed class FieldRecord {
  FieldRecord({required this.fieldName, required this.type});
  final String fieldName;
  final String type;
}

class PrimaryKeyRecord extends FieldRecord {
  PrimaryKeyRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
  });

  final EntityPrimaryKey annotation;
}

class ConverterRecord {
  ConverterRecord({
    required this.name,
    required this.dbType,
    required this.instanceType,
  });
  final String name;
  final String dbType;
  final String instanceType;
}

class ColumnRecord extends FieldRecord {
  ColumnRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
    required this.converterRecord,
    required this.nullable,
  });
  final EntityColumn annotation;
  final ConverterRecord? converterRecord;
  final bool nullable; // type nullable (not db column)
}

class ToOneRecord extends FieldRecord {
  ToOneRecord({
    required super.fieldName,
    required super.type,
    required this.nullable,
    required this.annotation,
    required this.refColType,
  })  : tableInstanceName = "${ReCase(type).camelCase}s",
        tableName = "${ReCase(type).snakeCase}s";
  final EntityToOne annotation;
  final String refColType;
  final String tableInstanceName;
  final String tableName;
  final bool nullable; // type nullable (not db column)

  String get foreignIdFieldName => '${fieldName}Id';
}

class TableRecord {
  final String tableName;
  final String tableClassName;
  final String tableInstanceName;
  final String rowClassName;
  final String? constructor;

  TableRecord({
    required this.tableName,
    required this.tableClassName,
    required this.rowClassName,
    required this.constructor,
  }) : tableInstanceName = ReCase(tableClassName).camelCase;
}

class OrmInfo {
  final TableRecord tableRecord;
  final List<FieldRecord> fields;

  OrmInfo({
    required this.tableRecord,
    required this.fields,
  });
}

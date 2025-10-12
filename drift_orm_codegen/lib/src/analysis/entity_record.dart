import 'package:analyzer/dart/element/type.dart';
import 'package:drift_orm/drift_orm.dart';

enum DartTypeEnum {
  bool,
  // ignore: constant_identifier_names
  String,
  int,
  double,
  // ignore: constant_identifier_names
  DateTime,
  // ignore: constant_identifier_names
  Uint8List,
}

abstract class FieldRecord {
  FieldRecord({required this.fieldName, required this.type});
  final String fieldName;
  final DartTypeEnum? type;

  String toRow();

  String _dartTypeToColumn(DartTypeEnum? type) {
    switch (type) {
      case DartTypeEnum.bool:
        return 'boolean()';
      case DartTypeEnum.String:
        return 'text()';
      case DartTypeEnum.int:
        return 'integer()';
      case DartTypeEnum.double:
        return 'real()';
      case DartTypeEnum.DateTime:
        return 'datetime()';
      case DartTypeEnum.Uint8List:
        return 'blob()';
      default:
        throw Exception('Unsupported type: $type');
    }
  }
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
    final name = annotation.name != null ? ".named('${annotation.name}')" : '';
    final nullable = annotation.isNullable ? '.nullable()' : '';
    final auto = annotation.auto ? '.autoIncrement()' : '';
    return 'late final $fieldName = ${_dartTypeToColumn(type)}$name$nullable$auto();';
  }
}

class EntityColumnRecord extends EntityColumn {
  EntityColumnRecord({
    required super.name,
    required super.isNullable,
    required super.auto,
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
    return '// Column($fieldName, type: $type, isNullable: ${annotation.isNullable}, auto: ${annotation.auto}, defaultValue: ${annotation.defaultValue})';
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

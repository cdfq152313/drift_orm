import 'package:analyzer/dart/element/type.dart';
import 'package:drift_orm/drift_orm.dart';

abstract class FieldRecord {
  FieldRecord({required this.fieldName, required this.type});
  final String fieldName;
  final DartType type;

  String toRow();

  String _dartTypeToColumn(DartType type) {
    switch (type.getDisplayString()) {
      case 'bool':
        return 'boolean()';
      case 'String':
        return 'text()';
      case 'int':
        return 'integer()';
      case 'double':
        return 'real()';
      case 'DateTime':
        return 'datetime()';
      case 'Uint8List':
        return 'blob()';
      default:
        throw Exception('Unsupported type: ${type.getDisplayString()}');
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
    return 'late final $fieldName = ${_dartTypeToColumn(type)}$auto$name$nullable();';
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

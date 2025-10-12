import 'package:drift_orm/drift_orm.dart';

abstract class FieldRecord {
  FieldRecord({required this.fieldName, required this.type});
  final String fieldName;
  final String type;

  String toRow();

  String tmplPrimitiveType(String type) {
    switch (type) {
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
        throw Exception('Unsupported type: $type');
    }
  }

  String tmplField(String fieldName, List<String> extra) {
    final extraStr = extra.isNotEmpty ? extra.join() : '';
    return 'late final $fieldName = $extraStr();';
  }

  String tmplName(String? name) {
    return name != null ? ".named('$name')" : '';
  }

  String tmplAuto(bool auto) {
    return auto ? '.autoIncrement()' : '';
  }

  String tmplNullable(bool isNullable) {
    return isNullable ? '.nullable()' : '';
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
    return tmplField(
      fieldName,
      [
        tmplPrimitiveType(type),
        tmplName(annotation.name),
        tmplAuto(annotation.auto),
      ],
    );
  }
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
  });
  final EntityColumn annotation;
  final ConverterRecord? converterRecord;

  @override
  String toRow() {
    return tmplField(
      fieldName,
      [
        ...tmplType2(),
        tmplName(annotation.name),
        tmplAuto(annotation.auto),
        tmplNullable(annotation.isNullable),
        tmplDefaultValue(),
      ],
    );
  }

  List<String> tmplType2() {
    if (converterRecord == null) {
      return [tmplPrimitiveType(type)];
    }
    return [
      tmplPrimitiveType(converterRecord!.dbType),
      '.map(const ${converterRecord!.name}())',
    ];
  }

  String tmplDefaultValue() {
    switch (annotation.defaultValue) {
      case null:
        return '';
      case String _:
        return ".withDefault(Constant('${annotation.defaultValue}'))";
      case int _:
      case double _:
      case bool _:
        return ".withDefault(Constant(${annotation.defaultValue}))";
      default:
        throw Exception(
            'Unsupported default value type: ${annotation.defaultValue.runtimeType}');
    }
  }
}

class ToOneRecord extends FieldRecord {
  ToOneRecord({
    required super.fieldName,
    required super.type,
    required this.annotation,
    required this.refColType,
  });
  final EntityToOne annotation;
  final String refColType;

  @override
  String toRow() {
    final fieldName = '${this.fieldName}Id';
    return tmplField(
      fieldName,
      [
        tmplPrimitiveType(refColType),
        tmplReference(),
        tmplName(annotation.name),
        tmplNullable(annotation.isNullable),
      ],
    );
  }

  String tmplReference() {
    return ".references(${type}s, #${annotation.refCol})";
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

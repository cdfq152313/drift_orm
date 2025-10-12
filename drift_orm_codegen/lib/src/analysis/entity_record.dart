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

  String tmplType(DartTypeEnum? type) {
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

  String tmplField(List<String> extra) {
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
    return tmplField([
      tmplType(type),
      tmplName(annotation.name),
      tmplAuto(annotation.auto),
    ]);
  }
}

class ConverterRecord {
  ConverterRecord({
    required this.name,
    required this.dbType,
    required this.instanceType,
  });
  final String name;
  final DartTypeEnum dbType;
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
      return [tmplType(type)];
    }
    return [
      tmplType(converterRecord!.dbType),
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

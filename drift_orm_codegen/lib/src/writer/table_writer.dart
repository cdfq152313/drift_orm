import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class TableWriter extends Writer {
  @override
  String write(OrmInfo orm) {
    return """
@UseRowClass(${orm.tableRecord.rowClassName})
class ${orm.tableRecord.tableClassName} extends OrmTable {
${orm.fields.map((e) => generateFieldRow(e)).join('\n')}
${generateBuildJoinInfo(orm)}
${generatePrimaryKey(orm)}
}""";
  }

  String generateFieldRow(FieldRecord field) {
    switch (field) {
      case PrimaryKeyRecord pk:
        return _generatePrimaryKeyRow(pk);
      case ColumnRecord col:
        return _generateColumnRow(col);
      case ToOneRecord toOne:
        return _generateToOneRow(toOne);
    }
  }

  String _generatePrimaryKeyRow(PrimaryKeyRecord pk) {
    return _tmplField(
      pk.fieldName,
      [
        _tmplPrimitiveType(pk.type),
        _tmplName(pk.annotation.name),
        _tmplAuto(pk.annotation.auto),
      ],
    );
  }

  String _generateColumnRow(ColumnRecord col) {
    return _tmplField(
      col.fieldName,
      [
        ..._tmplColumnType(col),
        _tmplName(col.annotation.name),
        _tmplAuto(col.annotation.auto),
        _tmplNullable(col.annotation.isNullable),
        _tmplDefaultValue(col.annotation.defaultValue),
      ],
    );
  }

  String generateBuildJoinInfo(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final x = toOneColumns.map((c) {
      return "${c.foreignIdFieldName}: tableMap['${c.tableName}']!";
    }).join();
    return '''
  @override
  Map<Column, OrmTable> buildJoinInfo(Map<String, OrmTable> tableMap) {
    return {
      $x
    };
  }
    ''';
  }

  String generatePrimaryKey(OrmInfo orm) {
    final pk = orm.fields.whereType<PrimaryKeyRecord>().first;
    return """
  @override
  Set<Column<Object>> get primaryKey => {${pk.fieldName}};
""";
  }

  String _generateToOneRow(ToOneRecord toOne) {
    final foreignIdFieldName = '${toOne.fieldName}Id';
    return _tmplField(
      foreignIdFieldName,
      [
        _tmplPrimitiveType(toOne.refColType),
        _tmplForeignKey(toOne),
        _tmplName(toOne.annotation.name),
        _tmplNullable(toOne.annotation.isNullable),
      ],
    );
  }

  // Template helper methods
  String _tmplPrimitiveType(String type) {
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

  String _tmplField(String fieldName, List<String> extra) {
    final extraStr = extra.isNotEmpty ? extra.join() : '';
    return 'late final $fieldName = $extraStr();';
  }

  String _tmplName(String? name) {
    return name != null ? ".named('$name')" : '';
  }

  String _tmplAuto(bool auto) {
    return auto ? '.autoIncrement()' : '';
  }

  String _tmplNullable(bool isNullable) {
    return isNullable ? '.nullable()' : '';
  }

  List<String> _tmplColumnType(ColumnRecord col) {
    if (col.converterRecord == null) {
      return [_tmplPrimitiveType(col.type)];
    }
    return [
      _tmplPrimitiveType(col.converterRecord!.dbType),
      '.map(const ${col.converterRecord!.name}())',
    ];
  }

  String _tmplDefaultValue(dynamic defaultValue) {
    switch (defaultValue) {
      case null:
        return '';
      case String _:
        return ".withDefault(Constant('$defaultValue'))";
      case int _:
      case double _:
      case bool _:
        return ".withDefault(Constant($defaultValue))";
      default:
        throw Exception(
            'Unsupported default value type: ${defaultValue.runtimeType}');
    }
  }

  String _tmplForeignKey(ToOneRecord toOne) {
    return ".references(${toOne.type}s, #${toOne.annotation.refCol})";
  }
}

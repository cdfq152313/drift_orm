import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class TableWriter extends Writer {
  @override
  String write(OrmInfo orm) {
    return """
@UseRowClass(${orm.tableRecord.rowClassName})
class ${orm.tableRecord.tableClassName} extends OrmTable<${orm.tableRecord.rowClassName}>{
${orm.fields.map((e) => generateFieldRow(e)).join('\n')}
${generatePrimaryKey(orm)}
${generateBuildJoinInfo(orm)}
${generateExtractRow(orm)}
${generateSaveRows(orm)}
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

  String generatePrimaryKey(OrmInfo orm) {
    final pks = orm.fields.whereType<PrimaryKeyRecord>().toList();
    if (pks.isEmpty) {
      return '';
    }
    if (pks.length > 1) {
      throw Exception(
          'Composite primary keys are not supported yet. (Found ${pks.map((pk) => pk.fieldName).join(", ")})');
    }
    final pk = pks.first;
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

  String generateBuildJoinInfo(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final x = toOneColumns.map((c) {
      return "${c.foreignIdFieldName}: tableMap['${c.tableName}']!";
    }).join(",");
    return '''
  @override
  Map<Column, OrmTable> buildJoinInfo(Map<String, OrmTable> tableMap) {
    return {
      $x
    };
  }
    ''';
  }

  String generateExtractRow(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final joinsExtraction = toOneColumns.map((c) {
      return '''
    result.${c.fieldName} = tableMap['${c.tableName}']!.extractRow(tableMap, row);''';
    }).join();

    return '''
  @override
  ${orm.tableRecord.rowClassName}? extractRow(Map<String, OrmTable> tableMap, TypedResult row) {
    final result = row.readTableOrNull(this as TableInfo) as ${orm.tableRecord.rowClassName}?;
    if (result == null) {
      return null;
    }
    $joinsExtraction
    return result;
  }
''';
  }

  String generateSaveRows(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final joinsSave = toOneColumns.map((c) {
      return '''
    final ${c.fieldName}s = instances.map((e) => e.${c.fieldName}).whereType<${c.type}>().toList();
    if (${c.fieldName}s.isNotEmpty) {
      tableMap['${c.tableName}']!.saveRows(batch, tableMap, ${c.fieldName}s);
    }''';
    }).join();

    return '''
  @override
  void saveRows(Batch batch, Map<String, OrmTable> tableMap, List<${orm.tableRecord.rowClassName}> instances) {
    $joinsSave
    batch.insertAll(this as TableInfo, instances, mode: InsertMode.insertOrReplace);
  }
''';
  }
}

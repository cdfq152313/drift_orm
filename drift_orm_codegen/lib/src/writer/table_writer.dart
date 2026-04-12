import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/options.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class TableWriter extends Writer {
  @override
  String write(OrmInfo orm, Options options) {
    return """
${generateRowClass(orm.tableRecord)}
class ${orm.tableRecord.tableClassName} extends OrmTable<${orm.tableRecord.rowClassName}>{
${orm.fields.map((e) => generateFieldRow(e)).join('\n')}
${generatePrimaryKey(orm)}
${generateGetJoins(orm)}
${generateExtractRow(orm)}
${generateSaveRows(orm)}
}""";
  }

  String generateRowClass(TableRecord table) {
    return "@UseRowClass(${table.rowClassName}${table.constructor != null ? ', constructor: "${table.constructor}"' : ''})";
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
        _tmplClientDefault(col.annotation.clientDefault),
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
        return 'dateTime()';
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
          'Unsupported default value type: ${defaultValue.runtimeType}',
        );
    }
  }

  String _tmplClientDefault(Object? clientDefault) {
    switch (clientDefault) {
      case null:
        return '';
      case String _:
        return ".clientDefault(() => '$clientDefault')";
      case int _:
      case double _:
      case bool _:
        return ".clientDefault(() => $clientDefault)";
      default:
        throw Exception(
          'Unsupported default value type: ${clientDefault.runtimeType}',
        );
    }
  }

  String _tmplForeignKey(ToOneRecord toOne) {
    return ".references(${toOne.type}s, #${toOne.annotation.refCol})";
  }

  String generateGetJoins(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final joins = toOneColumns.map((c) {
      final aliasTableVariable = '${c.fieldName}Alias';
      return """
    final $aliasTableVariable = accessor.alias(tableMap['${c.tableName}'] as \$${c.type}sTable, '\${prefix}_${c.foreignIdFieldName}');
    joins.add(JoinPart(
      '${c.foreignIdFieldName}',
      $aliasTableVariable,
      leftOuterJoin($aliasTableVariable, $aliasTableVariable.id.equalsExp(${c.foreignIdFieldName})),
      [...$aliasTableVariable.getJoins(accessor, $aliasTableVariable.aliasedName, tableMap)],
    ));
    """;
    }).join("\n\n");
    return '''
@override
List<JoinPart> getJoins(
    DatabaseConnectionUser accessor,
    String prefix,
    Map<String, OrmTable> tableMap,
  ) {
    final joins = <JoinPart>[];
    $joins
    return joins;
  }
''';
  }

  String generateExtractRow(OrmInfo orm) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();
    final joinsExtraction = toOneColumns.map((c) {
      return '''
    final ${c.fieldName}Join = joinParts.firstWhere((join) => join.columnName == '${c.foreignIdFieldName}');
    result.${c.fieldName} = (${c.fieldName}Join.aliasTable as ${c.type}s).extractRow(${c.fieldName}Join.children, row)${c.nullable ? '' : '!'};''';
    }).join();

    return '''
  @override
  ${orm.tableRecord.rowClassName}? extractRow(List<JoinPart> joinParts, TypedResult row) {
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

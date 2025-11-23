import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/options.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class DbInstanceInitWriter extends Writer {
  @override
  String write(OrmInfo orm, Options options) {
    return """
${orm.tableRecord.rowClassName} ${orm.tableRecord.rowClassName}DbInit(${orm.tableRecord.rowClassName} instance, {
${_availableRecords(orm).map((e) => _generateFactoryParameter(e)).join(',\n')},
}) {
  ${_availableRecords(orm).map((e) => _generateAssignment(e)).join('\n')}
  return instance;
}
""";
  }

  Iterable<FieldRecord> _availableRecords(OrmInfo orm) {
    return orm.fields.where((record) => switch (record) {
          ColumnRecord() => true,
          ToOneRecord() => false,
          PrimaryKeyRecord() => true,
        });
  }

  String _generateFactoryParameter(FieldRecord e) {
    return 'required ${e.type}? ${e.fieldName}';
  }

  String _generateAssignment(FieldRecord e) {
    final nullable = switch (e) {
      ColumnRecord() => e.nullable,
      ToOneRecord() => e.nullable,
      PrimaryKeyRecord() => false,
    };
    return "instance.${e.fieldName} = ${e.fieldName}${nullable ? "" : "!"};";
  }
}

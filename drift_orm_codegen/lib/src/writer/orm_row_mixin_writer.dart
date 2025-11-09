import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/options.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class OrmRowMixinWriter extends Writer {
  @override
  String write(OrmInfo orm, Options options) {
    final toOneFields = orm.fields.whereType<ToOneRecord>();
    return """
mixin _\$${orm.tableRecord.rowClassName}OrmRowMixin {
  ${toOneFields.expand((e) => generateForeignKeyField(e)).join('\n')}
}
""";
  }

  List<String> generateForeignKeyField(ToOneRecord toOne) {
    return [
      _tmplForeignField(toOne),
      _tmplForeignId(toOne),
    ];
  }

  String _tmplForeignField(ToOneRecord toOne) {
    final type = toOne.nullable ? '${toOne.type}?' : toOne.type;
    return "$type get ${toOne.fieldName};";
  }

  String _tmplForeignId(ToOneRecord toOne) {
    final refColType =
        toOne.nullable ? '${toOne.refColType}?' : toOne.refColType;
    final fieldName = toOne.nullable ? '${toOne.fieldName}?' : toOne.fieldName;
    final foreignIdFieldName = '${toOne.fieldName}Id';
    return "$refColType get $foreignIdFieldName => $fieldName.${toOne.annotation.refCol};";
  }
}

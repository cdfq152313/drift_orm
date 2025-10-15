import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/writer/writer.dart';

class OrmDaoMixinWriter extends Writer {
  @override
  String write(OrmInfo orm) {
    final buffer = StringBuffer();
    buffer.writeln(
      "mixin _\$${orm.tableRecord.tableClassName}OrmMixin on _\$${orm.tableRecord.tableClassName}DaoMixin {",
    );

    _writeUpsert(orm, buffer);

    buffer.writeln("}");
    return buffer.toString();
  }

  void _writeUpsert(OrmInfo orm, StringBuffer buffer) {
    final toOneColumns = orm.fields.whereType<ToOneRecord>();

    buffer.writeln(
      'Future upsert(${orm.tableRecord.rowClassName} instance) {',
    );

    buffer.writeln('return transaction(() async {');
    for (final column in toOneColumns) {
      buffer.writeln(
        'await instance.${column.fieldName}${column.nullable ? '?' : ''}.save();',
      );
    }

    buffer.writeln(
      'await into(${orm.tableRecord.tableInstanceName}).insert(instance, mode: InsertMode.insertOrReplace);',
    );

    buffer.writeln('});');
    buffer.writeln('}');
  }

  // void _writeUpsertAll(OrmInfo orm, StringBuffer buffer) {
  //   buffer.write(
  //       'Future upsertAll(List<${table.dartTypeName}> instances) async {\n');
  //   final toOneColumns =
  //       table.columns.where((c) => c.features.any((f) => f is ToOne));

  //   for (final column in toOneColumns) {
  //     final entityType = column.getToOne()!.referencedTable.entityClass!.name;
  //     final whereNotNull = column.nullable ? '.whereType<$entityType>()' : '';
  //     buffer.write(
  //         'await instances.map((instance) => instance.${column.fieldName})$whereNotNull.toList().saveAll();\n');
  //   }

  //   buffer.write(
  //       'await batch((b) => b.insertAll(${table.dbGetterName}, instances, mode: InsertMode.insertOrReplace));\n');

  //   buffer.write('}\n');
  // }

  // void _writeLoadAll(OrmInfo orm, StringBuffer buffer) {
  //   final tableClassName = table.entityInfoName;

  //   buffer.write(
  //       'Future<List<${table.dartTypeName}>> loadAll({WhereFilter<$tableClassName>? where, '
  //       'int? limit, int? offset, List<OrderClauseGenerator<$tableClassName>>? orderBy}) {\n');

  //   buffer.write('final statement = select(${table.dbGetterName});\n');
  //   buffer.write('if (where != null) {\n');
  //   buffer.write('statement.where(where);\n');
  //   buffer.write('}\n');

  //   buffer.write('if (orderBy != null) {\n');
  //   buffer.write('statement.orderBy(orderBy);\n');
  //   buffer.write('}\n');

  //   buffer.write('final joins = ${table.dbGetterName}.getJoins();\n');

  //   buffer.write('if (joins.length == 0) {\n');
  //   buffer.write('if (limit != null) {\n');
  //   buffer.write('statement.limit(limit, offset: offset);\n');
  //   buffer.write('}\n');
  //   buffer.write('return statement.get();\n');
  //   buffer.write('} else {\n');
  //   buffer.write('final joinedStatement = statement.join(joins);\n');
  //   buffer.write('if (limit != null) {\n');
  //   buffer.write('joinedStatement.limit(limit, offset: offset);\n');
  //   buffer.write('}\n');
  //   buffer.write('return joinedStatement.get().then((rows) {\n');
  //   buffer.write(
  //       'return rows.map((row) => row.readTable(${table.dbGetterName})).toList();\n');
  //   buffer.write('});\n');
  //   buffer.write('}\n');

  //   buffer.write('}\n');
  // }

  // void _writeLoad(OrmInfo orm, StringBuffer buffer) {
  //   buffer.write('Future<${table.dartTypeName}?> load(key) async {\n');
  //   buffer.write('final statement = select(${table.dbGetterName});\n');
  //   buffer.write(
  //       'statement.where((table) => table.primaryKey.first.equals(key));\n');
  //   buffer.write('final joins = ${table.dbGetterName}.getJoins();\n');
  //   buffer.write('final list = await (joins.length == 0\n');
  //   buffer.write('? statement.get()\n');
  //   buffer.write(': statement.join(joins).get().then((rows) {\n');
  //   buffer.write(
  //       'return rows.map((row) => row.readTable(${table.dbGetterName})).toList();\n');
  //   buffer.write('}));\n');
  //   buffer.write('return list.length > 0 ? list.first : null;\n');
  //   buffer.write('}\n');
  // }

  // void _writePartialUpdate(OrmInfo orm, StringBuffer buffer) {
  //   final tableClassName = table.entityInfoName;

  //   buffer.write(
  //       'Future<int> partialUpdate(${tableClassName}Companion companion, {WhereFilter<$tableClassName>? where}) {\n');

  //   buffer.write('final statement = update(${table.dbGetterName});\n');
  //   buffer.write('if (where != null) {\n');
  //   buffer.write('statement.where(where);\n');
  //   buffer.write('}\n');

  //   buffer.write('return statement.write(companion);\n');

  //   buffer.write('}\n');
  // }
}

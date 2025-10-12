import 'package:analyzer/dart/element/element.dart';
import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class EntityParser {
  static const _primaryKeyChecker = TypeChecker.typeNamed(EntityPrimaryKey);
  static const _toOneChecker = TypeChecker.typeNamed(EntityToOne);
  static const _columnChecker = TypeChecker.typeNamed(EntityColumn);

  /// Parse the entity class and extract annotation information
  OrmInfo parse(
    ClassElement element,
    ConstantReader entityAnnotation,
  ) {
    final tableRecord = _parseTable(element);
    final fields = <FieldRecord>[];
    for (final field in element.fields) {
      // Skip static fields and synthetic fields
      if (field.isStatic) continue;

      // Check for EntityPrimaryKey annotation
      final primaryKeyAnnotation = _primaryKeyChecker.firstAnnotationOf(field);
      if (primaryKeyAnnotation != null) {
        final reader = ConstantReader(primaryKeyAnnotation);
        fields.add(PrimaryKeyRecord(
          fieldName: field.name!,
          type: field.type,
          annotation: EntityPrimaryKey(
            name: reader.peek('name')?.stringValue,
            auto: reader.peek('auto')!.boolValue,
            length: reader.peek('length')?.intValue,
          ),
        ));
        continue;
      }

      final columnAnnotation = _columnChecker.firstAnnotationOf(field);
      if (columnAnnotation != null) {
        final reader = ConstantReader(columnAnnotation);
        fields.add(
          ColumnRecord(
            fieldName: field.name!,
            type: field.type,
            annotation: EntityColumnRecord(
              name: reader.peek('name')?.stringValue,
              isNullable: reader.peek('isNullable')!.boolValue,
              auto: reader.peek('auto')!.boolValue,
              length: reader.peek('length')?.intValue,
              converterType: reader.peek('converter')?.typeValue,
              defaultValue: reader.peek('defaultValue')?.stringValue,
            ),
          ),
        );
        continue;
      }

      final toOneAnnotation = _toOneChecker.firstAnnotationOf(field);
      if (toOneAnnotation != null) {
        final reader = ConstantReader(toOneAnnotation);
        fields.add(ToOneRecord(
          fieldName: field.name!,
          type: field.type,
          annotation: EntityToOne(
            name: reader.peek('name')?.stringValue,
            isNullable: reader.peek('isNullable')!.boolValue,
            length: reader.peek('length')?.intValue,
            refCol: reader.peek('refCol')!.stringValue,
          ),
        ));
        continue;
      }
    }

    return OrmInfo(tableRecord: tableRecord, fields: fields);
  }

  TableRecord _parseTable(ClassElement element) {
    final rowClassName = element.name!;
    final recase = ReCase(rowClassName);
    final tableClassName = "${rowClassName}s";
    final tableName = "${recase.snakeCase}s";
    return TableRecord(
      tableName: tableName,
      tableClassName: tableClassName,
      rowClassName: rowClassName,
    );
  }

  // String _typeToColumnType(DartType type) {
  //   return const {
  //     'bool': ColumnType.boolean,
  //     'String': ColumnType.text,
  //     'int': ColumnType.integer,
  //     'double': ColumnType.real,
  //     'DateTime': ColumnType.datetime,
  //     'Uint8List': ColumnType.blob,
  //   }[type.name]!;
  // }
}

class _Group {
  final List<FieldElement> primaryKeys = [];
  final List<FieldElement> columns = [];
  final List<FieldElement> toOnes = [];
}

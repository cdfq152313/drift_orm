import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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
    // Read table name from Entity annotation
    final tableName = _parseTableName(element);

    final entityInfo = OrmInfo(element, tableName);

    // Scan all fields in the class
    for (final field in element.fields) {
      // Skip static fields and synthetic fields
      if (field.isStatic || field.isSynthetic) continue;

      // Check for EntityPrimaryKey annotation
      final primaryKeyAnnotation = _primaryKeyChecker.firstAnnotationOf(field);
      if (primaryKeyAnnotation != null) {
        final reader = ConstantReader(primaryKeyAnnotation);
        final autoIncrement = reader.peek('autoIncrement')?.boolValue ?? false;
        entityInfo.primaryKeys.add(PrimaryKeyRecord(field, autoIncrement));
        continue; // Primary key fields don't need to be processed as columns
      }

      // Check for EntityToOne annotation
      final toOneAnnotation = _toOneChecker.firstAnnotationOf(field);
      if (toOneAnnotation != null) {
        final reader = ConstantReader(toOneAnnotation);
        final targetType = reader.read('target').typeValue.toString();
        final joinColumn = reader.peek('joinColumn')?.stringValue;
        entityInfo.toOneFields.add(ToOneRecord(field, targetType, joinColumn));
        continue; // Relationship fields don't need to be processed as columns
      }

      // Check for EntityColumn annotation
      final columnAnnotation = _columnChecker.firstAnnotationOf(field);
      if (columnAnnotation != null) {
        final reader = ConstantReader(columnAnnotation);
        final columnName = reader.peek('name')?.stringValue;
        final nullable = reader.peek('nullable')?.boolValue ?? false;
        entityInfo.columnFields.add(ColumnRecord(field, columnName, nullable));
      } else {
        // Fields without annotations are treated as regular columns with default settings
        entityInfo.columnFields.add(ColumnRecord(field, null, false));
      }
    }

    return entityInfo;
  }

  String _parseTableName(ClassElement element) {
    return "${ReCase(element.name!).snakeCase}s";
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

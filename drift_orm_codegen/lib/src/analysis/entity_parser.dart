import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:drift/drift.dart';
import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class EntityParser {
  static const _primaryKeyChecker = TypeChecker.fromRuntime(EntityPrimaryKey);
  static const _toOneChecker = TypeChecker.fromRuntime(EntityToOne);
  static const _columnChecker = TypeChecker.fromRuntime(EntityColumn);
  static const _converterChecker = TypeChecker.fromRuntime(TypeConverter);

  /// Parse the entity class and extract annotation information
  OrmInfo parse(
    ClassElement element,
    ConstantReader entityAnnotation,
  ) {
    final tableRecord = _parseTable(element);
    final fields = <FieldRecord>[];

    // Get all fields including those from mixins and superclasses
    final allFields = _getAllFields(element);

    for (final field in allFields) {
      // Skip static fields and synthetic fields
      if (field.isStatic) continue;

      // Check for EntityPrimaryKey annotation
      final primaryKeyAnnotation = _primaryKeyChecker.firstAnnotationOf(field);
      if (primaryKeyAnnotation != null) {
        final reader = ConstantReader(primaryKeyAnnotation);
        fields.add(PrimaryKeyRecord(
          fieldName: field.name!,
          type: field.type.nonNullableType(),
          annotation: EntityPrimaryKey(
            name: reader.peek('name')?.stringValue,
            auto: reader.peek('auto')!.boolValue,
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
            type: field.type.nonNullableType(),
            annotation: EntityColumn(
              name: reader.peek('name')?.stringValue,
              isNullable: reader.peek('isNullable')!.boolValue,
              auto: reader.peek('auto')!.boolValue,
              defaultValue: _parseDefaultValue(reader.peek('defaultValue')),
            ),
            converterRecord:
                _tryParseConverter(reader.peek('converter')?.typeValue),
          ),
        );
        continue;
      }

      final toOneAnnotation = _toOneChecker.firstAnnotationOf(field);
      if (toOneAnnotation != null) {
        final reader = ConstantReader(toOneAnnotation);
        fields.add(
          ToOneRecord(
            fieldName: field.name!,
            type: field.type.nonNullableType(),
            nullable:
                field.type.nullabilitySuffix == NullabilitySuffix.question,
            annotation: EntityToOne(
              name: reader.peek('name')?.stringValue,
              isNullable: reader.peek('isNullable')!.boolValue,
              refCol: reader.peek('refCol')!.stringValue,
            ),
            refColType: _parseReferenceType(
              field.type,
              reader.peek('refCol')!.stringValue,
            ),
          ),
        );
        continue;
      }
    }

    return OrmInfo(tableRecord: tableRecord, fields: fields);
  }

  /// Get all fields from the class including those from mixins and superclasses
  List<FieldElement> _getAllFields(ClassElement element) {
    final allFields = <String, FieldElement>{};

    // Add fields from the class itself
    for (final field in element.fields) {
      final fieldName = field.name;
      if (fieldName != null) {
        allFields[fieldName] = field;
      }
    }

    // Add fields from mixins and superclasses
    for (final type in element.allSupertypes) {
      if (type.element is MixinElement || type.element is ClassElement) {
        final classElement = type.element;
        // Skip Object class
        if (classElement.name == 'Object') continue;

        for (final field in classElement.fields) {
          final fieldName = field.name;
          if (fieldName != null) {
            // Only add if not already present (class fields override mixin fields)
            if (!allFields.containsKey(fieldName)) {
              allFields[fieldName] = field;
            }
          }
        }
      }
    }

    return allFields.values.toList();
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

  ConverterRecord? _tryParseConverter(DartType? type) {
    if (type is! InterfaceType) {
      return null;
    }
    final converterType = type.allSupertypes
        .firstWhere((t) => _converterChecker.isExactlyType(t));

    return ConverterRecord(
      name: type.getDisplayString(),
      dbType: converterType.typeArguments.last.getDisplayString(),
      instanceType: converterType.typeArguments.first.getDisplayString(),
    );
  }

  Object? _parseDefaultValue(ConstantReader? peek) {
    if (peek == null || peek.isNull) return null;
    if (peek.isInt) return peek.intValue;
    if (peek.isDouble) return peek.doubleValue;
    if (peek.isString) return peek.stringValue;
    if (peek.isBool) return peek.boolValue;
    throw Exception(
        'Unsupported default value type: ${peek.objectValue.type?.getDisplayString()}');
  }

  String _parseReferenceType(DartType type, String refCol) {
    if (type is! InterfaceType) {
      throw Exception('Unsupported reference type: ${type.getDisplayString()}');
    }
    final field = type.element.fields.firstWhere((f) => f.name == refCol);
    return field.type.getDisplayString();
  }
}

extension DartTypeExtension on DartType {
  String nonNullableType() =>
      (element?.library?.typeSystem.promoteToNonNull(this) ?? this)
          .getDisplayString();
}

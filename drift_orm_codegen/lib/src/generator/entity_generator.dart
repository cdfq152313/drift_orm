import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_parser.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:source_gen/source_gen.dart';

class EntityGenerator extends GeneratorForAnnotation<Entity> {
  final EntityParser _parser = EntityParser();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Entity annotation can only be applied to classes.',
        element: element,
      );
    }

    final entityInfo = _parser.parse(element, annotation);
    return generateEntityCode(entityInfo);
  }

  /// Generate code based on parsed entity information
  String generateEntityCode(OrmInfo orm) {
    return """
@UseRowClass(${orm.tableRecord.rowClassName})
class ${orm.tableRecord.tableClassName} extends Table {

}
""";
  }
}

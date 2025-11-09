import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_parser.dart';
import 'package:drift_orm_codegen/src/options.dart';
import 'package:drift_orm_codegen/src/writer/orm_dao_mixin_writer.dart';
import 'package:drift_orm_codegen/src/writer/orm_row_mixin_writer.dart';
import 'package:drift_orm_codegen/src/writer/table_writer.dart';
import 'package:source_gen/source_gen.dart';

class EntityGenerator extends GeneratorForAnnotation<Entity> {
  EntityGenerator(this.options);

  final EntityParser _parser = EntityParser();
  final _dartfmt = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  );
  final _writers = [
    TableWriter(),
    OrmRowMixinWriter(),
    OrmDaoMixinWriter(),
  ];

  final Options options;

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
    final result =
        _writers.map((writer) => writer.write(entityInfo, options)).join('\n');
    return _dartfmt.format(result);
  }
}

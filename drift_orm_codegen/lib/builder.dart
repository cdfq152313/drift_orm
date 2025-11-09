import 'package:build/build.dart';
import 'package:drift_orm_codegen/src/generator/entity_generator.dart';
import 'package:drift_orm_codegen/src/options.dart';
import 'package:source_gen/source_gen.dart';

/// Creates the builder for drift_orm code generation
Builder driftOrmBuilder(BuilderOptions options) {
  final typedOptions = Options(
    modular: options.config['modular'] as bool? ?? false,
  );
  return PartBuilder([EntityGenerator(typedOptions)], '.drift_orm.g.dart');
}

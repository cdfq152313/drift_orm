import 'package:build/build.dart';
import 'package:drift_orm_codegen/src/generator/entity_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'src/drift_orm_codegen_base.dart';

/// Creates the builder for drift_orm code generation
Builder driftOrmBuilder(BuilderOptions options) {
  return PartBuilder(
    [HelloWorldGenerator(), EntityGenerator()],
    '.drift_orm.g.dart',
  );
}

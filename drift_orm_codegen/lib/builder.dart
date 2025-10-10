import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/drift_orm_codegen_base.dart';

/// Creates the builder for drift_orm code generation
Builder driftOrmBuilder(BuilderOptions options) {
  return SharedPartBuilder([HelloWorldGenerator()], 'drift_orm');
}

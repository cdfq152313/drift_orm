import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/options.dart';

abstract class Writer {
  String write(OrmInfo orm, Options options);
}

import 'package:drift_orm_codegen/src/analysis/entity_record.dart';

abstract class Writer {
  String write(OrmInfo orm);
}

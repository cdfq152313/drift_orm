import 'package:analyzer/dart/element/element.dart';

class PrimaryKeyRecord {
  final FieldElement field;
  final bool autoIncrement;

  PrimaryKeyRecord(this.field, this.autoIncrement);
}

class ColumnRecord {
  final FieldElement field;
  final String? columnName;
  final bool nullable;

  ColumnRecord(this.field, this.columnName, this.nullable);
}

class ToOneRecord {
  final FieldElement field;
  final String targetType;
  final String? joinColumn;

  ToOneRecord(this.field, this.targetType, this.joinColumn);
}

class TableRecord {
  final String tableName;
  final String tableClassName;
  final String rowClassName;

  TableRecord({
    required this.tableName,
    required this.tableClassName,
    required this.rowClassName,
  });
}

class OrmInfo {
  final TableRecord tableRecord;
  final List<PrimaryKeyRecord> primaryKeys = [];
  final List<ToOneRecord> toOneFields = [];
  final List<ColumnRecord> columnFields = [];

  OrmInfo(this.tableRecord);
}

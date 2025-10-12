import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:test/test.dart';

import '../basic.dart';

void main() {
  group('PrimaryKeyRecord', () {
    final testCases = [
      TestCase(
        name: 'No argument',
        input: EntityPrimaryKey(),
        expected: "late final id = integer()();",
      ),
      TestCase(
        name: 'Custom name',
        input: EntityPrimaryKey(name: 'custom_id'),
        expected: "late final id = integer().named('custom_id')();",
      ),
      TestCase(
        name: 'Auto increment',
        input: EntityPrimaryKey(auto: true),
        expected: "late final id = integer().autoIncrement()();",
      ),
    ];

    for (final tc in testCases) {
      test(tc.name, () {
        final record = PrimaryKeyRecord(
          fieldName: 'id',
          type: DartTypeEnum.int,
          annotation: tc.input,
        );
        expect(record.toRow(), equals(tc.expected));
      });
    }
  });

  group('ColumnRecord', () {
    final testCases = [
      TestCase(
        name: 'Basic text column',
        input: (
          annotation: EntityColumn(isNullable: false),
          type: DartTypeEnum.String,
          converter: null,
        ),
        expected: "late final name = text()();",
      ),
      TestCase(
        name: 'Custom column name',
        input: (
          annotation: EntityColumn(name: 'user_name', isNullable: false),
          type: DartTypeEnum.String,
          converter: null,
        ),
        expected: "late final name = text().named('user_name')();",
      ),
      TestCase(
        name: 'Nullable column',
        input: (
          annotation: EntityColumn(isNullable: true),
          type: DartTypeEnum.String,
          converter: null,
        ),
        expected: "late final name = text().nullable()();",
      ),
      TestCase(
        name: 'Auto increment column',
        input: (
          annotation: EntityColumn(auto: true, isNullable: false),
          type: DartTypeEnum.int,
          converter: null,
        ),
        expected: "late final name = integer().autoIncrement()();",
      ),
      TestCase(
        name: 'Column with all options',
        input: (
          annotation: EntityColumn(
            name: 'created_at',
            auto: false,
            isNullable: true,
          ),
          type: DartTypeEnum.DateTime,
          converter: null,
        ),
        expected:
            "late final name = datetime().named('created_at').nullable()();",
      ),
      TestCase(
        name: 'Column with converter',
        input: (
          annotation: EntityColumn(isNullable: false),
          type: DartTypeEnum.String,
          converter: ConverterRecord(
            name: 'JsonConverter',
            dbType: DartTypeEnum.String,
            instanceType: 'Map<String, dynamic>',
          ),
        ),
        expected: "late final name = text().map(const JsonConverter())();",
      ),
      TestCase(
        name: 'Default value - string',
        input: (
          annotation: EntityColumn(isNullable: false, defaultValue: "123"),
          type: DartTypeEnum.String,
          converter: null,
        ),
        expected: "late final name = text().withDefault(Constant('123'))();",
      ),
      TestCase(
        name: 'Default value - primitive',
        input: (
          annotation: EntityColumn(isNullable: false, defaultValue: 123),
          type: DartTypeEnum.String,
          converter: null,
        ),
        expected: "late final name = text().withDefault(Constant(123))();",
      )
    ];

    for (final tc in testCases) {
      test(tc.name, () {
        final record = ColumnRecord(
          fieldName: 'name',
          type: tc.input.type,
          annotation: tc.input.annotation,
          converterRecord: tc.input.converter,
        );
        expect(record.toRow(), equals(tc.expected));
      });
    }
  });
}

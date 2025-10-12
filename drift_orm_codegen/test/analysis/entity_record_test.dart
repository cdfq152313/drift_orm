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
}

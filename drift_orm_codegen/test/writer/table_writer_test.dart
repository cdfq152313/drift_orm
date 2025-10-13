import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/writer/table_writer.dart';
import 'package:test/test.dart';

import '../basic.dart';

void main() {
  group('TableWriter - PrimaryKeyRecord generation', () {
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
        final writer = TableWriter();
        final record = PrimaryKeyRecord(
          fieldName: 'id',
          type: 'int',
          annotation: tc.input,
        );
        final result = writer.generateFieldRow(record);
        expect(result, equals(tc.expected));
      });
    }
  });

  group('TableWriter - ColumnRecord generation', () {
    final testCases = [
      TestCase(
        name: 'Basic text column',
        input: (
          annotation: EntityColumn(isNullable: false),
          type: 'String',
          converter: null,
        ),
        expected: "late final name = text()();",
      ),
      TestCase(
        name: 'Custom column name',
        input: (
          annotation: EntityColumn(name: 'user_name', isNullable: false),
          type: 'String',
          converter: null,
        ),
        expected: "late final name = text().named('user_name')();",
      ),
      TestCase(
        name: 'Nullable column',
        input: (
          annotation: EntityColumn(isNullable: true),
          type: 'String',
          converter: null,
        ),
        expected: "late final name = text().nullable()();",
      ),
      TestCase(
        name: 'Auto increment column',
        input: (
          annotation: EntityColumn(auto: true, isNullable: false),
          type: 'int',
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
          type: 'DateTime',
          converter: null,
        ),
        expected:
            "late final name = datetime().named('created_at').nullable()();",
      ),
      TestCase(
        name: 'Column with converter',
        input: (
          annotation: EntityColumn(isNullable: false),
          type: 'String',
          converter: ConverterRecord(
            name: 'JsonConverter',
            dbType: 'String',
            instanceType: 'Map<String, dynamic>',
          ),
        ),
        expected: "late final name = text().map(const JsonConverter())();",
      ),
      TestCase(
        name: 'Default value - string',
        input: (
          annotation: EntityColumn(isNullable: false, defaultValue: "123"),
          type: 'String',
          converter: null,
        ),
        expected: "late final name = text().withDefault(Constant('123'))();",
      ),
      TestCase(
        name: 'Default value - primitive',
        input: (
          annotation: EntityColumn(isNullable: false, defaultValue: 123),
          type: 'String',
          converter: null,
        ),
        expected: "late final name = text().withDefault(Constant(123))();",
      )
    ];

    for (final tc in testCases) {
      test(tc.name, () {
        final writer = TableWriter();
        final record = ColumnRecord(
          fieldName: 'name',
          type: tc.input.type,
          annotation: tc.input.annotation,
          converterRecord: tc.input.converter,
        );
        final result = writer.generateFieldRow(record);
        expect(result, equals(tc.expected));
      });
    }
  });

  group('TableWriter - ToOneRecord generation', () {
    final testCases = [
      TestCase(
        name: 'Basic to-one relationship with int reference',
        input: (
          annotation: EntityToOne(isNullable: false),
          type: 'User',
          refColType: 'int',
        ),
        expected: "late final userId = integer().references(Users, #id)();",
      ),
      TestCase(
        name: 'Nullable to-one relationship',
        input: (
          annotation: EntityToOne(isNullable: true),
          type: 'Profile',
          refColType: 'int',
        ),
        expected:
            "late final profileId = integer().references(Profiles, #id).nullable()();",
      ),
      TestCase(
        name: 'To-one with custom column name',
        input: (
          annotation: EntityToOne(name: 'owner_id', isNullable: false),
          type: 'User',
          refColType: 'int',
        ),
        expected:
            "late final userId = integer().references(Users, #id).named('owner_id')();",
      ),
      TestCase(
        name: 'To-one with custom reference column',
        input: (
          annotation: EntityToOne(refCol: 'uuid', isNullable: false),
          type: 'Category',
          refColType: 'String',
        ),
        expected:
            "late final categoryId = text().references(Categorys, #uuid)();",
      ),
    ];

    for (final tc in testCases) {
      test(tc.name, () {
        final writer = TableWriter();
        final record = ToOneRecord(
          fieldName: tc.input.type.toLowerCase(),
          type: tc.input.type,
          nullable: false,
          annotation: tc.input.annotation,
          refColType: tc.input.refColType,
        );
        final result = writer.generateFieldRow(record);
        expect(result, equals(tc.expected));
      });
    }
  });

  group('TableWriter - Full table generation', () {
    test('Complete table with mixed field types', () {
      final writer = TableWriter();
      final tableRecord = TableRecord(
        tableName: 'posts',
        tableClassName: 'Posts',
        rowClassName: 'Post',
      );

      final fields = <FieldRecord>[
        PrimaryKeyRecord(
          fieldName: 'id',
          type: 'int',
          annotation: EntityPrimaryKey(auto: true),
        ),
        ColumnRecord(
          fieldName: 'title',
          type: 'String',
          annotation: EntityColumn(isNullable: false),
          converterRecord: null,
        ),
        ColumnRecord(
          fieldName: 'content',
          type: 'String',
          annotation: EntityColumn(isNullable: true),
          converterRecord: null,
        ),
        ToOneRecord(
          fieldName: 'author',
          type: 'User',
          nullable: false,
          annotation: EntityToOne(isNullable: false),
          refColType: 'int',
        ),
      ];

      final ormInfo = OrmInfo(
        tableRecord: tableRecord,
        fields: fields,
      );

      final result = writer.write(ormInfo);
      
      expect(result, contains('@UseRowClass(Post)'));
      expect(result, contains('class Posts extends Table {'));
      expect(result, contains('late final id = integer().autoIncrement()();'));
      expect(result, contains('late final title = text()();'));
      expect(result, contains('late final content = text().nullable()();'));
      expect(result, contains('late final authorId = integer().references(Users, #id)();'));
    });
  });
}
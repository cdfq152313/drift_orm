import 'package:drift_orm/drift_orm.dart';
import 'package:drift_orm_codegen/src/analysis/entity_record.dart';
import 'package:drift_orm_codegen/src/writer/foreign_key_writer.dart';
import 'package:test/test.dart';

import '../basic.dart';

void main() {
  group('ForeignKeyWriter - Foreign key field generation', () {
    final testCases = [
      TestCase(
        name: 'Non-nullable relationship with default refCol',
        input: ToOneRecord(
          fieldName: 'user',
          type: 'User',
          nullable: false,
          annotation: EntityToOne(isNullable: false),
          refColType: 'int',
        ),
        expected: ["User get user;", "int get userId => user.id;"],
      ),
      TestCase(
        name: 'Nullable relationship with default refCol',
        input: ToOneRecord(
          fieldName: 'profile',
          type: 'Profile',
          nullable: true,
          annotation: EntityToOne(isNullable: true),
          refColType: 'int',
        ),
        expected: [
          "Profile? get profile;",
          "int? get profileId => profile?.id;"
        ],
      ),
      TestCase(
        name: 'Non-nullable relationship with custom refCol',
        input: ToOneRecord(
          fieldName: 'category',
          type: 'Category',
          nullable: false,
          annotation: EntityToOne(refCol: 'uuid', isNullable: false),
          refColType: 'String',
        ),
        expected: [
          "Category get category;",
          "String get categoryId => category.uuid;"
        ],
      ),
      TestCase(
        name: 'Nullable relationship with custom refCol',
        input: ToOneRecord(
          fieldName: 'department',
          type: 'Department',
          nullable: true,
          annotation: EntityToOne(refCol: 'code', isNullable: true),
          refColType: 'String',
        ),
        expected: [
          "Department? get department;",
          "String? get departmentId => department?.code;"
        ],
      ),
    ];

    for (final tc in testCases) {
      test(tc.name, () {
        final writer = ForeignKeyWriter();
        final record = tc.input;
        final result = writer.generateForeignKeyField(record);
        expect(result, equals(tc.expected));
      });
    }
  });

  group('ForeignKeyWriter - Full mixin generation', () {
    test('Generate mixin with single ToOne relationship', () {
      final writer = ForeignKeyWriter();
      final tableRecord = TableRecord(
        tableName: 'posts',
        tableClassName: 'Posts',
        rowClassName: 'Post',
      );

      final fields = [
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

      expect(result, contains('mixin _\$PostForeignKeyMixin {'));
      expect(result, contains('User get author;'));
      expect(result, contains('int get authorId => author.id;'));
    });
  });
}

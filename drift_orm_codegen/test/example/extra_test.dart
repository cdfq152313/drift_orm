import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

import '../../example/drift_orm_codegen_example.dart';
import '../../example/todo_orm.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  bool equal(Extra? a, Extra? b) {
    if (a == null || b == null) return false;
    return a.id == b.id && a.info == b.info;
  }

  group('Simple DAO Tests - No Relationships', () {
    test('Extra insert and load', () async {
      final extra = Extra(id: 100, info: 'test info');

      await database.extrasDao.upsert(extra);

      final result = await database.extrasDao.load(100);

      assert(equal(result, extra));
    });

    test('Extra update and load', () async {
      final extra = Extra(id: 100, info: 'test info');
      await database.extrasDao.upsert(extra);

      extra.info = 'updated info';
      await database.extrasDao.upsert(extra);

      final result = await database.extrasDao.load(100);
      assert(equal(result, extra));
    });

    test('Extra loadAll where', () async {
      final extras = [
        Extra(id: 100, info: 'test info 1'),
        Extra(id: 101, info: 'test info 2'),
      ];
      await database.extrasDao.upsertAll(extras);

      final result = await database.extrasDao
          .loadAll(where: (table) => table.id.equals(100));
      assert(equal(result.first, extras.first));
    });

    test('Extra upsertAll and loadAll', () async {
      final extras = [
        Extra(id: 101, info: 'info 1'),
        Extra(id: 102, info: 'info 2'),
        Extra(id: 103),
      ];

      await database.extrasDao.upsertAll(extras);

      final results = await database.extrasDao.loadAll();
      for (var extra in extras) {
        final match = results.firstWhere((e) => e.id == extra.id);
        assert(equal(match, extra));
      }
    });

    test('Extra partialUpdate', () async {
      final extra = Extra(id: 401, info: 'original info');
      await database.extrasDao.upsert(extra);

      final updatedCount = await database.extrasDao.partialUpdate(
        ExtrasCompanion(
          info: Value('updated info'),
        ),
        where: (table) => table.id.equals(401),
      );

      expect(updatedCount, equals(1));

      final result = await database.extrasDao.load(401);
      expect(result!.info, equals('updated info'));
    });
  });
}

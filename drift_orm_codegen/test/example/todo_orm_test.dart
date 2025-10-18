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

  group('TodoOrm DAO Tests', () {
    test('upsert - should insert a new TodoOrm', () async {
      final todo = TodoOrm(id: 'test-1');

      await database.todoOrmsDao.upsert(todo);

      final result = await database.todoOrmsDao.load('test-1');
      expect(result != null, true);
      expect(result!.id, equals('test-1'));
      expect(result.isDone, false);
      expect(result.extraField == null, true);
    });

    test('upsert - should update existing TodoOrm', () async {
      final todo = TodoOrm(id: 'test-2')..isDone = false;

      // Insert
      await database.todoOrmsDao.upsert(todo);

      // Update
      todo.isDone = true;
      await database.todoOrmsDao.upsert(todo);

      final result = await database.todoOrmsDao.load('test-2');
      assert(result != null);
      expect(result!.isDone, true);
    });

    test('upsert - should handle TodoOrm with Extra relationship', () async {
      final extra = Extra(id: 1, info: 'test extra info');
      final todo = TodoOrm(id: 'test-3')..extraField = extra;

      await database.todoOrmsDao.upsert(todo);

      final result = await database.todoOrmsDao.load('test-3');
      expect(result != null, true);
      expect(result!.extraField != null, true);
      expect(result.extraField!.id, equals(1));
      expect(result.extraField!.info, equals('test extra info'));
    });

    test('upsertAll - should insert multiple TodoOrms', () async {
      final todos = [
        TodoOrm(id: 'batch-1'),
        TodoOrm(id: 'batch-2')..isDone = true,
        TodoOrm(id: 'batch-3'),
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final results = await database.todoOrmsDao.loadAll();
      expect(results.length, equals(3));

      final todo2 = results.firstWhere((t) => t.id == 'batch-2');
      expect(todo2.isDone, true);
    });

    test('upsertAll - should handle mixed insert and update', () async {
      // Insert initial data
      final initialTodo = TodoOrm(id: 'mixed-1')..isDone = false;
      await database.todoOrmsDao.upsert(initialTodo);

      // Prepare batch with update and new insert
      final todos = [
        TodoOrm(id: 'mixed-1')..isDone = true, // Update
        TodoOrm(id: 'mixed-2'), // New insert
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final results = await database.todoOrmsDao.loadAll();
      expect(results.length, equals(2));

      final updatedTodo = results.firstWhere((t) => t.id == 'mixed-1');
      expect(updatedTodo.isDone, true);

      final newTodo = results.firstWhere((t) => t.id == 'mixed-2');
      expect(newTodo.isDone, false);
    });

    test('loadAll - should load all TodoOrms', () async {
      final todos = [
        TodoOrm(id: 'load-1'),
        TodoOrm(id: 'load-2')..isDone = true,
        TodoOrm(id: 'load-3'),
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final results = await database.todoOrmsDao.loadAll();
      expect(results.length, equals(3));
      expect(results.map((t) => t.id),
          containsAll(['load-1', 'load-2', 'load-3']));
    });

    test('loadAll - should apply where filter', () async {
      final todos = [
        TodoOrm(id: 'filter-1')..isDone = false,
        TodoOrm(id: 'filter-2')..isDone = true,
        TodoOrm(id: 'filter-3')..isDone = false,
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final doneResults = await database.todoOrmsDao.loadAll(
        where: (table) => table.isDone.equals(true),
      );

      expect(doneResults.length, equals(1));
      expect(doneResults.first.id, equals('filter-2'));
    });

    test('loadAll - should apply limit and offset', () async {
      final todos = List.generate(
        5,
        (i) => TodoOrm(id: 'limit-$i'),
      );

      await database.todoOrmsDao.upsertAll(todos);

      final results = await database.todoOrmsDao.loadAll(
        limit: 2,
        offset: 1,
      );

      expect(results.length, equals(2));
    });

    test('loadAll - should apply orderBy', () async {
      final todos = [
        TodoOrm(id: 'order-z'),
        TodoOrm(id: 'order-a'),
        TodoOrm(id: 'order-m'),
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final results = await database.todoOrmsDao.loadAll(
        orderBy: [(table) => OrderingTerm.asc(table.id)],
      );

      expect(
          results.map((t) => t.id), equals(['order-a', 'order-m', 'order-z']));
    });

    test('load - should return specific TodoOrm by key', () async {
      final todo = TodoOrm(id: 'specific-1')..isDone = true;
      await database.todoOrmsDao.upsert(todo);

      final result = await database.todoOrmsDao.load('specific-1');
      expect(result != null, true);
      expect(result!.id, equals('specific-1'));
      expect(result.isDone, true);
    });

    test('load - should return null for non-existent key', () async {
      final result = await database.todoOrmsDao.load('non-existent');
      expect(result == null, true);
    });

    test('partialUpdate - should update specific fields', () async {
      final todo = TodoOrm(id: 'partial-1')..isDone = false;
      await database.todoOrmsDao.upsert(todo);

      final updatedCount = await database.todoOrmsDao.partialUpdate(
        TodoOrmsCompanion(
          isDone: Value(true),
        ),
        where: (table) => table.id.equals('partial-1'),
      );

      expect(updatedCount, equals(1));

      final result = await database.todoOrmsDao.load('partial-1');
      expect(result!.isDone, true);
    });

    test('partialUpdate - should update multiple rows', () async {
      final todos = [
        TodoOrm(id: 'multi-1')..isDone = false,
        TodoOrm(id: 'multi-2')..isDone = false,
        TodoOrm(id: 'multi-3')..isDone = true,
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final updatedCount = await database.todoOrmsDao.partialUpdate(
        TodoOrmsCompanion(
          isDone: Value(true),
        ),
        where: (table) => table.isDone.equals(false),
      );

      expect(updatedCount, equals(2));

      final results = await database.todoOrmsDao.loadAll(
        where: (table) => table.isDone.equals(true),
      );
      expect(results.length, equals(3));
    });

    test('partialUpdate - should update all rows when no where clause',
        () async {
      final todos = [
        TodoOrm(id: 'all-1')..isDone = false,
        TodoOrm(id: 'all-2')..isDone = false,
      ];

      await database.todoOrmsDao.upsertAll(todos);

      final updatedCount = await database.todoOrmsDao.partialUpdate(
        TodoOrmsCompanion(
          isDone: Value(true),
        ),
      );

      expect(updatedCount, equals(2));

      final results = await database.todoOrmsDao.loadAll();
      expect(results.every((t) => t.isDone), true);
    });
  });

  group('Extra DAO Tests', () {
    test('upsert - should insert a new Extra', () async {
      final extra = Extra(id: 100, info: 'test info');

      await database.extrasDao.upsert(extra);

      final result = await database.extrasDao.load(100);
      expect(result != null, true);
      expect(result!.id, equals(100));
      expect(result.info, equals('test info'));
    });

    test('upsertAll - should insert multiple Extras', () async {
      final extras = [
        Extra(id: 101, info: 'info 1'),
        Extra(id: 102, info: 'info 2'),
        Extra(id: 103),
      ];

      await database.extrasDao.upsertAll(extras);

      final results = await database.extrasDao.loadAll();
      expect(results.length, equals(3));

      final extra3 = results.firstWhere((e) => e.id == 103);
      expect(extra3.info == null, true);
    });

    test('loadAll - should load all Extras', () async {
      final extras = [
        Extra(id: 201, info: 'load test 1'),
        Extra(id: 202, info: 'load test 2'),
      ];

      await database.extrasDao.upsertAll(extras);

      final results = await database.extrasDao.loadAll();
      expect(results.length, equals(2));
      expect(results.map((e) => e.id), containsAll([201, 202]));
    });

    test('load - should return specific Extra by key', () async {
      final extra = Extra(id: 301, info: 'specific extra');
      await database.extrasDao.upsert(extra);

      final result = await database.extrasDao.load(301);
      expect(result != null, true);
      expect(result!.id, equals(301));
      expect(result.info, equals('specific extra'));
    });

    test('partialUpdate - should update Extra fields', () async {
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

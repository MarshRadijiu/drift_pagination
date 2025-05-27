// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:drift/drift.dart';
import 'package:drift_pagination/drift_pagination.dart';
import 'package:example/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

const kTotalCategories = 100;
const kTotalTodoItems = 100;

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting();
    await database.categories.deleteAll();
    await database.todoItems.deleteAll();

    await database.categories.insertAll([
      for (var i = 0; i < kTotalCategories; i++)
        CategoriesCompanion.insert(name: 'Category ${i + 1}'),
    ]);

    await database.todoItems.insertAll([
      for (var i = 0; i < kTotalTodoItems; i++)
        TodoItemsCompanion.insert(
          title: 'Category 1 - Todo Item ${i + 1}',
          category: Value(1),
        ),
    ]);
  });

  group('simple (select categories)', () {
    test('default', () async {
      final page = await database.selectCategories();

      _expectPage(const Pagination.defaults(), page);
      _expectCategories(page);
    });

    test('with limit', () async {
      final pagination = Pagination(limit: 10);
      final page = await database.selectCategories(pagination: pagination);

      _expectPage(pagination, page);
      _expectCategories(page);
    });

    test('with page', () async {
      final pagination = Pagination(page: 2);
      final page = await database.selectCategories(pagination: pagination);

      _expectPage(pagination, page);
      _expectCategories(page);
    });

    test('with skip', () async {
      final pagination = Pagination(skip: 10);
      final page = await database.selectCategories(pagination: pagination);

      _expectPage(pagination, page);
      _expectCategories(page);
    });

    test('with page and limit', () async {
      final pagination = Pagination(page: 3, limit: 2);
      final page = await database.selectCategories(pagination: pagination);

      _expectPage(pagination, page);
      _expectCategories(page);
    });

    test('iterate all by even limit', () async {
      const limit = 20;

      var pagination = Pagination(page: 1, limit: limit);
      late Page<Category> page;

      do {
        page = await database.selectCategories(pagination: pagination);
        _expectPage(pagination, page);
        _expectCategories(page);

        pagination = pagination.next;
      } while (page.hasNextPage);
    });

    test('iterate all by odd limit', () async {
      const limit = 33;

      var pagination = Pagination(page: 1, limit: limit);
      late Page<Category> page;

      do {
        page = await database.selectCategories(pagination: pagination);
        _expectPage(pagination, page);
        _expectCategories(page);

        pagination = pagination.next;
      } while (page.hasNextPage);
    });

    test('iterate all with skip', () async {
      const limit = 20;

      var pagination = Pagination(page: 1, limit: limit, skip: 17);
      late Page<Category> page;

      do {
        page = await database.selectCategories(pagination: pagination);
        _expectPage(pagination, page);
        _expectCategories(page);

        pagination = pagination.next;
      } while (page.hasNextPage);
    });
  });

  tearDown(() async {
    await database.close();
  });
}

_expectPage<T>(Pagination pagination, Page<T> page) {
  expect(page.total, kTotalCategories);
  expect(page.limit, pagination.limit);
  expect(
    page.totalPages,
    ((kTotalCategories - pagination.skip) / pagination.limit).ceil(),
  );
  expect(page.page, pagination.page);

  if (page.lastPage) {
    final remaining = page.total - page.offset;
    expect(page.length, remaining);
  } else {
    expect(page.length, pagination.limit);
  }
}

_expectCategories(Page<Category> page) {
  var offset = page.offset;

  for (var i = 0; i < page.length; i++) {
    final category = page[i];
    final id = offset + i + 1;
    expect(category.id, id);
    expect(category.name, 'Category $id');
  }
}

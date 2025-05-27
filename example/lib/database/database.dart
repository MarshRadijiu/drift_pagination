import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift_pagination/drift_pagination.dart';
import 'package:example/database/tables.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TodoItems, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'pagination.sqlite',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  @visibleForTesting
  AppDatabase.forTesting() : super(NativeDatabase.memory(logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<Category> insertCategory(CategoriesCompanion category) =>
      into(categories).insertReturning(category);

  Future<Page<Category>> selectCategories({
    Pagination pagination = const Pagination.defaults(),
  }) => select(categories).paginate(pagination).get();

  Future<Page<TodoItem>> selectTodoItems(
    int categoryId, {
    Pagination pagination = const Pagination.defaults(),
  }) =>
      (select(todoItems).join([
        innerJoin(categories, categories.id.equalsExp(todoItems.category)),
      ])..where(
        categories.id.equals(categoryId),
      )).paginate((row) => row.readTable(todoItems), pagination).get();

  Future<TodoItem> insertTodoItem(TodoItemsCompanion todo) =>
      into(todoItems).insertReturning(todo);
}

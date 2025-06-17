# Drift Pagination

A Dart package that provides simple and efficient pagination utilities for [Drift](https://drift.simonbinder.eu/), the reactive persistence library for Flutter applications.

## Features

- Simple, immutable `Pagination` and `Page<T>` classes for paginated queries.
- Extensions for easy pagination on Drift `Selectable` queries.
- Works with both simple selects and joined queries.
- Provides total count, page info, and navigation helpers.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  drift_pagination: ^1.0.2
```

## Usage

### 1. Define your tables

```dart
import 'package:drift/drift.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get category => integer().references(Categories, #id)();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
```

### 2. Use pagination in your queries

```dart
import 'package:drift/drift.dart';
import 'package:drift_pagination/drift_pagination.dart';

// Example: Paginate categories
Future<Page<Category>> selectCategories({
  Pagination pagination = const Pagination.defaults(),
}) => select(categories).paginate(pagination).get();

// Example: Paginate joined todo items by category
Future<Page<TodoItem>> selectTodoItems(int categoryId, {
  Pagination pagination = const Pagination.defaults(),
}) =>
  (select(todoItems).join([
    innerJoin(categories, categories.id.equalsExp(todoItems.category)),
  ])..where(categories.id.equals(categoryId)))
    .paginate((row) => row.readTable(todoItems), pagination)
    .get();
```

### 3. Page Object

- `Page<T>` is an immutable object that extends `List<T>`.
- The `List<T> items` inside the `Page<T>` cannot grow or be modified.
- All methods that `Page<T>` extends are applied to `items`.

### 4. Example: Infinite ListView

```dart
final page = await database.selectCategories(pagination: Pagination(page: 1, limit: 20));

List<Category> items = page.items;
bool lastPage = page.lastPage;

// To load more:
final nextPage = await database.selectCategories(pagination: page.next);
items = [...items, ...nextPage.items];
```

## Example Project

See the [`example/`](example/) directory for a full Flutter app demonstrating infinite scrolling with categories and todo items.

## API Reference

- `Pagination` - Holds page, limit, skip, and provides navigation helpers.
- `Page<T>` - Immutable, implements `List<T>`, and provides pagination info.
- Extensions: `.paginate()` on Drift select statements.

## License

This project uses [BSD-3-Clause](LICENSE) as license.

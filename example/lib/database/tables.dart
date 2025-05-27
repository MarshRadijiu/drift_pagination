import 'package:drift/drift.dart';

class TodoItems extends Table {
  late final id = integer().autoIncrement()();
  late final title = text()();
  late final createdAt = dateTime().nullable()();

  late final category = integer().nullable().references(Categories, #id)();
}

class Categories extends Table with AutoIncrementingPrimaryKey {
  late final name = text()();
}

mixin AutoIncrementingPrimaryKey on Table {
  late final id = integer().autoIncrement()();
}

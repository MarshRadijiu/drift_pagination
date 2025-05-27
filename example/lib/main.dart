import 'package:drift/drift.dart';
import 'package:example/database/database.dart';
import 'package:example/pages/categories.page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database = AppDatabase();
  await database.categories.deleteAll();
  await database.todoItems.deleteAll();

  await database.categories.insertAll([
    for (var i = 1; i <= 100; i++)
      CategoriesCompanion(id: Value(i), name: Value('Category $i')),
  ]);

  await database.todoItems.insertAll([
    for (var i = 0; i < 100; i++)
      for (var j = 1; j <= 100; j++)
        TodoItemsCompanion(
          id: Value(j + (i * 100)),
          title: Value('Category $i - Todo Item $j'),
          category: Value(i),
        ),
  ]);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
  }

  @override
  void dispose() async {
    await database.close();
    super.dispose();
  }

  List<Category> items = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CategoryPage(database: database));
  }
}

import 'package:drift_pagination/drift_pagination.dart';
import 'package:drift_pagination/drift_pagination.dart' as pagination;
import 'package:example/database/database.dart';
import 'package:flutter/material.dart';

class TodoItemsPage extends StatelessWidget {
  const TodoItemsPage({
    super.key,
    required this.database,
    required this.category,
  });

  final AppDatabase database;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: FutureBuilder<pagination.Page<TodoItem>>(
        future: database.selectTodoItems(category.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          final page = snapshot.data!;

          return TodoItemsList(
            database: database,
            category: category,
            page: page,
          );
        },
      ),
    );
  }
}

class TodoItemsList extends StatefulWidget {
  const TodoItemsList({
    super.key,
    required this.database,
    required this.category,
    required this.page,
  });

  final AppDatabase database;
  final Category category;
  final pagination.Page<TodoItem> page;

  @override
  State<TodoItemsList> createState() => _TodoItemsListState();
}

class _TodoItemsListState extends State<TodoItemsList> {
  final ScrollController _scrollController = ScrollController();

  late List<TodoItem> items = [];
  late bool lastPage;

  int index = 1;

  @override
  void initState() {
    super.initState();

    items = widget.page.items;
    lastPage = widget.page.lastPage;
    _scrollController.addListener(_loadMoreItems);
  }

  Future<void> _loadMoreItems() async {
    if (lastPage ||
        _scrollController.position.pixels !=
            _scrollController.position.maxScrollExtent) {
      return;
    }

    final page = await widget.database.selectTodoItems(
      widget.category.id,
      pagination: Pagination(page: ++index, limit: kPaginationDefaultLimit),
    );

    items = [...items, ...page.items];
    lastPage = page.lastPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder:
          (context, index) =>
              TodoItemsItem(todoItem: items[index], database: widget.database),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: items.length,
      controller: _scrollController,
    );
  }
}

class TodoItemsItem extends StatelessWidget {
  const TodoItemsItem({
    super.key,
    required this.todoItem,
    required this.database,
  });

  final TodoItem todoItem;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(todoItem.title)));
  }
}

import 'package:example/database/database.dart';
import 'package:example/pages/todo_items.page.dart';
import 'package:flutter/material.dart';
import 'package:drift_pagination/drift_pagination.dart' as pagination;

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drift Example')),
      body: FutureBuilder<pagination.Page<Category>>(
        future: database.selectCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          final page = snapshot.data!;

          return CategoryList(database: database, page: page);
        },
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.database, required this.page});

  final AppDatabase database;
  final pagination.Page<Category> page;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final ScrollController _scrollController = ScrollController();

  late List<Category> items = [];
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

    final page = await widget.database.selectCategories(
      pagination: pagination.Pagination(
        page: ++index,
        limit: pagination.kPaginationDefaultLimit,
      ),
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
              CategoryItem(category: items[index], database: widget.database),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: items.length,
      controller: _scrollController,
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.database,
  });

  final Category category;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category.name),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      TodoItemsPage(database: database, category: category),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';

/// The default page number.
const kPaginationDefaultPage = 1;

/// The default limit of rows per page.
const kPaginationDefaultLimit = 20;

/// The default skip of rows.
const kPaginationDefaultSkip = 0;

/// The object that can be used to paginate a query.
class Pagination {
  /// The page number.
  final int page;

  /// The number of maximum rows per pagination.
  final int limit;

  /// The first [skip] rows will be skipped and not included in the pagination.
  final int skip;

  Pagination({
    this.page = kPaginationDefaultPage,
    this.limit = kPaginationDefaultLimit,
    this.skip = kPaginationDefaultSkip,
  }) {
    assert(page > 0, 'Page must be greater than or equal to 1');
    assert(limit > 0, 'Limit must be greater than 0');
    assert(skip >= 0, 'Skip must be greater than or equal to 0');
  }

  /// The start index of the page.
  int get offset => skip + (page - 1) * limit;

  /// The default pagination object.
  const Pagination.defaults()
    : page = kPaginationDefaultPage,
      limit = kPaginationDefaultLimit,
      skip = kPaginationDefaultSkip;

  /// The next page.
  Pagination get next => copyWith(page: page + 1);

  /// The previous page.
  Pagination get previous => copyWith(page: page - 1);

  /// Copy the pagination with the new values.
  Pagination copyWith({int? page, int? limit, int? skip}) => Pagination(
    page: page ?? this.page,
    limit: limit ?? this.limit,
    skip: skip ?? this.skip,
  );
}

/// The wrapper of rows returned by the paginated query.
class Page<T> implements List<T> {
  final Pagination _pagination;
  final int total;
  final int totalPages;
  final List<T> items;

  Page._({
    required this.total,
    required Pagination pagination,
    required Iterable<T> items,
  }) : _pagination = pagination,
       totalPages = ((total - pagination.skip) / pagination.limit).ceil(),
       items = items.toList(growable: false) {
    assert(total >= 0, 'Total must be greater than or equal to 0');
    assert(page > 0, 'Page must be greater than or equal to 1');
    assert(limit > 0, 'Limit must be greater than 0');
  }

  int get limit => _pagination.limit;

  int get offset => _pagination.offset;

  int get skipped => _pagination.skip;

  int get page => _pagination.page;

  bool get firstPage => page == 1;

  bool get lastPage => page == totalPages;

  bool get hasNextPage => !lastPage;

  bool get hasPreviousPage => !firstPage;

  Pagination get next => _pagination.next;

  Pagination get previous => _pagination.previous;

  @override
  T operator [](int index) => items[index];

  @override
  List<T> operator +(List<T> other) => items + other;

  @override
  T get first => items.first;

  @override
  T get last => items.last;

  @override
  int get length => items.length;

  @override
  bool get isEmpty => items.isEmpty;

  @override
  bool get isNotEmpty => items.isNotEmpty;

  @override
  bool any(bool Function(T element) test) => items.any(test);

  @override
  List<R> cast<R>() => items.cast<R>();

  @override
  bool contains(Object? element) => items.contains(element);

  @override
  T elementAt(int index) => items.elementAt(index);

  @override
  bool every(bool Function(T element) test) => items.every(test);

  @override
  Iterable<R> expand<R>(Iterable<R> Function(T element) toElements) =>
      items.expand(toElements);

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      items.firstWhere(test, orElse: orElse);

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) =>
      items.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => items.followedBy(other);

  @override
  void forEach(void Function(T element) action) => items.forEach(action);

  @override
  Iterator<T> get iterator => items.iterator;

  @override
  String join([String separator = ""]) => items.join(separator);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      items.lastWhere(test, orElse: orElse);

  @override
  Iterable<R> map<R>(R Function(T e) toElement) => items.map(toElement);

  @override
  T reduce(T Function(T value, T element) combine) => items.reduce(combine);

  @override
  T get single => items.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      items.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => items.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => items.skipWhile(test);

  @override
  Iterable<T> take(int count) => items.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => items.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => items.toList(growable: growable);

  @override
  Set<T> toSet() => items.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => items.where(test);

  @override
  Iterable<R> whereType<R>() => items.whereType<R>();

  @override
  Map<int, T> asMap() => items.asMap();

  @override
  Iterable<T> getRange(int start, int end) => items.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => items.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      items.indexWhere(test, start);

  @override
  int lastIndexOf(T element, [int? start]) => items.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      items.lastIndexWhere(test, start);

  @override
  Iterable<T> get reversed => items.reversed;

  @override
  List<T> sublist(int start, [int? end]) => items.sublist(start, end);

  @override
  void operator []=(int index, T value) => _readonly();

  @override
  void add(T value) => _readonly();

  @override
  void addAll(Iterable<T> iterable) => _readonly();

  @override
  void clear() => _readonly();

  @override
  void fillRange(int start, int end, [T? fillValue]) => _readonly();

  @override
  set first(T value) => _readonly();

  @override
  void insert(int index, T element) => _readonly();

  @override
  void insertAll(int index, Iterable<T> iterable) => _readonly();

  @override
  set last(T value) => _readonly();

  @override
  set length(int newLength) => _readonly();

  @override
  bool remove(Object? value) => _readonly();

  @override
  T removeAt(int index) => _readonly();

  @override
  T removeLast() => _readonly();

  @override
  void removeRange(int start, int end) => _readonly();

  @override
  void removeWhere(bool Function(T element) test) => _readonly();

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) =>
      _readonly();

  @override
  void retainWhere(bool Function(T element) test) => _readonly();

  @override
  void setAll(int index, Iterable<T> iterable) => _readonly();

  @override
  void setRange(
    int start,
    int end,
    Iterable<T> iterable, [
    int skipCount = 0,
  ]) => _readonly();

  @override
  void shuffle([Random? random]) => _readonly();

  @override
  void sort([int Function(T a, T b)? compare]) => _readonly();

  _readonly() =>
      throw StateError(
        'Cannot modify items inside a page. Pages are immutable collections.',
      );

  @override
  String toString() =>
      'Page(total: $total, limit: $limit, page: $page, totalPages: $totalPages, items: $items)';
}

extension LimitPaginationExtension on LimitContainerMixin {
  /// Limit the select statement by the pagination.
  ///
  /// [pagination] is the pagination object.
  ///
  /// ```dart
  /// import 'package:drift_pagination/drift_pagination.dart';
  ///
  /// select(todoItems).limitBy(Pagination(page: 1, limit: 10)).get();
  void limitBy(Pagination pagination) {
    limit(pagination.limit, offset: pagination.offset);
  }
}

extension SimplePaginationExtension<T extends HasResultSet, D>
    on SimpleSelectStatement<T, D> {
  /// Paginate the select statement.
  ///
  /// [pagination] is the pagination object.
  /// [count] if already present in the query, it will be used to count the total number of rows.
  ///
  /// ```dart
  /// import 'package:drift_pagination/drift_pagination.dart';
  ///
  /// select(todoItems).paginate().get();
  /// ```
  PaginatedSelectable<D> paginate<R extends TypedResult>([
    Pagination pagination = const Pagination.defaults(),
    Expression<int>? count,
  ]) {
    return (join([]) as JoinedSelectStatement<T, D>).paginate(
      (row) => row.readTable(table as ResultSetImplementation<HasResultSet, D>),
      pagination,
      count,
    );
  }
}

extension JoinedPaginationExtension on JoinedSelectStatement {
  /// Paginate the select statement.
  ///
  /// [mapper] is a function that maps the result to a [T] object.
  /// [pagination] is the pagination object.
  /// [count] if already present in the query, it will be used to count the total number of rows.
  ///
  /// ```dart
  /// import 'package:drift_pagination/drift_pagination.dart';
  ///
  /// select(todoItems).paginate((row) => row.readTable(todoItems)).get();
  /// ```
  PaginatedSelectable<T> paginate<T>(
    T Function(TypedResult) mapper, [
    Pagination pagination = const Pagination.defaults(),
    Expression<int>? count,
  ]) => PaginatedSelectable(this, count, pagination, mapper);
}

/// A selectable that can be paginated.
final class PaginatedSelectable<T> extends Selectable<T> {
  final JoinedSelectStatement _statement;
  final Expression<int> _count;
  final Pagination _pagination;
  final T Function(TypedResult) _mapper;

  PaginatedSelectable(
    this._statement,
    Expression<int>? count,
    this._pagination,
    this._mapper,
  ) : _count = count ?? _statement.table.$columns.first.count() {
    _statement.limitBy(_pagination);
  }

  @override
  Future<Page<T>> get() => _statement.get().then(_paginate);

  @override
  Stream<Page<T>> watch() => _statement.watch().asyncMap(_paginate);

  @override
  Future<T> getSingle() => get().then((page) => page.first);

  @override
  Stream<T> watchSingle() => watch().map((page) => page.first);

  @override
  Future<T?> getSingleOrNull() => get().then((page) => page.firstOrNull);

  @override
  Stream<T?> watchSingleOrNull() => watch().map((page) => page.firstOrNull);

  Future<Page<T>> _paginate(List<TypedResult> rows) async {
    var total =
        (await (_statement
              ..limit(1, offset: 0)
              ..addColumns([_count]))
            .map((row) => row.read(_count))
            .getSingle()) ??
        0;

    return Page._(
      total: total,
      pagination: _pagination,
      items: rows.map(_mapper).nonNulls.cast(),
    );
  }
}

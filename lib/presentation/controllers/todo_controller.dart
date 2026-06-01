import 'package:flutter/material.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/domain/entities/todo_filter.dart';
import 'package:todo_app/domain/entities/todo_sort.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoController extends ChangeNotifier {
  TodoController(this._repository);

  final TodoRepository _repository;
  final _uuid = const Uuid();

  List<Todo> _todos = [];
  bool _isLoading = true;
  String _searchQuery = '';
  TodoFilter _filter = TodoFilter.all;
  TodoSort _sort = TodoSort.manual;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TodoFilter get filter => _filter;
  TodoSort get sort => _sort;

  int get activeCount => _todos.where((t) => !t.isCompleted).length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;

  List<Todo> get visibleTodos {
    var list = List<Todo>.from(_todos);

    switch (_filter) {
      case TodoFilter.all:
        break;
      case TodoFilter.active:
        list = list.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        list = list.where((t) => t.isCompleted).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q),
          )
          .toList();
    }

    switch (_sort) {
      case TodoSort.manual:
        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      case TodoSort.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TodoSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case TodoSort.alphabetical:
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }

    return list;
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    _todos = await _repository.loadTodos();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    String description = '',
  }) async {
    final nextOrder = _todos.isEmpty
        ? 0
        : _todos.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

    final todo = Todo(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      sortOrder: nextOrder,
    );

    _todos = [..._todos, todo];
    notifyListeners();
    await _persist();
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    String description = '',
  }) async {
    _todos = _todos
        .map(
          (t) => t.id == id
              ? t.copyWith(title: title.trim(), description: description.trim())
              : t,
        )
        .toList();
    notifyListeners();
    await _persist();
  }

  Future<void> toggleComplete(String id) async {
    _todos = _todos
        .map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t)
        .toList();
    notifyListeners();
    await _persist();
  }

  Future<void> deleteTodo(String id) async {
    _todos = _todos.where((t) => t.id != id).toList();
    notifyListeners();
    await _persist();
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    if (_sort != TodoSort.manual) {
      _sort = TodoSort.manual;
    }

    final visible = visibleTodos;
    if (oldIndex < 0 ||
        newIndex < 0 ||
        oldIndex >= visible.length ||
        newIndex >= visible.length) {
      return;
    }

    var adjustedNew = newIndex;
    if (oldIndex < newIndex) adjustedNew -= 1;

    final moved = visible[oldIndex];
    final reorderedVisible = List<Todo>.from(visible)..removeAt(oldIndex);
    reorderedVisible.insert(adjustedNew, moved);

    for (var i = 0; i < reorderedVisible.length; i++) {
      final item = reorderedVisible[i];
      final idx = _todos.indexWhere((t) => t.id == item.id);
      if (idx != -1) {
        _todos[idx] = item.copyWith(sortOrder: i);
      }
    }

    notifyListeners();
    await _persist();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSort(TodoSort sort) {
    _sort = sort;
    notifyListeners();
  }

  Future<void> clearCompleted() async {
    _todos = _todos.where((t) => !t.isCompleted).toList();
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.saveTodos(_todos);
  }
}

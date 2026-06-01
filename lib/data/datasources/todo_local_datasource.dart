import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/models/todo_model.dart';

class TodoLocalDatasource {
  TodoLocalDatasource(this._prefs);

  static const _storageKey = 'todos_v1';

  final SharedPreferences _prefs;

  Future<List<TodoModel>> loadTodos() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTodos(List<TodoModel> todos) async {
    final encoded = jsonEncode(todos.map((t) => t.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }
}

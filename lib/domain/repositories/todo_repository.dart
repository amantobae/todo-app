import 'package:todo_app/domain/entities/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> loadTodos();
  Future<void> saveTodos(List<Todo> todos);
}

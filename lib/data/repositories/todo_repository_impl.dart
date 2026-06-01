import 'package:todo_app/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._datasource);

  final TodoLocalDatasource _datasource;

  @override
  Future<List<Todo>> loadTodos() async {
    final models = await _datasource.loadTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    final models = todos.map(TodoModel.fromEntity).toList();
    await _datasource.saveTodos(models);
  }
}

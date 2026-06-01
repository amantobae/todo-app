import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/entities/todo_filter.dart';
import 'package:todo_app/domain/entities/todo_sort.dart';
import 'package:todo_app/presentation/controllers/todo_controller.dart';
import 'package:todo_app/presentation/widgets/empty_state.dart';
import 'package:todo_app/presentation/widgets/todo_tile.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({
    super.key,
    required this.onAddPressed,
  });

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoController>();
    final todos = controller.visibleTodos;
    final canReorder = controller.sort == TodoSort.manual;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todos.isEmpty) {
      return TodoEmptyState(
        onAddPressed: onAddPressed,
        hasSearch: controller.searchQuery.isNotEmpty ||
            controller.filter != TodoFilter.all,
      );
    }

    if (canReorder) {
      return ReorderableListView.builder(
        padding: EdgeInsets.zero,
        buildDefaultDragHandles: false,
        itemCount: todos.length,
        onReorder: controller.reorderTodos,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TodoTile(
            key: ValueKey(todo.id),
            todo: todo,
            reorderIndex: index,
            showDragHandle: true,
            onToggle: () => controller.toggleComplete(todo.id),
            onDelete: () => controller.deleteTodo(todo.id),
            onEdit: (title, description) => controller.updateTodo(
              id: todo.id,
              title: title,
              description: description,
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoTile(
          key: ValueKey(todo.id),
          todo: todo,
          onToggle: () => controller.toggleComplete(todo.id),
          onDelete: () => controller.deleteTodo(todo.id),
          onEdit: (title, description) => controller.updateTodo(
            id: todo.id,
            title: title,
            description: description,
          ),
        );
      },
    );
  }
}

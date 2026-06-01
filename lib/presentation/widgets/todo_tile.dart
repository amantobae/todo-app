import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/widgets/todo_form_dialog.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    this.showDragHandle = false,
    this.reorderIndex = 0,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Future<void> Function(String title, String description) onEdit;
  final bool showDragHandle;
  final int reorderIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (_) => onToggle(),
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.deepPurple,
              icon: todo.isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_rounded,
              label: todo.isCompleted ? 'Вернуть' : 'Готово',
              borderRadius: BorderRadius.circular(tokens.cardRadius),
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textPrimary,
              icon: Icons.delete_outline_rounded,
              label: 'Удалить',
              borderRadius: BorderRadius.circular(tokens.cardRadius),
            ),
          ],
        ),
        child: _TodoCard(
          todo: todo,
          onToggle: onToggle,
          onDelete: onDelete,
          onEdit: onEdit,
          showDragHandle: showDragHandle,
          reorderIndex: reorderIndex,
        ),
      ),
    );
  }
}

class _TodoCard extends StatefulWidget {
  const _TodoCard({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.showDragHandle,
    required this.reorderIndex,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Future<void> Function(String title, String description) onEdit;
  final bool showDragHandle;
  final int reorderIndex;

  @override
  State<_TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<_TodoCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    final todo = widget.todo;
    final isActive = !todo.isCompleted;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onLongPress: () => _showActions(context),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: AppDurations.fast,
          child: AnimatedOpacity(
            duration: AppDurations.medium,
            opacity: todo.isCompleted ? 0.55 : 1,
            child: AnimatedContainer(
              duration: AppDurations.medium,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: AppGradients.card,
                borderRadius: BorderRadius.circular(tokens.cardRadius),
                border: Border.all(
                  color: isActive && (_hovered || _pressed)
                      ? AppColors.acidGreen.withOpacity(0.6)
                      : isActive
                          ? AppColors.acidGreen.withOpacity(0.2)
                          : tokens.subtleBorder.withOpacity(0.4),
                  width: isActive && _hovered ? 1.5 : 1,
                ),
                boxShadow: isActive && _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.acidGreen.withOpacity(0.2),
                          blurRadius: 24,
                        ),
                        ...tokens.cardGlow,
                      ]
                    : tokens.cardGlow.sublist(0, 1),
              ),
              child: Row(
                children: [
                  if (widget.showDragHandle) ...[
                    ReorderableDragStartListener(
                      index: widget.reorderIndex,
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  _CompletionButton(
                    isCompleted: todo.isCompleted,
                    onPressed: widget.onToggle,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: AppDurations.medium,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(todo.title),
                          if (todo.description.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              todo.description,
                              style: theme.textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz_rounded, size: 20),
                    color: AppColors.textSecondary,
                    onPressed: () => _showActions(context),
                    tooltip: 'Действия',
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardPrimary,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: AppColors.acidGreen),
                title: const Text('Редактировать'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await showTodoFormDialog(
                    context: context,
                    initialTitle: widget.todo.title,
                    initialDescription: widget.todo.description,
                    title: 'Редактировать задачу',
                  );
                  if (result != null) {
                    await widget.onEdit(result.$1, result.$2);
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  widget.todo.isCompleted
                      ? Icons.undo_rounded
                      : Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                title: Text(
                  widget.todo.isCompleted
                      ? 'Вернуть в активные'
                      : 'Отметить готовой',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onToggle();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Удалить', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompletionButton extends StatefulWidget {
  const _CompletionButton({
    required this.isCompleted,
    required this.onPressed,
  });

  final bool isCompleted;
  final VoidCallback onPressed;

  @override
  State<_CompletionButton> createState() => _CompletionButtonState();
}

class _CompletionButtonState extends State<_CompletionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.medium,
      value: widget.isCompleted ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(_CompletionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      widget.isCompleted ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.isCompleted ? 'Снять отметку' : 'Отметить готовой',
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                ),
                child: AnimatedContainer(
                  duration: AppDurations.medium,
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.isCompleted ? AppGradients.accent : null,
                    color: widget.isCompleted ? null : Colors.transparent,
                    border: Border.all(
                      color: widget.isCompleted
                          ? AppColors.success
                          : AppColors.acidGreen,
                      width: 2,
                    ),
                    boxShadow: widget.isCompleted
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.acidGreen.withOpacity(0.35),
                              blurRadius: 10,
                            ),
                          ],
                  ),
                  child: widget.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.deepPurple,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';
import 'package:todo_app/domain/entities/todo_filter.dart';
import 'package:todo_app/domain/entities/todo_sort.dart';
import 'package:todo_app/presentation/controllers/todo_controller.dart';

class FilterSortBar extends StatelessWidget {
  const FilterSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: TodoFilter.values.map((filter) {
              final selected = controller.filter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _CyberChip(
                  label: filter.label,
                  selected: selected,
                  onTap: () => controller.setFilter(filter),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Icon(Icons.sort_rounded, size: 18, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.sm),
            Text('Сортировка', style: theme.textTheme.bodySmall),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TodoSort.values.map((sort) {
                    final selected = controller.sort == sort;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: _CyberChip(
                        label: sort.label,
                        selected: selected,
                        compact: true,
                        onTap: () => controller.setSort(sort),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (controller.completedCount > 0) ...[
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () => _confirmClear(context, controller),
                child: Text(
                  'Очистить',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (controller.sort != TodoSort.manual)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'Перетаскивание доступно при сортировке «Вручную»',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    TodoController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardPrimary,
        title: const Text('Удалить готовые?'),
        content: Text(
          'Будет удалено ${controller.completedCount} завершённых задач.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.clearCompleted();
    }
  }
}

class _CyberChip extends StatefulWidget {
  const _CyberChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<_CyberChip> createState() => _CyberChipState();
}

class _CyberChipState extends State<_CyberChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1,
        duration: AppDurations.fast,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(tokens.buttonRadius),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? AppSpacing.md : AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: widget.selected ? AppGradients.primary : null,
                color: widget.selected
                    ? null
                    : AppColors.cardSecondary.withOpacity(_hovered ? 0.9 : 0.7),
                borderRadius: BorderRadius.circular(tokens.buttonRadius),
                border: Border.all(
                  color: widget.selected
                      ? AppColors.acidGreen.withOpacity(0.6)
                      : tokens.subtleBorder,
                ),
                boxShadow: widget.selected
                    ? [
                        BoxShadow(
                          color: AppColors.acidGreen.withOpacity(0.25),
                          blurRadius: 16,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.selected
                      ? AppColors.deepPurple
                      : AppColors.textPrimary,
                  fontSize: widget.compact ? 13 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

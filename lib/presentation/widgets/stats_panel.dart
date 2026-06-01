import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/widgets/glass_card.dart';
import 'package:todo_app/presentation/controllers/todo_controller.dart';
import 'package:todo_app/presentation/widgets/animated_counter.dart';
import 'package:todo_app/presentation/widgets/progress_ring.dart';

class StatsPanel extends StatelessWidget {
  const StatsPanel({
    super.key,
    required this.controller,
    this.compact = false,
  });

  final TodoController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = controller.todos.length;
    final completed = controller.completedCount;
    final active = controller.activeCount;
    final progress = total == 0 ? 0.0 : completed / total;

    if (compact) {
      return GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            ProgressRing(
              progress: progress,
              size: 72,
              strokeWidth: 6,
              label: '${(progress * 100).round()}%',
              subtitle: 'готово',
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: _MiniChart(active: active, completed: completed)),
            const SizedBox(width: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatLabel(
                  label: 'Активные',
                  child: AnimatedCounter(
                    value: active,
                    useGradient: true,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _StatLabel(
                  label: 'Всего',
                  child: AnimatedCounter(
                    value: total,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Обзор', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: ProgressRing(
              progress: progress,
              size: 120,
              strokeWidth: 10,
              label: '${(progress * 100).round()}%',
              subtitle: 'выполнено',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _MiniChart(active: active, completed: completed),
          const SizedBox(height: AppSpacing.xl),
          _StatRow(
            label: 'Всего задач',
            value: total,
            useGradient: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          _StatRow(
            label: 'Активные',
            value: active,
            useGradient: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          _StatRow(
            label: 'Готовые',
            value: completed,
            useGradient: false,
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.useGradient = false,
    this.valueColor,
  });

  final String label;
  final int value;
  final bool useGradient;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        AnimatedCounter(
          value: value,
          useGradient: useGradient,
          style: theme.textTheme.titleLarge?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _StatLabel extends StatelessWidget {
  const _StatLabel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        child,
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({required this.active, required this.completed});

  final int active;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final max = (active + completed).clamp(1, 999);
    final activeHeight = active / max;
    final doneHeight = completed / max;

    return SizedBox(
      height: compactChartHeight(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _GradientBar(
              heightFactor: activeHeight,
              gradient: AppGradients.chartActive,
              label: 'Актив.',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _GradientBar(
              heightFactor: doneHeight,
              gradient: AppGradients.chartDone,
              label: 'Готово',
            ),
          ),
        ],
      ),
    );
  }

  double compactChartHeight(BuildContext context) {
    return 64;
  }
}

class _GradientBar extends StatelessWidget {
  const _GradientBar({
    required this.heightFactor,
    required this.gradient,
    required this.label,
  });

  final double heightFactor;
  final Gradient gradient;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: heightFactor.clamp(0.08, 1)),
              duration: AppDurations.slow,
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: AppDurations.fast,
                      height: constraints.maxHeight * value,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.acidGreen.withOpacity(0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

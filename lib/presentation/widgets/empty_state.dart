import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/presentation/widgets/app_button.dart';

class TodoEmptyState extends StatelessWidget {
  const TodoEmptyState({
    super.key,
    required this.onAddPressed,
    this.hasSearch = false,
  });

  final VoidCallback onAddPressed;
  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _CyberEmptyIllustration(),
            const SizedBox(height: AppSpacing.xl),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppGradients.primary.createShader(bounds),
              child: Text(
                hasSearch ? 'Ничего не найдено' : 'Пока нет задач',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasSearch
                  ? 'Попробуйте изменить запрос или фильтр'
                  : 'Создайте первую задачу в неоновом стиле',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Создать задачу',
                icon: Icons.add_rounded,
                onPressed: onAddPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CyberEmptyIllustration extends StatelessWidget {
  const _CyberEmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.acidGreen.withOpacity(0.2),
                  blurRadius: 48,
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: AppGradients.card,
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.acidGreen.withOpacity(0.25),
                  blurRadius: 24,
                ),
              ],
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppGradients.primary.createShader(bounds),
              child: const Icon(Icons.bolt_rounded, size: 44),
            ),
          ),
          Positioned(
            right: 24,
            top: 28,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.acidGreen.withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.deepPurple,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

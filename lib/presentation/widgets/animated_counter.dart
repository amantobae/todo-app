import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/theme/app_colors.dart';

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.useGradient = false,
  });

  final int value;
  final TextStyle? style;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = style ?? theme.textTheme.titleLarge;

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: AppDurations.slow,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final text = Text(
          '$animatedValue',
          style: baseStyle?.copyWith(
            fontWeight: FontWeight.w700,
            color: useGradient ? null : AppColors.textPrimary,
          ),
        );

        if (!useGradient) return text;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.acidGreen, AppColors.neonGreen],
          ).createShader(bounds),
          child: text,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isExpanded;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    final enabled = widget.onPressed != null;
    final radius = BorderRadius.circular(tokens.buttonRadius);
    final scale = _isPressed ? 0.96 : (_isHovered ? 1.03 : 1.0);

    Widget child;

    if (widget.isPrimary && enabled) {
      child = AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: radius,
          boxShadow: _isHovered ? tokens.neonGlow : tokens.cardGlow,
        ),
        child: _ButtonContent(
          label: widget.label,
          icon: widget.icon,
          color: AppColors.deepPurple,
          isExpanded: widget.isExpanded,
        ),
      );
    } else {
      child = AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardSecondary.withOpacity(enabled ? 0.9 : 0.4),
          borderRadius: radius,
          border: Border.all(
            color: enabled ? tokens.subtleBorder : tokens.subtleBorder.withOpacity(0.3),
          ),
        ),
        child: _ButtonContent(
          label: widget.label,
          icon: widget.icon,
          color: theme.colorScheme.onSurface.withOpacity(enabled ? 1 : 0.5),
          isExpanded: widget.isExpanded,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
        child: Semantics(
          button: true,
          enabled: enabled,
          label: widget.label,
          child: AnimatedScale(
            scale: scale,
            duration: AppDurations.fast,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: radius,
                child: widget.isExpanded
                    ? SizedBox(width: double.infinity, child: child)
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.color,
    required this.isExpanded,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}

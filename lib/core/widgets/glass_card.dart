import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';

class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.highlighted = false,
    this.opacity = 1,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool highlighted;
  final double opacity;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final borderColor = widget.highlighted || _hovered
        ? AppColors.acidGreen.withOpacity(0.5)
        : AppColors.glassBorder;

    final content = Ink(
      decoration: BoxDecoration(
        gradient: AppGradients.card,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(tokens.cardRadius),
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: widget.child,
      ),
    );

    return MouseRegion(
      onEnter: widget.onTap != null ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.onTap != null ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedScale(
        scale: _hovered && widget.onTap != null ? 1.01 : 1,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.cardRadius),
            boxShadow: _hovered ? tokens.cardGlow : tokens.cardGlow.sublist(0, 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(tokens.cardRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: tokens.glassBlur,
                sigmaY: tokens.glassBlur,
              ),
              child: AnimatedOpacity(
                duration: AppDurations.medium,
                opacity: widget.opacity,
                child: widget.onTap != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onTap,
                          child: content,
                        ),
                      )
                    : content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';

class NeonFab extends StatefulWidget {
  const NeonFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<NeonFab> createState() => _NeonFabState();
}

class _NeonFabState extends State<NeonFab> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.92 : (_hovered ? 1.06 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.acidGreen.withOpacity(_hovered ? 0.45 : 0.3),
                  blurRadius: _hovered ? 36 : 28,
                  spreadRadius: _hovered ? 2 : 0,
                ),
                BoxShadow(
                  color: AppColors.acidGreen.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.deepPurple,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

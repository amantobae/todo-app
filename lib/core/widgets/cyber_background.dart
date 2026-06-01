import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';

/// Full-screen cyber gradient with ambient glow orbs.
class CyberBackground extends StatelessWidget {
  const CyberBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.background)),
        Positioned(
          top: -80,
          right: -60,
          child: _GlowOrb(
            size: 220,
            color: AppColors.acidGreen.withOpacity(0.12),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -40,
          child: _GlowOrb(
            size: 180,
            color: AppColors.success.withOpacity(0.08),
          ),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.35,
          left: MediaQuery.sizeOf(context).width * 0.5 - 100,
          child: _GlowOrb(
            size: 140,
            color: AppColors.neonGreen.withOpacity(0.06),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: size * 0.6, spreadRadius: size * 0.1),
        ],
      ),
    );
  }
}

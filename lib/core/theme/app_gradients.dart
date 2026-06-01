import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_colors.dart';

abstract final class AppGradients {
  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.acidGreen, AppColors.neonGreen],
  );

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.deepPurple,
      AppColors.darkViolet,
      AppColors.surfacePurple,
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static const accent = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.acidGreen, AppColors.success],
  );

  static const card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cardPrimary, AppColors.cardSecondary],
  );

  static const chartActive = LinearGradient(
    colors: [AppColors.acidGreen, AppColors.neonGreen],
  );

  static const chartDone = LinearGradient(
    colors: [AppColors.success, Color(0xFF00CC6A)],
  );
}

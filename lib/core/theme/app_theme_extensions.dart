import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_spacing.dart';

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.cardRadius,
    required this.buttonRadius,
    required this.inputRadius,
    required this.neonGlow,
    required this.cardGlow,
    required this.subtleBorder,
    required this.glassBlur,
  });

  final double cardRadius;
  final double buttonRadius;
  final double inputRadius;
  final List<BoxShadow> neonGlow;
  final List<BoxShadow> cardGlow;
  final Color subtleBorder;
  final double glassBlur;

  static const cyber = AppThemeTokens(
    cardRadius: 22,
    buttonRadius: 16,
    inputRadius: 16,
    glassBlur: 12,
    subtleBorder: Color(0x33B6FF00),
    neonGlow: [
      BoxShadow(
        color: Color(0x40B6FF00),
        blurRadius: 32,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x20B6FF00),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
    cardGlow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 24,
        offset: Offset(0, 8),
      ),
      BoxShadow(
        color: Color(0x15B6FF00),
        blurRadius: 20,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  AppThemeTokens copyWith({
    double? cardRadius,
    double? buttonRadius,
    double? inputRadius,
    List<BoxShadow>? neonGlow,
    List<BoxShadow>? cardGlow,
    Color? subtleBorder,
    double? glassBlur,
  }) {
    return AppThemeTokens(
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      neonGlow: neonGlow ?? this.neonGlow,
      cardGlow: cardGlow ?? this.cardGlow,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      glassBlur: glassBlur ?? this.glassBlur,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      inputRadius: lerpDouble(inputRadius, other.inputRadius, t)!,
      neonGlow: t < 0.5 ? neonGlow : other.neonGlow,
      cardGlow: t < 0.5 ? cardGlow : other.cardGlow,
      subtleBorder: Color.lerp(subtleBorder, other.subtleBorder, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
    );
  }
}

extension AppThemeTokensX on BuildContext {
  AppThemeTokens get tokens =>
      Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.cyber;

  double get contentMaxWidth {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 1024) return 760;
    if (width >= 600) return 580;
    return double.infinity;
  }

  EdgeInsets get screenPadding {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 1024) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxl,
        vertical: AppSpacing.xl,
      );
    }
    if (width >= 600) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      );
    }
    return const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.lg,
    );
  }
}

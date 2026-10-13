import 'package:flutter/material.dart';
import 'app_colors.dart';

/// NaviHer AI Shadow Tokens
abstract class AppShadows {
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get accentGlow => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.25),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get emergencyGlow => [
        BoxShadow(
          color: AppColors.danger.withValues(alpha: 0.35),
          blurRadius: 40,
          spreadRadius: 8,
        ),
      ];

  static List<BoxShadow> get bottomNavShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];

  static List<BoxShadow> get routeSafeShadow => [
        BoxShadow(
          color: AppColors.routeSafe.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get safetyCardGlow => [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.15),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
}

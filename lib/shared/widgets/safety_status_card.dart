import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/models/safety_models.dart';

/// Safety Status Card shown on the Home Dashboard.
/// Displays current safety level with icon, label, and description.
/// Matches the reference card with green shield icon and positive state.
class SafetyStatusCard extends StatelessWidget {
  final SafetyStatusModel status;
  final VoidCallback? onViewMap;

  const SafetyStatusCard({
    super.key,
    required this.status,
    this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    final (color, iconBg, icon) = switch (status.level) {
      SafetyLevel.safe => (
          AppColors.success,
          AppColors.successSurface,
          Icons.shield_rounded,
        ),
      SafetyLevel.moderate => (
          AppColors.warning,
          AppColors.warningSurface,
          Icons.shield_outlined,
        ),
      SafetyLevel.risky => (
          AppColors.danger,
          AppColors.dangerSurface,
          Icons.warning_rounded,
        ),
      SafetyLevel.danger => (
          AppColors.danger,
          AppColors.dangerSurface,
          Icons.warning_amber_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.safetyCardGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shield icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.s16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Safety Status',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.label,
                      style: AppTypography.sectionTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.description,
                      style: AppTypography.bodySecondary,
                    ),
                  ],
                ),
              ),
              // Close button
              Icon(
                Icons.close_rounded,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
          // View map link
          if (onViewMap != null) ...[
            const SizedBox(height: AppSpacing.s8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onViewMap,
                child: Text(
                  'View map >',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

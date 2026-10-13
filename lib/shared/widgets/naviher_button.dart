import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Primary NaviHer button — pink/magenta accent.
/// Used for primary CTAs across all screens.
class NaviHerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isDanger;
  final IconData? leadingIcon;
  final double? width;
  final double height;

  const NaviHerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDanger = false,
    this.leadingIcon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDanger
        ? AppColors.danger
        : isOutlined
            ? Colors.transparent
            : AppColors.accent;

    final borderColor = isDanger
        ? AppColors.danger
        : isOutlined
            ? AppColors.border
            : Colors.transparent;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        boxShadow: (!isOutlined && onPressed != null)
            ? [
                BoxShadow(
                  color: isDanger ? AppColors.danger.withValues(alpha: 0.3) : AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: isLoading ? null : onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leadingIcon != null) ...[
                          Icon(
                            leadingIcon,
                            color: isOutlined ? AppColors.textPrimary : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: isOutlined ? AppTypography.button : AppTypography.buttonPrimary,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

enum GlassVariant {
  /// Pink = action/selection. High opacity, minimal blur, minimal transparency, restrained glow, crisp edges, subtle shadow.
  pinkSolid,
  /// Blue = navigation/information. Translucent dark-blue, moderate blur, subtle blue tint, thin blue/white border, soft shadow.
  blue,
  /// Purple = community. Translucent purple, moderate-to-strong blur, subtle purple border.
  purple,
  /// Green = safety-positive. Translucent green, moderate blur, thin border.
  green,
  /// Navy = information/glass. Dark navy translucent background, stronger backdrop blur, subtle white/blue border.
  neutral,
  /// A custom variant if the exact parameters need manual overriding
  custom,
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final bool showShadow;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final GlassVariant variant;

  const GlassContainer.custom({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.blur = 15.0,
    this.opacity = 0.75,
    this.borderOpacity = 0.12,
    this.showShadow = true,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
  }) : variant = GlassVariant.custom;

  const GlassContainer.pinkSolid({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.width,
    this.height,
  })  : variant = GlassVariant.pinkSolid,
        blur = 4.0,
        opacity = 0.95,
        borderOpacity = 0.1,
        showShadow = true,
        backgroundColor = AppColors.primaryPink,
        borderColor = Colors.white;

  const GlassContainer.blue({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.width,
    this.height,
  })  : variant = GlassVariant.blue,
        blur = 12.0,
        opacity = 0.6,
        borderOpacity = 0.15,
        showShadow = true,
        backgroundColor = const Color(0xFF1E3A8A), // Dark blue base
        borderColor = Colors.blue;

  const GlassContainer.purple({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.width,
    this.height,
  })  : variant = GlassVariant.purple,
        blur = 16.0,
        opacity = 0.5,
        borderOpacity = 0.15,
        showShadow = false,
        backgroundColor = const Color(0xFF4C1D95), // Dark purple base
        borderColor = Colors.purpleAccent;

  const GlassContainer.green({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.width,
    this.height,
  })  : variant = GlassVariant.green,
        blur = 12.0,
        opacity = 0.5,
        borderOpacity = 0.15,
        showShadow = false,
        backgroundColor = const Color(0xFF064E3B), // Dark green base
        borderColor = Colors.greenAccent;

  const GlassContainer.neutral({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.large)),
    this.width,
    this.height,
  })  : variant = GlassVariant.neutral,
        blur = 20.0,
        opacity = 0.8,
        borderOpacity = 0.15,
        showShadow = true,
        backgroundColor = AppColors.background,
        borderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.background;
    final border = borderColor ?? Colors.white;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: showShadow
            ? [
                if (variant == GlassVariant.pinkSolid)
                  BoxShadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                else if (variant == GlassVariant.blue)
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: bg.withValues(alpha: opacity),
              borderRadius: borderRadius,
              border: Border.all(
                color: border.withValues(alpha: borderOpacity),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

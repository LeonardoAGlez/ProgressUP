import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neon_pulse_3d/core/theme/app_colors.dart';

/// Glassmorphism card with neon border glow
class NeonCard extends StatelessWidget {
  const NeonCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.borderColor,
    this.glowColor,
    this.borderRadius,
    this.height,
    this.width,
    this.onTap,
    this.showGlow = true,
    this.blurOpacity = 0.6,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? glowColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final bool showGlow;
  final double blurOpacity;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 16.0;
    final bColor = borderColor ?? AppColors.neonPink.withOpacity(0.2);
    final gColor = glowColor ?? AppColors.neonPink.withOpacity(0.15);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: showGlow
              ? [
                  BoxShadow(
                    color: gColor,
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: gradient ??
                    LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.surfaceCard.withOpacity(blurOpacity),
                        AppColors.surface.withOpacity(blurOpacity * 0.7),
                      ],
                    ),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: bColor,
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience: Neon card with gradient pink border
class NeonPrimaryCard extends StatelessWidget {
  const NeonPrimaryCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.neonPink, Color(0xFF6600CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppColors.neonPinkShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

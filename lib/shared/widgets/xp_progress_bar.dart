import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neon_pulse_3d/core/theme/app_colors.dart';

/// XP Progress Bar with animated neon fill
class XPProgressBar extends StatelessWidget {
  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    required this.level,
    required this.nextLevel,
    this.showLabel = true,
    this.height = 10,
    this.animate = true,
  });

  final int currentXP;
  final int maxXP;
  final String level;
  final String nextLevel;
  final bool showLabel;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / maxXP).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  color: AppColors.neonPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '$currentXP / $maxXP XP',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Stack(
          children: [
            // Background track
            Container(
              height: height,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // Animated fill
            LayoutBuilder(
              builder: (context, constraints) {
                final fillWidth = constraints.maxWidth * progress;
                return AnimatedContainer(
                  duration: animate ? const Duration(milliseconds: 1200) : Duration.zero,
                  curve: Curves.easeOutCubic,
                  height: height,
                  width: fillWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    gradient: const LinearGradient(
                      colors: [AppColors.neonPink, AppColors.neonCyan],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x80F20DCC),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            'Siguiente: $nextLevel',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }
}

/// Circular XP Progress Ring
class XPProgressRing extends StatelessWidget {
  const XPProgressRing({
    super.key,
    required this.currentXP,
    required this.maxXP,
    required this.child,
    this.size = 100,
    this.strokeWidth = 5,
  });

  final int currentXP;
  final int maxXP;
  final Widget child;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / maxXP).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.surfaceElevated,
              ),
            ),
          ),
          // Neon fill ring
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.neonPink,
                  ),
                ),
              );
            },
          ),
          child,
        ],
      ),
    );
  }
}

/// Animated counter that counts up to a value
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.suffix = '',
    this.prefix = '',
  });

  final double value;
  final TextStyle style;
  final Duration duration;
  final String suffix;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, currentValue, _) {
        final display = currentValue >= 1000
            ? '${(currentValue / 1000).toStringAsFixed(1)}K'
            : currentValue.toInt().toString();
        return Text('$prefix$display$suffix', style: style);
      },
    );
  }
}

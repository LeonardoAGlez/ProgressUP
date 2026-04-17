import 'package:flutter/material.dart';

/// NEON PULSE 3D Color System
/// Based on Stitch design tokens:
///   Primary: #f20dcc (neon magenta)
///   Accent: #00f5ff (neon cyan)
///   Background: dark navy
class AppColors {
  AppColors._();

  // === PRIMARY NEON COLORS ===
  static const Color neonPink = Color(0xFFF20DCC);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonGold = Color(0xFFFFD700);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color neonPurple = Color(0xFFBF00FF);

  // === BACKGROUND LAYERS ===
  static const Color background = Color(0xFF080815);
  static const Color surface = Color(0xFF0F0F1E);
  static const Color surfaceCard = Color(0xFF161628);
  static const Color surfaceElevated = Color(0xFF1E1E35);
  static const Color surfaceHighest = Color(0xFF252540);

  // === TEXT ===
  static const Color textPrimary = Color(0xFFF0EFFF);
  static const Color textSecondary = Color(0xFF8B8AA8);
  static const Color textDisabled = Color(0xFF4A4A6A);

  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonPink, Color(0xFF8B00CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [neonCyan, Color(0xFF0066FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [neonGold, Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, Color(0xFF0D0D25), Color(0xFF080815)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === NEON GLOW SHADOWS ===
  static List<BoxShadow> get neonPinkShadow => [
        BoxShadow(
          color: neonPink.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: neonPink.withOpacity(0.2),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get neonCyanShadow => [
        BoxShadow(
          color: neonCyan.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: neonCyan.withOpacity(0.15),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get neonGoldShadow => [
        BoxShadow(
          color: neonGold.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  // === RANK COLORS ===
  static const Color rankElite = neonGold;
  static const Color rankCyber = neonCyan;
  static const Color rankNeon = neonPink;
  static const Color rankBasic = Color(0xFF8B8AA8);

  // === STATUS ===
  static const Color success = Color(0xFF00FF88);
  static const Color error = Color(0xFFFF4C4C);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = neonCyan;

  // === BORDER ===
  static Color get borderSubtle => neonPink.withOpacity(0.12);
  static Color get borderNeon => neonPink.withOpacity(0.4);
}

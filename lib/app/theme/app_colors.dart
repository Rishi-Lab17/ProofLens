import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // BRAND
  // ============================================================

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1749B8);
  static const Color secondary = Color(0xFF0EA5A8);
  static const Color accent = Color(0xFF7C3AED);

  // ============================================================
  // LIGHT
  // ============================================================

  static const Color backgroundLight = Color(0xFFF4F7FC);

  // Compatibility name used by Home.
  static const Color lightBackground = backgroundLight;

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color dividerLight = Color(0xFFE5E7EB);

  // ============================================================
  // DARK
  // ============================================================

  static const Color backgroundDark = Color(0xFF07111F);

  // Compatibility name used by Home.
  static const Color darkBackground = backgroundDark;

  static const Color darkSurface = Color(0xFF0D1B2A);

  // Additional dark surface used by Home.
  static const Color darkSurfaceSecondary = Color(0xFF13263B);

  static const Color cardDark = Color(0xFF122338);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const Color dividerDark = Color(0xFF24364A);

  // ============================================================
  // STATUS
  // ============================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);
}

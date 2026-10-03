import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // ============================================================
  // NUMERIC VALUES
  // Used where BorderRadius.circular() is required.
  // ============================================================

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;

  static const double card = 20.0;
  static const double button = 16.0;
  static const double input = 16.0;
  static const double pill = 100.0;

  // ============================================================
  // BORDER RADIUS OBJECTS
  // Used directly by the existing Home screen.
  // ============================================================

  static final BorderRadius mediumBorder = BorderRadius.circular(md);

  static final BorderRadius largeBorder = BorderRadius.circular(lg);

  static final BorderRadius extraLargeBorder = BorderRadius.circular(xl);

  static final BorderRadius pillBorder = BorderRadius.circular(pill);
}

import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenWidth => mediaQuery.size.width;

  double get screenHeight => mediaQuery.size.height;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  bool get isSmallScreen => screenWidth < 360;

  bool get isTablet => screenWidth >= 600;

  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

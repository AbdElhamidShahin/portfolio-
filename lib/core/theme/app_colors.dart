import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgBase = Color(0xFF04071A);
  static const Color bgElevated = Color(0xFF0A0E27);
  static const Color bgSurface = Color(0xFF10142C);
  static const Color bgSurfaceHover = Color(0xFF161B3A);
  static const Color bgGlass = Color(0x0AFFFFFF); // 4% white

  // Brand / Accent
  static const Color primary500 = Color(0xFF4C6FFF);
  static const Color primary400 = Color(0xFF6E8CFF);
  static const Color primary600 = Color(0xFF3858E0);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentViolet = Color(0xFF8B5CF6);

  static const Gradient gradientBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary500, accentCyan],
  );

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB6BDD4);
  static const Color textTertiary = Color(0xFF7B8299);
  static const Color textDisabled = Color(0xFF4B5066);
  static const Color textInverse = Color(0xFF04071A);

  // Borders
  static const Color borderSubtle = Color(0x14FFFFFF);  // 8%
  static const Color borderDefault = Color(0x1FFFFFFF); // 12%
  static const Color borderStrong = Color(0x33FFFFFF);  // 20%
  static const Color borderAccent = primary500;

  // Status
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF38BDF8);

  // Tags
  static const Color tagBg = Color(0x1A4C6FFF);
  static const Color tagBorder = Color(0x404C6FFF);
  static const Color tagText = Color(0xFFA5B4FF);
}
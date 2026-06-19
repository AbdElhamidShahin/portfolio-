import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontDisplay = 'Space Grotesk';
  static const String fontBody = 'Inter';
  static const String fontMono = 'JetBrains Mono';

  static const TextStyle displayXl = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 64,
    height: 1.05,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayLg = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 48,
    height: 1.1,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontBody,
    fontSize: 18,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: AppColors.textTertiary,
  );

  static const TextStyle monoCode = TextStyle(
    fontFamily: fontMono,
    fontSize: 14,
    height: 1.7,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Responsive helper — call with current breakpoint
  static TextStyle responsiveDisplay(double width) {
    if (width < 640) return displayXl.copyWith(fontSize: 36);
    if (width < 1024) return displayXl.copyWith(fontSize: 48);
    return displayXl;
  }
}
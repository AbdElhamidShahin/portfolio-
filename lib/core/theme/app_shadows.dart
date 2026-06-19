import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> sm = [
    BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> lg = [
    BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 40, offset: const Offset(0, 16)),
  ];

  static List<BoxShadow> glowPrimary = [
    BoxShadow(color: AppColors.primary500.withOpacity(0.35), blurRadius: 24, spreadRadius: 0),
  ];

  static List<BoxShadow> glowAccent = [
    BoxShadow(color: AppColors.accentCyan.withOpacity(0.25), blurRadius: 32, spreadRadius: 0),
  ];
}
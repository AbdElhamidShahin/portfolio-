import 'package:flutter/cupertino.dart';

class AppRadius {
  AppRadius._();
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double full = 999;

  static BorderRadius card = BorderRadius.circular(lg);
  static BorderRadius button = BorderRadius.circular(md);
  static BorderRadius pill = BorderRadius.circular(full);
}
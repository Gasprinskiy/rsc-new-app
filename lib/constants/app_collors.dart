import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF00796B);
  static const Color primary500 = Color(0xFF009688);
  static const Color primary300 = Color(0xFF4DB6AC);
  static const Color primaryTransparent = Color.fromARGB(37, 77, 182, 172);
  static const Color error = Color(0xFFEF5350);
  static const Color warn = Color(0xFFFFA726);
  static const Color success = Color(0xFF66BB6A);
  // static const Color primary200 = Color(0xFF419E6C);
  // static const Color primary100 = Color(0xFF549974);

  static const List<Color> defaultGradient = [
    primary,
    primary500,
    primary300,
  ];
}

import 'package:flutter/material.dart';

class AppColors {
  // static const Color primary = Color(0xFF007AFF); // Deep blue
  static const Color primary = Color(0xFF2563EB); // Deep blue
  static const Color secondary = Color(0xFFF2E8CF); // Cream
  static const Color accent = Color(0xFFA0522D); // Sienna
  // static const Color background = Color(0xFFF2E8CF); // Cream
  static const Color background = Color(0xFFfafafa); // Cream
  static const Color card = Color(0xFFFFFFFF); // White
  static const Color text = Color(0xFF333333); // Dark grey
  static const Color textLight = Color(0x80333333); // Light grey
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightWhite = Color(0xFFfafafa);

  static const Color black = Color(0xFF101010);
  static const Color teal = Color(0xFF006D77);

  // Text Colors
  static const Color textPrimary = Color(0xFF101010);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Gradients
  static final List<Color> overlayGradient = [
    AppColors.black.withValues(alpha: 0.3),
    AppColors.black.withValues(alpha: 0.5),
  ];
}

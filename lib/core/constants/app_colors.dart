// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary luxury palette (Bright Gold)
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFA8891E);

  // Soft Black tones (Classy Dark Gray)
  static const Color bg = Color(0xFF121212); // Soft Black
  static const Color card = Color(0xFF1E1E1E); // Lighter Dark Gray
  static const Color surface = Color(0xFF2A2A2A); // Elevated Gray
  static const Color border = Color(0xFF383838); // Border

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB3B3B3); // Light Gray
  static const Color textMuted = Color(0xFF808080); // Muted Gray

  // Accent
  static const Color silver = Color(0xFFC0C0C0);
  static const Color accent = Color(0xFFD4AF37); // Gold Accent is best
  static const Color accentLight = Color(0xFFF3E5AB);

  // Status colors
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFFBBF24);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF121212), Color(0xFF1E1E1E), Color(0xFF121212)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFA8891E), Color(0xFFD4AF37), Color(0xFFF3E5AB)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
  );
}

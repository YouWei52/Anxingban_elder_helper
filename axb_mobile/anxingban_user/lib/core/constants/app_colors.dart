import 'package:flutter/material.dart';

// Google Material You 配色方案
class AppColors {
  // Primary - Google Blue
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4285F4);
  static const Color primaryDark = Color(0xFF1557B0);
  static const Color primaryContainer = Color(0xFFD3E3FD);

  // Secondary - Google Green
  static const Color secondary = Color(0xFF188038);
  static const Color secondaryLight = Color(0xFF34A853);
  static const Color secondaryContainer = Color(0xFFCEEAD6);

  // Tertiary - Google Yellow
  static const Color tertiary = Color(0xFFF9AB00);
  static const Color tertiaryLight = Color(0xFFFBBC04);
  static const Color tertiaryContainer = Color(0xFFFEF7E0);

  // Error - Google Red
  static const Color error = Color(0xFFD93025);
  static const Color errorContainer = Color(0xFFF9DEDC);

  // Success
  static const Color success = Color(0xFF188038);
  static const Color successContainer = Color(0xFFCEEAD6);

  // Warning
  static const Color warning = Color(0xFFF9AB00);
  static const Color warningContainer = Color(0xFFFEF7E0);

  // Info
  static const Color info = Color(0xFF1A73E8);
  static const Color infoContainer = Color(0xFFD3E3FD);

  // Neutral colors - Google's subtle grays
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color surfaceContainer = Color(0xFFF1F3F4);
  static const Color surfaceContainerHigh = Color(0xFFE8EAED);
  static const Color background = Color(0xFFFAFAFA);

  // Text colors
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textTertiary = Color(0xFF80868B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFF9AA0A6);

  // Border colors
  static const Color border = Color(0xFFDADCE0);
  static const Color borderDark = Color(0xFFBDC1C6);
  static const Color outline = Color(0xFFE8EAED);

  // Elevation overlays
  static const Color elevation1 = Color(0xFFF8F9FA);
  static const Color elevation2 = Color(0xFFF1F3F4);
  static const Color elevation3 = Color(0xFFE8EAED);

  // Google's signature gradients
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4285F4), Color(0xFF1A73E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Aliases for compatibility
  static const LinearGradient primaryGradient = blueGradient;
  static const LinearGradient accentGradient = multiColorGradient;

  static const LinearGradient multiColorGradient = LinearGradient(
    colors: [
      Color(0xFF4285F4), // Blue
      Color(0xFF34A853), // Green
      Color(0xFFFBBC04), // Yellow
      Color(0xFFEA4335), // Red
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows - Google's elevation system
  static List<BoxShadow> elevation1Shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> elevation2Shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevation3Shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}

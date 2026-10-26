import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 老人端主题 - 基于Google Material You，增强对比度和尺寸
class AppTheme {
  // Google Material You 配色 - 增强对比度
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4285F4);
  static const Color primaryDark = Color(0xFF1557B0);
  static const Color primaryContainer = Color(0xFFD3E3FD);

  static const Color secondary = Color(0xFF188038);
  static const Color secondaryLight = Color(0xFF34A853);
  static const Color secondaryContainer = Color(0xFFCEEAD6);

  static const Color tertiary = Color(0xFFF9AB00);
  static const Color tertiaryContainer = Color(0xFFFEF7E0);

  static const Color error = Color(0xFFD93025);
  static const Color errorContainer = Color(0xFFF9DEDC);

  static const Color success = Color(0xFF188038);
  static const Color warning = Color(0xFFF9AB00);
  static const Color info = Color(0xFF1A73E8);

  // 中性色 - 增强对比度
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color surfaceContainer = Color(0xFFE8EAED);
  static const Color background = Color(0xFFFAFAFA);

  // 文本色 - 更深，更易读
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3C4043);
  static const Color textTertiary = Color(0xFF5F6368);

  static const Color outline = Color(0xFFDADCE0);

  // 渐变
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4285F4), Color(0xFF1A73E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 阴影
  static List<BoxShadow> elevation2Shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainer,
        tertiary: tertiary,
        tertiaryContainer: tertiaryContainer,
        error: error,
        errorContainer: errorContainer,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceContainer,
        outline: outline,
      ),
      scaffoldBackgroundColor: background,

      // 老人专用大字体
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 64, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 52, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.roboto(
          fontSize: 42, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 36, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 32, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 28, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 24, // 增大
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 20, // 增大
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.roboto(
          fontSize: 18, // 增大
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 20, // 增大
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 18, // 增大
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 16, // 增大
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 18, // 增大
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surface,
        foregroundColor: textPrimary,
        surfaceTintColor: primary,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 24, // 增大
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)), // 增大圆角
        ),
        color: surface,
        surfaceTintColor: primary,
      ),

      // 老人专用大按钮
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(120, 56), // 增大按钮
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.roboto(
            fontSize: 20, // 增大字体
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(120, 56),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 56),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)), // 增大圆角
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primary, width: 3), // 增粗边框
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20, // 增大内边距
        ),
        labelStyle: GoogleFonts.roboto(
          fontSize: 20, // 增大
          color: textSecondary,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primaryContainer,
        foregroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)), // 增大圆角
        ),
        extendedSizeConstraints: BoxConstraints(
          minHeight: 64, // 增大FAB
        ),
        extendedTextStyle: TextStyle(
          fontSize: 20, // 增大文字
          fontWeight: FontWeight.w600,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.roboto(
          fontSize: 16, // 增大
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: const IconThemeData(size: 32), // 增大图标
        unselectedIconTheme: const IconThemeData(size: 28),
      ),

      dividerTheme: const DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // 向后兼容的别名
  static const Color primaryColor = primary;
  static const Color accentColor = secondary;
  static const Color successColor = success;
  static const Color warningColor = warning;
  static const Color dangerColor = error;
  static const Color bgColor = background;
  static const Color cardColor = surface;

  // 圆角常量
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // 文本样式别名
  static TextStyle get heading1 => GoogleFonts.roboto(
    fontSize: 64,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get heading2 => GoogleFonts.roboto(
    fontSize: 52,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get heading3 => GoogleFonts.roboto(
    fontSize: 42,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  // 按钮样式方法
  static ButtonStyle primaryButton() {
    return FilledButton.styleFrom(
      elevation: 0,
      minimumSize: const Size(120, 56),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      shape: const StadiumBorder(),
      backgroundColor: primary,
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  // 卡片装饰方法
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radiusMedium),
      boxShadow: elevation2Shadow,
    );
  }

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
}

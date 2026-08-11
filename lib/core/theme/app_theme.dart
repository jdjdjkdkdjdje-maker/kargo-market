import 'package:flutter/material.dart';

/// Xarid ilovasining ranglar palitrasi.
class AppColors {
  AppColors._();

  /// Asosiy rang — yashil (bozor/marketplace hissi).
  static const Color primary = Color(0xFF00A67E);
  static const Color primaryDark = Color(0xFF065F46);
  static const Color primaryLight = Color(0xFFD8F5EC);

  /// Aksent rang — amber (narxlar, chegirma).
  static const Color accent = Color(0xFFFFB300);
  static const Color accentDark = Color(0xFFF57F17);

  /// Matn ranglari.
  static const Color textDark = Color(0xFF11221B);
  static const Color textGrey = Color(0xFF8A9A92);

  /// Fon rangi.
  static const Color background = Color(0xFFF4F7F5);

  /// Status ranglari.
  static const Color success = Color(0xFF00A67E);
  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF8F00);
  static const Color info = Color(0xFF1E88E5);
}

/// Xarid ilovasining mavzusi (yorug' va qorong'i rejim).
class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.background,
      );

  static ThemeData dark() => _base(Brightness.dark).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: const Color(0xFF12241C),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1712),
      );

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF0B1712) : Colors.white,
        foregroundColor: isDark ? Colors.white : AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textDark,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF12241C) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1B3A2E) : const Color(0xFF14382B),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white12 : const Color(0xFFE3EAE6),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF163026) : const Color(0xFFF2F5F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
        hintStyle: TextStyle(color: isDark ? Colors.white38 : AppColors.textGrey),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
          side: const WidgetStatePropertyAll(BorderSide(color: AppColors.primary)),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF1B3328) : Colors.white,
        selectedColor: AppColors.primaryLight,
        side: BorderSide(color: isDark ? Colors.white12 : const Color(0xFFDDE7E1)),
        labelStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF12241C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.primary),
    );
  }
}

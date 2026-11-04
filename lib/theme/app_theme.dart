import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF172A5A);
  static const navyDark = Color(0xFF0E1B3D);
  static const orange = Color(0xFFF4AB3E);
  static const background = Color(0xFFF5F7FB);
  static const field = Color(0xFFF1F4FA);
}

class AppStrings {
  static const tagline = 'Shop smart, shop easy';
  static const errName = 'Please enter your name';
  static const errEmail = 'Enter a valid email address';
  static const errPassword = 'Password must be at least 6 characters';
  static const errMatch = 'Passwords do not match';
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.orange,
    );
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: border(Colors.transparent),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(AppColors.navy, 1.6),
        errorBorder: border(Colors.red.shade400),
        focusedErrorBorder: border(Colors.red.shade400, 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navyDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

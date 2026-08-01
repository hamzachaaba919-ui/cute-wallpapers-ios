import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

/// Builds the app's [ThemeData]. Light — a soft pink/lavender/peach/cream
/// palette — is the default, primary experience; dark mode is a softer
/// "plum dusk" alternative (never AMOLED black), available from Settings.
abstract final class AppTheme {
  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;

    final Color background = isDark ? AppColors.backgroundDark : AppColors.background;
    final Color surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final Color card = isDark ? AppColors.cardDark : AppColors.card;
    final Color cardBorder = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final Color textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final Color textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      primaryColor: AppColors.primary,
      dividerColor: isDark ? AppColors.dividerDark : AppColors.divider,
      splashFactory: InkSparkle.splashFactory,
      highlightColor: AppColors.primary.withValues(alpha: 0.08),
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      fontFamily: AppTextStyles.bodyMedium.fontFamily,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: textPrimary),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: textPrimary),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: textPrimary),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: textPrimary),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: textPrimary),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: textPrimary),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: textPrimary),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textPrimary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: textSecondary),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: textPrimary),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: textSecondary),
        labelSmall: AppTextStyles.labelSmall,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyleDark.style
            : SystemUiOverlayStyleLight.style,
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: isDark ? 0 : 3,
        shadowColor: AppColors.shadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: isDark ? BorderSide(color: cardBorder, width: 1) : BorderSide.none,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: AppColors.primary,
        disabledColor: card.withValues(alpha: 0.5),
        labelStyle: AppTextStyles.labelMedium.copyWith(color: textPrimary),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          side: BorderSide(color: cardBorder, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: card,
          disabledForegroundColor: textSecondary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          textStyle: AppTextStyles.labelLarge,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          textStyle: AppTextStyles.labelLarge,
          side: BorderSide(color: cardBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),

      iconTheme: IconThemeData(color: textPrimary, size: AppDimensions.iconSizeMedium),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dividerDark : AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? card : AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? textPrimary : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(color: textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.white : textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.primary : cardBorder,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: card,
        circularTrackColor: card,
      ),

      visualDensity: VisualDensity.standard,
      // As of Flutter 3.44, `CupertinoPageTransitionsBuilder` moved from
      // `package:flutter/material.dart` to `package:flutter/cupertino.dart`
      // (see the "Page transition builders reorganization" breaking change).
      // Both builders remain `const`-constructible, hence `const` here.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Small internal helpers so [AppTheme] doesn't need a direct dependency on
/// `flutter/services.dart` scattered around — kept local and explicit.
abstract final class SystemUiOverlayStyleDark {
  static SystemUiOverlayStyle get style => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      );
}

abstract final class SystemUiOverlayStyleLight {
  static SystemUiOverlayStyle get style => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
}

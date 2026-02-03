import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

class LightTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.appfont,

      hintColor: AppColors.kContentSecondary.withValues(alpha: 0.5),
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.kBrandPrimary,
        primaryContainer: AppColors.kSurfaceAlt,
        secondary: AppColors.kSurfaceCard,
        tertiary: AppColors.kAccentBeige,
        surface: AppColors.kSurfaceCard,
        error: AppColors.kStatusError,
        onPrimary: AppColors.kContentInverse,
        onSecondary: AppColors.kBrandPrimary,
        onSurface: AppColors.kContentPrimary,
        onError: AppColors.kContentInverse,
        outline: AppColors.kAccentBeige,
        shadow: AppColors.kShadowOverlay,
        surfaceContainer: AppColors.kPrimaryLight,

        tertiaryContainer: AppColors.kStatusSuccess,
        onTertiaryContainer: AppColors.kContentSuccess,
        onTertiary: AppColors.kContentSecondary,
      ),

      scaffoldBackgroundColor: AppColors.kSurfaceBackground,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kSurfaceCard,
        foregroundColor: AppColors.kContentPrimary,
        elevation: AppDimensions.elevationS,
        shadowColor: AppColors.kShadowOverlay,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimensions.appBarHeight,
        titleTextStyle: AppTextStyles.headlineLarge(
          color: AppColors.kContentPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.kBrandPrimary,
          size: AppDimensions.iconM,
        ),
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(
          color: AppColors.kContentPrimary,
        ),
        displayMedium: AppTextStyles.displayMedium(
          color: AppColors.kContentPrimary,
        ),
        headlineLarge: AppTextStyles.headlineLarge(
          color: AppColors.kContentPrimary,
        ),
        headlineMedium: AppTextStyles.headlineMedium(
          color: AppColors.kContentPrimary,
        ),
        headlineSmall: AppTextStyles.headlineSmall(
          color: AppColors.kContentPrimary,
        ),
        titleLarge: AppTextStyles.titleLarge(color: AppColors.kBrandPrimary),
        titleMedium: AppTextStyles.titleMedium(color: AppColors.kBrandPrimary),
        titleSmall: AppTextStyles.titleSmall(color: AppColors.kBrandPrimary),
        bodyLarge: AppTextStyles.bodyLarge(color: AppColors.kContentPrimary),
        bodyMedium: AppTextStyles.bodyMedium(color: AppColors.kContentPrimary),
        bodySmall: AppTextStyles.bodySmall(color: AppColors.kContentPrimary),
        labelLarge: AppTextStyles.labelLarge(
          color: AppColors.kContentSecondary,
        ),
        labelMedium: AppTextStyles.labelMedium(
          color: AppColors.kContentSecondary,
        ),
        labelSmall: AppTextStyles.labelSmall(
          color: AppColors.kContentSecondary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.kSurfaceAlt,
        elevation: 0,
        shadowColor: AppColors.kShadowOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
        ),
        margin: EdgeInsets.zero,
      ),

      // ElevatedButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kBrandPrimary,
          foregroundColor: AppColors.kContentInverse,
          elevation: AppDimensions.elevationS,
          shadowColor: AppColors.kShadowOverlay,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          textStyle: AppTextStyles.buttonLarge(
            color: AppColors.kContentInverse,
          ),
          minimumSize: Size.fromHeight(AppDimensions.buttonHeight),
        ),
      ),

      // OutlinedButtonTheme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kBrandPrimary,
          side: BorderSide(color: AppColors.kBrandPrimary, width: 1.5.w),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: AppTextStyles.button(color: AppColors.kBrandPrimary),
          minimumSize: Size.fromHeight(AppDimensions.buttonHeight),
        ),
      ),

      // TextButtonTheme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kBrandPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingS,
          ),
          textStyle: AppTextStyles.button(color: AppColors.kBrandPrimary),
        ),
      ),

      // InputDecorationTheme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kSurfaceCard.withValues(alpha: 0.8),
        focusColor: AppColors.kSurfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: AppColors.kBrandPrimary.withValues(alpha: 0.1),
            width: 2.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: Color(0xFFD4CDB8), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kBrandPrimary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError, width: 1.5.w),
        ),
        hintStyle: AppTextStyles.bodyLarge(
          color: AppColors.kContentSecondary.withValues(alpha: 0.5),
        ),
        labelStyle: AppTextStyles.bodyLarge(
          color: AppColors.kContentSecondary.withValues(alpha: 0.5),
        ),
        floatingLabelStyle: AppTextStyles.bodyLarge(
          color: AppColors.kContentSecondary,
        ),
      ),

      // BottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kSurfaceCard,
        selectedItemColor: AppColors.kBrandPrimary,
        unselectedItemColor: AppColors.kContentAccentGreen,
        selectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kBrandPrimary,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kContentAccentGreen,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationL,
      ),

      // FloatingActionButtonTheme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.kBrandPrimary,
        foregroundColor: AppColors.kContentInverse,
        elevation: AppDimensions.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
      ),

      // DividerTheme
      dividerTheme: DividerThemeData(
        color: AppColors.kDividerDefault,
        thickness: 1.3.h,
        space: 1.h,
      ),

      // IconTheme
      iconTheme: IconThemeData(
        color: AppColors.kBrandPrimary,
        size: AppDimensions.iconM,
      ),

      // ProgressIndicatorTheme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.kBrandPrimary,
        linearTrackColor: AppColors.kDividerDefault,
        circularTrackColor: AppColors.kDividerDefault,
      ),

      // ChipTheme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.kSurfaceCard,
        selectedColor: AppColors.kBrandPrimary,
        disabledColor: AppColors.kDividerDefault,
        labelStyle: AppTextStyles.labelMedium(color: AppColors.kContentPrimary),
        secondaryLabelStyle: AppTextStyles.labelMedium(
          color: AppColors.kContentInverse,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),

      // DialogTheme
      dialogTheme: DialogThemeData(
        insetPadding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        backgroundColor: AppColors.kSurfaceCard,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        titleTextStyle: AppTextStyles.headlineLarge(
          color: AppColors.kContentPrimary,
        ),
        contentTextStyle: AppTextStyles.bodyMedium(
          color: AppColors.kContentSecondary,
        ),
      ),

      // BottomSheetTheme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.kSurfaceCard,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
      ),

      // TabBarTheme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.kBrandPrimary,
        unselectedLabelColor: AppColors.kContentAccentGreen,
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.kBrandPrimary),
        unselectedLabelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kContentAccentGreen,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.kBrandPrimary, width: 3.w),
        ),
      ),
    );
  }

  // static String _getFontFamily(BuildContext context) {
  //   try {
  //     final locale = Localizations.localeOf(context);
  //     return AppTextStyles.fontFor(locale);
  //   } catch (e) {
  //     return AppTextStyles.arabicFont; // Default to Arabic
  //   }
  // }
}

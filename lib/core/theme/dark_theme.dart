import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

// ============================================================================
// DARK THEME
// ============================================================================
class DarkTheme {
  static ThemeData getTheme(BuildContext context) {
    // تعريف اللون الجديد لـ BorderSide (40% شفافية) لتجنب تحذير withOpacity
    // نستخدم kDarkContentSecondary كقاعدة للحدود الخافتة
    final Color inputBorderColorDark = AppColors.kDarkContentSecondary
        .withAlpha(0x66);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.appfont,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.kPrimaryLight,
        primaryContainer: AppColors.kBrandPrimary,
        secondary: AppColors.kAccentBeige,
        secondaryContainer: AppColors.kSurfaceAlt,
        surface: AppColors.kDarkSurfaceCard,
        error: AppColors.kStatusError,
        onPrimary: AppColors.kDarkContentPrimary,
        onSecondary: AppColors.kDarkContentPrimary,
        onSurface: AppColors.kDarkContentPrimary,
        onError: AppColors.kContentInverse,
        outline: AppColors.kDarkDivider,
        shadow: AppColors.kShadowOverlay,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.kDarkSurfaceBackground,

      // App Bar Theme - استخدام الأبعاد المتجاوبة
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kDarkSurfaceCard,
        foregroundColor: AppColors.kDarkContentPrimary,
        elevation: AppDimensions.elevationS, // استخدام بُعد الـ Elevation
        shadowColor: AppColors.kShadowOverlay,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimensions.appBarHeight,
        titleTextStyle: AppTextStyles.headlineLarge(
          // استخدام ستايل متجاوب
          color: AppColors.kDarkContentPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.kPrimaryLight,
          size: AppDimensions.iconM,
        ),
      ),

      // TextTheme - استخدام AppTextStyles لجميع الستايلات
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        displayMedium: AppTextStyles.displayMedium(
          color: AppColors.kDarkContentPrimary,
        ),
        headlineLarge: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        headlineMedium: AppTextStyles.headlineMedium(
          color: AppColors.kDarkContentPrimary,
        ),
        headlineSmall: AppTextStyles.headlineSmall(
          color: AppColors.kDarkContentPrimary,
        ),
        bodyLarge: AppTextStyles.bodyLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        bodyMedium: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),
        bodySmall: AppTextStyles.bodySmall(
          color: AppColors.kDarkContentSecondary,
        ),
        labelLarge: AppTextStyles.labelLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        labelMedium: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentPrimary,
        ),
        labelSmall: AppTextStyles.labelSmall(
          color: AppColors.kDarkContentSecondary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.kDarkSurfaceCard,
        elevation: AppDimensions.elevationS,
        shadowColor: AppColors.kShadowOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme - استخدام الأبعاد والستايلات المتجاوبة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryLight,
          foregroundColor: AppColors.kDarkContentPrimary,
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
            color: AppColors.kDarkContentPrimary,
          ),
          minimumSize: Size.fromHeight(AppDimensions.buttonHeight),
        ),
      ),

      // Outlined Button Theme - استخدام الأبعاد والستايلات المتجاوبة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kPrimaryLight,
          side: BorderSide(
            color: AppColors.kPrimaryLight,
            width: 1.5.w,
          ), // العرض متجاوب
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: AppTextStyles.button(
            color: AppColors.kPrimaryLight,
          ), // ستايل متجاوب
          minimumSize: Size.fromHeight(AppDimensions.buttonHeight),
        ),
      ),

      // Text Button Theme - استخدام الستايلات المتجاوبة
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kPrimaryLight,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingS,
          ),
          textStyle: AppTextStyles.button(
            color: AppColors.kPrimaryLight,
          ), // ستايل متجاوب
        ),
      ),

      // Input Decoration Theme - تم تصحيح استخدام Opacity والستايلات المتجاوبة
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kDarkSurfaceCard,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: inputBorderColorDark), // اللون المصحح
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: inputBorderColorDark), // اللون المصحح
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: AppColors.kPrimaryLight,
            width: 2.w,
          ), // العرض متجاوب
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: AppColors.kStatusError,
            width: 2.w,
          ), // العرض متجاوب
        ),
        hintStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ), // ستايل متجاوب
        labelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ), // ستايل متجاوب
      ),

      // Bottom Navigation Bar Theme - استخدام الستايلات المتجاوبة
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        selectedItemColor: AppColors.kPrimaryLight,
        unselectedItemColor: AppColors.kDarkContentSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kPrimaryLight,
        ), // ستايل متجاوب
        unselectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kDarkContentSecondary,
        ), // ستايل متجاوب
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationL,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.kPrimaryLight,
        foregroundColor: AppColors.kDarkContentPrimary,
        elevation: AppDimensions.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
      ),

      // Divider Theme - استخدام الأبعاد المتجاوبة
      dividerTheme: DividerThemeData(
        color: AppColors.kDarkDivider,
        thickness: 1.h, // متجاوب
        space: 1.h, // متجاوب
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.kDarkContentPrimary,
        size: AppDimensions.iconM,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.kPrimaryLight,
        linearTrackColor: AppColors.kDarkDivider,
        circularTrackColor: AppColors.kDarkDivider,
      ),

      // Chip Theme - استخدام الستايلات المتجاوبة
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        selectedColor: AppColors.kPrimaryLight,
        disabledColor: AppColors.kDarkDivider,
        labelStyle: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentPrimary,
        ), // ستايل متجاوب
        secondaryLabelStyle: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentPrimary,
        ), // ستايل متجاوب
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),

      // Dialog Theme - استخدام الستايلات المتجاوبة
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        titleTextStyle: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ), // ستايل متجاوب
        contentTextStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ), // ستايل متجاوب
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
      ),

      // Tab Bar Theme - استخدام الستايلات المتجاوبة
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.kPrimaryLight,
        unselectedLabelColor: AppColors.kDarkContentSecondary,
        labelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kPrimaryLight,
        ), // ستايل متجاوب
        unselectedLabelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ), // ستايل متجاوب
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.kPrimaryLight,
            width: 3.w,
          ), // العرض متجاوب
        ),
      ),
    );
  }
}

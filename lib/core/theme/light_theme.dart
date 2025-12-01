import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

class LightTheme {
  static ThemeData getTheme(BuildContext context) {
    // تعريف اللون الجديد لـ BorderSide (40% شفافية) مباشرة لتجنب withOpacity
    // القيمة 0x66 هي قيمة Alpha channel لـ 40%
    final Color inputBorderColor = AppColors.kContentSecondary.withAlpha(0x66);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.appfont,

      // Color Scheme - الألوان الوظيفية الجديدة
      colorScheme: ColorScheme.light(
        primary: AppColors.kBrandPrimary,
        primaryContainer: AppColors.kBrandPrimary,
        secondary: AppColors.kAccentBeige,
        secondaryContainer: AppColors.kSurfaceAlt,
        tertiary: AppColors.kDarkSurfaceBackground,
        surface: AppColors.kSurfaceCard,
        error: AppColors.kStatusError,
        onPrimary: AppColors.kContentInverse,
        onSecondary: AppColors.kContentPrimary,
        onSurface: AppColors.kContentPrimary,
        onError: AppColors.kContentInverse,
        outline: AppColors.kBorderDefault,
        shadow: AppColors.kShadowOverlay,
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

      // TextTheme - تم استخدام AppTextStyles لتعريف الستايلات بشكل صحيح
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
        bodyLarge: AppTextStyles.bodyLarge(color: AppColors.kContentPrimary),
        bodyMedium: AppTextStyles.bodyMedium(
          color: AppColors.kContentSecondary,
        ),
        bodySmall: AppTextStyles.bodySmall(color: AppColors.kContentSecondary),
        labelLarge: AppTextStyles.labelLarge(color: AppColors.kContentPrimary),
        labelMedium: AppTextStyles.labelMedium(
          color: AppColors.kContentPrimary,
        ),
        labelSmall: AppTextStyles.labelSmall(
          color: AppColors.kContentSecondary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.kSurfaceCard,
        elevation: AppDimensions.elevationS,
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

      // InputDecorationTheme - تم تصحيح استخدام Opacity
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kSurfaceBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          // تم استبدال .withOpacity(0.4) بـ withAlpha(0x66)
          borderSide: BorderSide(color: inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          // تم استبدال .withOpacity(0.4) بـ withAlpha(0x66)
          borderSide: BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kBrandPrimary, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError, width: 2.w),
        ),
        hintStyle: AppTextStyles.bodyMedium(color: AppColors.kContentSecondary),
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
        thickness: 1.h,
        space: 1.h,
      ),

      // IconTheme
      iconTheme: IconThemeData(
        color: AppColors.kContentPrimary,
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

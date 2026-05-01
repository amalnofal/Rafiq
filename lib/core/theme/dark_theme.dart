import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

// ============================================================================
// DARK THEME - محدّث حسب الثيم الجديد
// ============================================================================
class DarkTheme {
  static ThemeData getTheme(BuildContext context) {
    final Color inputBorderColorDark = AppColors.kDarkBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.appfont,

      hintColor: AppColors.kDarkContentSecondary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.kDarkBrandPrimary,
        primaryContainer: AppColors.kDarkSurfaceCard,

        secondary: AppColors.kDarkContainer,

        tertiary: AppColors.kDarkSurfaceCard,

        tertiaryContainer: AppColors.kStatusSuccessDark,
        onTertiaryContainer: AppColors.kContentGreenDark,

        surface: AppColors.kDarkSurfaceCard,
        surfaceContainerHighest: AppColors.kDarkContainer,
        surfaceContainer: AppColors.kPrimaryDark,

        error: AppColors.kStatusError,

        onPrimary: AppColors.kDarkContentPrimary,
        onPrimaryContainer: AppColors.kDarkBrandPrimary,
        onSecondary: AppColors.kDarkContentSecondary,
        onSurface: AppColors.kDarkContentPrimary,
        onError: AppColors.kContentInverse,
        onTertiary: AppColors.kDarkContentSecondary,
        outline: AppColors.kDarkBorder,
        outlineVariant: AppColors.kDarkDivider,
        shadow: AppColors.kShadowOverlay,

        // onSurfaceVariant: AppColors.kDarkContentSecondary,
      ),

      // Scaffold Background - الخلفية السوداء الداكنة
      scaffoldBackgroundColor: AppColors.kDarkSurfaceBackground,
      shadowColor: Colors.transparent,
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kDarkContainer,
        foregroundColor: AppColors.kDarkContentPrimary,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimensions.appBarHeight,
        titleTextStyle: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.kDarkBrandPrimary,
          size: AppDimensions.iconM,
        ),
      ),

      // TextTheme
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
          color: AppColors.kDarkContentPrimary,
        ),
        bodySmall: AppTextStyles.bodySmall(
          color: AppColors.kDarkContentPrimary,
        ),
        titleLarge: AppTextStyles.titleLarge(
          color: AppColors.kDarkBrandPrimary,
        ),
        titleMedium: AppTextStyles.titleMedium(
          color: AppColors.kDarkBrandPrimary,
        ),
        titleSmall: AppTextStyles.titleSmall(
          color: AppColors.kDarkBrandPrimary,
        ),
        labelLarge: AppTextStyles.labelLarge(
          color: AppColors.kDarkContentSecondary,
        ),
        labelMedium: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentSecondary,
        ),
        labelSmall: AppTextStyles.labelSmall(
          color: AppColors.kDarkContentSecondary,
        ),
      ),

      // Card Theme - محدّث
      cardTheme: CardThemeData(
        color: AppColors.kDarkSurfaceCard,
        elevation: 0,
        // shadowColor: AppColors.kShadowOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          // side: BorderSide(color: AppColors.kDarkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme - باللون الزيتوني الغامق الجديد
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.kDarkBrandPrimary,
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
            ).copyWith(
              // تأثير الضغط
              overlayColor: WidgetStateProperty.all(
                AppColors.kDarkBrandPrimaryDarker.withValues(alpha: 0.2),
              ),
            ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kDarkBrandPrimary,
          side: BorderSide(color: AppColors.kDarkBrandPrimary, width: 1.5.w),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: AppTextStyles.button(color: AppColors.kDarkBrandPrimary),
          minimumSize: Size.fromHeight(AppDimensions.buttonHeight),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kDarkBrandPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingS,
          ),
          textStyle: AppTextStyles.button(color: AppColors.kDarkBrandPrimary),
        ),
      ),

      // Input Decoration Theme - محدّث
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        focusColor: AppColors.kDarkSurfaceCard,
        fillColor: AppColors.kDarkInputBackground,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: inputBorderColorDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: inputBorderColorDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: AppColors.kDarkBrandPrimary,
            width: 2.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.kStatusError, width: 2.w),
        ),
        hintStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),
        labelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),
      ),

      // Bottom Navigation Bar Theme - محدّث
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        selectedItemColor: AppColors.kDarkBrandPrimary,
        unselectedItemColor: AppColors.kDarkContentSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kDarkBrandPrimary,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall(
          color: AppColors.kDarkContentSecondary,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationL,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.kDarkBrandPrimary,
        foregroundColor: AppColors.kContentInverse,
        elevation: AppDimensions.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.kDarkDivider,
        thickness: 1.3.h,
        space: 1.h,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.kDarkContentPrimary,
        size: AppDimensions.iconM,
      ),

      // Progress Indicator Theme - محدّث
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.kDarkBrandPrimary,
        linearTrackColor: AppColors.kDarkDivider,
        circularTrackColor: AppColors.kDarkDivider,
      ),

      // Chip Theme - محدّث
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.kDarkContainer,
        selectedColor: AppColors.kDarkBrandPrimary,
        disabledColor: AppColors.kDarkDivider,
        labelStyle: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentPrimary,
        ),
        secondaryLabelStyle: AppTextStyles.labelMedium(
          color: AppColors.kDarkContentPrimary,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        side: BorderSide(color: AppColors.kDarkBorder),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        insetPadding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        backgroundColor: AppColors.kDarkSurfaceCard,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        titleTextStyle: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ),
        contentTextStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),
      ),

      // Date Picker Theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.kDarkSurfaceCard,
        headerBackgroundColor: AppColors.kDarkSurfaceCard,
        headerForegroundColor: AppColors.kContentInverse,
        surfaceTintColor: Colors.transparent,

        weekdayStyle: AppTextStyles.titleLarge(
          color: AppColors.kDarkContentPrimary,
        ),

        yearStyle: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ),

        dayStyle: AppTextStyles.bodyLarge(
          color: AppColors.kDarkContentSecondary,
        ),

        dayForegroundColor: WidgetStateProperty.all(
          AppColors.kDarkContentSecondary,
        ),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kContentInverse;
          }
          return AppColors.kDarkContentPrimary;
        }),
        headerHeadlineStyle: AppTextStyles.headlineLarge(
          color: AppColors.kDarkContentPrimary,
        ),

        headerHelpStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),

        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(
            AppColors.kDarkContentPrimary,
          ),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(
            AppColors.kDarkContentSecondary,
          ),
        ),
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

      // Tab Bar Theme - محدّث
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.kDarkBrandPrimary,
        unselectedLabelColor: AppColors.kDarkContentSecondary,
        labelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkBrandPrimary,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium(
          color: AppColors.kDarkContentSecondary,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.kDarkBrandPrimary,
            width: 3.w,
          ),
        ),
      ),

      // Switch Theme - محدّث
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kContentInverse;
          }
          return AppColors.kDarkContentSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kDarkBrandPrimary;
          }
          return AppColors.kDarkSwitchBackground;
        }),
      ),

      // Slider Theme - محدّث
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.kDarkBrandPrimary,
        inactiveTrackColor: AppColors.kDarkContainer,
        thumbColor: AppColors.kDarkBrandPrimary,
        overlayColor: AppColors.kDarkBrandPrimary.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.kDarkBrandPrimary,
      ),

      // Radio Theme - محدّث
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kDarkBrandPrimary;
          }
          return AppColors.kDarkContentSecondary;
        }),
      ),

      // Checkbox Theme - محدّث
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kDarkBrandPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.kContentInverse),
        side: BorderSide(color: AppColors.kDarkBorder, width: 2),
      ),
    );
  }
}

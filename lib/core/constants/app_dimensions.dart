import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================================
// APP DIMENSIONS - نظام الأبعاد المتجاوبة (Responsive Dimensions)
// يعتمد على حزمة flutter_screenutil لوحدات: .w (عرض), .h (ارتفاع), .r (نصف قطر), .sp (حجم خط)
// ============================================================================

class AppDimensions {
  // ============================================================================
  // 1. PADDING & MARGINS
  // ============================================================================

  /// Extra Small Padding/Spacing (4.w)
  static double get paddingXS => 4.w;

  /// Small Padding/Spacing (8.w)
  static double get paddingS => 8.w;

  /// Medium Padding/Spacing (12.w)
  static double get paddingM => 12.w;

  /// Default Padding/Spacing (16.w)
  static double get padding => 16.w;

  /// Large Padding/Spacing (20.w)
  static double get paddingL => 20.w;

  /// Extra Large Padding/Spacing (24.w)
  static double get paddingXL => 24.w;

  /// Double Extra Large Padding/Spacing (32.w)
  static double get paddingXXL => 32.w;

  // ============================================================================
  // 2. BORDER RADIUS
  // ============================================================================

  /// Extra Small Radius (4.r)
  static double get radiusXS => 4.r;

  /// Small Radius (8.r)
  static double get radiusS => 8.r;

  /// Medium Radius (12.r)
  static double get radiusM => 12.r;

  /// Default Radius (16.r)
  static double get radius => 16.r;

  /// Large Radius (20.r)
  static double get radiusL => 20.r;

  /// Extra Large Radius (24.r)
  static double get radiusXL => 24.r;

  /// Double Extra Large Radius (32.r)
  static double get radiusXXL => 32.r;

  /// Circular Radius (999.r)
  static double get radiusCircle => 999.r;

  // ============================================================================
  // 3. ICON SIZES
  // ============================================================================

  /// Icon Extra Small (16.w)
  static double get iconXS => 16.w;

  /// Icon Small (20.w)
  static double get iconS => 20.w;

  /// Icon Medium / Default (24.w)
  static double get iconM => 24.w;

  /// Icon (28.w) - تم حذفها وإبقاء M و L
  // static double get icon => 28.w;

  /// Icon Large (32.w)
  static double get iconL => 32.w;

  /// Icon Extra Large (40.w)
  static double get iconXL => 40.w;

  /// Icon Double Extra Large (48.w)
  static double get iconXXL => 48.w;

  // ============================================================================
  // 4. AVATAR SIZES
  // ============================================================================

  /// Avatar Small (32.w)
  static double get avatarS => 32.w;

  /// Avatar Medium (40.w)
  static double get avatarM => 40.w;

  /// Avatar Default (48.w)
  static double get avatar => 48.w;

  /// Avatar Large (64.w)
  static double get avatarL => 64.w;

  /// Avatar Extra Large (80.w)
  static double get avatarXL => 80.w;

  /// Avatar Double Extra Large (120.w)
  static double get avatarXXL => 120.w;

  // ============================================================================
  // 5. COMPONENT DIMENSIONS (Heights)
  // ============================================================================

  /// Small Button Height (36.h)
  static double get buttonHeightS => 36.h;

  /// Default Button Height (52.h)
  static double get buttonHeight => 52.h;

  /// Large Button Height (64.h)
  static double get buttonHeightL => 64.h;

  /// Bottom Navigation Bar Height (70.h)
  static double get bottomNavHeight => 70.h;

  /// App Bar Height (70.h)
  static double get appBarHeight => 70.h;

  // ============================================================================
  // 6. NON-RESPONSIVE (ELEVATION & SHADOWS)
  // تستخدم قيم ثابتة (double)
  // ============================================================================

  /// Small Elevation (e.g., small card shadow)
  static const double elevationS = 2.0;

  /// Default Elevation (e.g., standard card shadow)
  static const double elevation = 4.0;

  /// Medium Elevation
  static const double elevationM = 6.0;

  /// Large Elevation (e.g., modals, large sheets)
  static const double elevationL = 8.0;

  // ============================================================================
  // 7. PROGRESS INDICATOR THICKNESS
  // ============================================================================

  /// Thin Progress Stroke Width (4.w)
  static double get progressStrokeWidthThin => 4.w;

  /// Default Progress Stroke Width (8.w)
  static double get progressStrokeWidth => 8.w;

  /// Thick Progress Stroke Width (12.w)
  static double get progressStrokeWidthThick => 12.w;

  // ============================================================================
  // 8. HELPER METHODS (Device Type)
  // ============================================================================

  /// Screen Breakpoints (Mobile & Tablet Only)
  static const double tabletSmallBreakpoint = 600.0; 

  /// Check if the device is a mobile phone
  static bool get isMobile => ScreenUtil().screenWidth < tabletSmallBreakpoint;

  /// Check if the device is a tablet
  static bool get isTablet => ScreenUtil().screenWidth >= tabletSmallBreakpoint;
}
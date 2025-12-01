import 'package:flutter/material.dart';

// ============================================================================
// APP COLORS - نظام ألوان وظيفي (Functional Naming System)
// ============================================================================

class AppColors {
  // ============================================================================
  // 1. BRAND & PRIMARY COLORS - ألوان العلامة التجارية الأساسية
  // تستخدم للأزرار، الأيقونات التفاعلية، والعناصر التي تمثل الهوية.
  // ============================================================================

  /// Brand Primary - اللون الزيتوني الأساسي (#6B7E3F) - (346 استخدام)
  static const Color kBrandPrimary = Color(0xFF6B7E3F);

  /// Brand Primary Dark - مشتق غامق للـ Primary (للتظليل/الضغط) (#556331)
  static const Color kPrimaryDark = Color(0xFF556331);

  /// Brand Primary Light - زيتوني فاتح (#8B9D5F) - (8 استخدامات)
  static const Color kPrimaryLight = Color(0xFF8B9D5F);

  /// Brand Primary Lighter - زيتوني أفتح جداً (#A5B87F) - (1 استخدام)
  static const Color kPrimaryLighter = Color(0xFFA5B87F);

  // ============================================================================
  // 2. SURFACE & BACKGROUND COLORS (LIGHT MODE) - ألوان الخلفيات والسطح
  // ============================================================================

  /// Surface Background - خلفية الشاشات الرئيسية (بيج فاتح #FAFAF7) - (43 استخدام)
  static const Color kSurfaceBackground = Color(0xFFFAFAF7);

  /// Surface Card - خلفية البطاقات (أبيض نقي #FFFFFF) - (299 استخدام)
  static const Color kSurfaceCard = Color(0xFFFFFFFF);

  /// Surface Alternate - خلفية مكونات بديلة / رمادي خفيف (#F5F3ED) - (158 استخدام)
  static const Color kSurfaceAlt = Color(0xFFF5F3ED);

  /// Surface Card Light Gray - رمادي فاتح جداً لخلفيات الحقول (#F9FAFB) - (15 استخدام)
  static const Color kSurfaceLightGray = Color(0xFFF9FAFB);

  // ============================================================================
  // 3. CONTENT & TEXT COLORS (LIGHT MODE) - ألوان النصوص والمحتوى
  // ============================================================================

  /// Content Primary - النص الأساسي (زيتوني داكن جداً #2D3319) - (194 استخدام)
  static const Color kContentPrimary = Color(0xFF2D3319);

  /// Content Secondary/Muted - النص الثانوي/الخافت (زيتوني خفيف #6B7558) - (501 استخدام - الأكثر استخداماً!)
  static const Color kContentSecondary = Color(0xFF6B7558);

  /// Content Accent Green - نص أخضر مميز (#2D5F35) - (36 استخدام)
  static const Color kContentAccentGreen = Color(0xFF2D5F35);

  /// Content Inverse - نص أبيض يستخدم فوق الخلفيات الداكنة (#FFFFFF)
  static const Color kContentInverse = Color(0xFFFFFFFF);

  /// Content Gray - لون رمادي للنصوص غير النشطة/الملاحظات (#99A1AF) - (16 استخدام)
  static const Color kContentGray = Color(0xFF99A1AF);

  // ============================================================================
  // 4. STATUS COLORS - ألوان الحالات والرسائل التفاعلية
  // ============================================================================

  /// Status Success - لون النجاح الأساسي (#00A63E) - (10 استخدامات)
  static const Color kStatusSuccess = Color(0xFF00A63E);

  /// Status Success Background - خلفية رسائل النجاح (أخضر فاتح #D4F4DD) - (18 استخدام)
  static const Color kStatusSuccessBackground = Color(0xFFD4F4DD);

  /// Status Warning - لون التحذير الأساسي (#FDC700) - (16 استخدام)
  static const Color kStatusWarning = Color(0xFFFDC700);

  /// Status Error - لون الخطأ الأساسي (#FB2C36) - (57 استخدام)
  static const Color kStatusError = Color(0xFFFB2C36);

  /// Status Error Background - خلفية رسائل الخطأ (وردي فاتح #FFE2E2) - (20 استخدام)
  static const Color kStatusErrorBackground = Color(0xFFFFE2E2);

  /// Status Info - لون المعلومات/الإشعارات (أزرق #1E40AF) - (22 استخدام)
  static const Color kStatusInfo = Color(0xFF1E40AF);

  /// Status Info Background - خلفية معلومات (أزرق فاتح #DBEAFE) - (15 استخدام)
  static const Color kStatusInfoBackground = Color(0xFFDBEAFE);

  // ============================================================================
  // 5. UI & SUPPORT COLORS - الحدود، الفواصل، والظلال
  // ============================================================================

  /// Border Default - لون الحدود الفاصلة بين العناصر (#E5E7EB) - (2 استخدام)
  static const Color kBorderDefault = Color(0xFFE5E7EB);

  /// Divider Default - لون الخطوط الفاصلة (#F3F4F6) - (12 استخدام)
  static const Color kDividerDefault = Color(0xFFF3F4F6);

  /// Accent Beige (Toggle/Input Background) - بيج مائل للرمادي (#D4CDB8) - (5 استخدامات)
  static const Color kAccentBeige = Color(0xFFD4CDB8);

  /// Shadow Overlay - ظل خفيف (أسود بشفافية 10%) - (282 استخدام)
  static const Color kShadowOverlay = Color(0x52000000);

  // ============================================================================
  // 6. DARK MODE COLORS - الألوان المخصصة للوضع الداكن
  // ============================================================================

  /// Dark Surface Background - خلفية الشاشة الداكنة (#1A1A1A)
  static const Color kDarkSurfaceBackground = Color(0xFF1A1A1A);

  /// Dark Surface Card - خلفية البطاقات الداكنة (#2A2A2A)
  static const Color kDarkSurfaceCard = Color(0xFF2A2A2A);

  /// Dark Content Primary - النص الأساسي في الوضع الداكن (#F5F5F5)
  static const Color kDarkContentPrimary = Color(0xFFF5F5F5);

  /// Dark Content Secondary - النص الثانوي في الوضع الداكن (#B8B8B8)
  static const Color kDarkContentSecondary = Color(0xFFB8B8B8);

  /// Dark Divider - خط فاصل داكن (#404040)
  static const Color kDarkDivider = Color(0xFF404040);

  // ============================================================================
  // 7. GRADIENT COLORS - التدرجات اللونية
  // ============================================================================

  /// Primary Gradient - تدرج الزيتوني (للأزرار الرئيسية)
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [kBrandPrimary, kPrimaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success Gradient - تدرج النجاح
  static final LinearGradient successGradient = LinearGradient(
    colors: [kStatusSuccess, Color(0xFF00C950)], // C950 - (10 استخدامات)
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // 8. UNUSED / LEGACY COLORS - ألوان ذات استخدام منخفض جداً أو غير مرتبطة
  // تم تجميعها هنا للإبقاء عليها دون استخدامها كجزء من النظام الأساسي.
  // ============================================================================

  /// Legacy Dark Gray - رمادي داكن للنصوص/الأيقونات (#6A7282) - (28 استخدام)
  static const Color kLegacyDarkGray = Color(0xFF6A7282);

  /// Legacy Very Dark Gray - أسود عميق (#101828) - (23 استخدام)
  static const Color kLegacyVeryDark = Color(0xFF101828);

  /// Legacy Brown Text - نص بني داكن (#733E0A) - (3 استخدامات)
  static const Color kLegacyBrownText = Color(0xFF733E0A);

  /// Legacy Orange Brown Text - نص برتقالي بني (#894B00) - (3 استخدامات)
  static const Color kLegacyOrangeBrownText = Color(0xFF894B00);

  /// Legacy Accent Purple - لون أرجواني إضافي (#AD46FF) - (8 استخدامات)
  static const Color kLegacyAccentPurple = Color(0xFFAD46FF);

  /// Legacy Warning Alt - برتقالي تحذيري بديل (#F59E0B) - (3 استخدامات)
  static const Color kLegacyWarningAlt = Color(0xFFF59E0B);
}

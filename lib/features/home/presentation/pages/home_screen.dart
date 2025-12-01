import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/home_appbar.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان المستخلصة من الثيم والأساسية
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // تعريف شفافية الأبيض/الخلفية لتجنب تحذير withOpacity
    // 0xD9 تمثل 85% شفافية، و 0xCC تمثل 80%
    final Color surfaceOverlay85 = colorScheme.surface.withAlpha(0xD9);
    final Color surfaceOverlay80 = colorScheme.surface.withAlpha(0xCC);

    return RafiqScaffold(
      // نفترض أن homeAppBar قد تم تحديثه ليستخدم CircleIconButton الجديد
      appBar: homeAppBar(userName: "أحمد محمد"),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
        child: Card(
          // Card هنا سيستخدم الـ CardTheme المحدد مسبقاً
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // ============================
              // الصورة + الكارد اللي فوقها
              // ============================
              Stack(
                children: [
                  // ===== الصورة =====
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radius),
                      topRight: Radius.circular(AppDimensions.radius),
                    ),
                    child: Image.asset(
                      "assets/images/dog_max.png",
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ===== رقم 1/2 (العداد) =====
                  Positioned(
                    top: AppDimensions.paddingM,
                    right: AppDimensions.paddingM,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingS,
                      ),
                      decoration: BoxDecoration(
                        // استخدام اللون الشفاف المصحح (Overlay)
                        color: surfaceOverlay85,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Text(
                        "2 / 1",
                        // استخدام bodyLarge من الثيم
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  // ===== الكارد الشفافة فوق الصورة =====
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(AppDimensions.paddingM), // متجاوب
                      padding: EdgeInsets.all(AppDimensions.paddingM), // متجاوب
                      decoration: BoxDecoration(
                        // استخدام اللون الشفاف المصحح (Overlay)
                        color: surfaceOverlay80,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ), // متجاوب
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // يمين (الاسم + العمر)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ماكس",
                                // استخدام bodyLarge من الثيم (لون أساسي)
                                style: textTheme.bodyLarge,
                              ),
                              Text(
                                "كلب جولدن ريتريفر • 3 سنوات",
                                // استخدام bodySmall من الثيم (لون ثانوي/خافت)
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                          // يسار (ممتاز)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingS,
                            ),
                            decoration: BoxDecoration(
                              // استخدام لون خلفية حالة النجاح
                              color: AppColors.kStatusSuccessBackground,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusL,
                              ), // متجاوب
                            ),
                            child: Text(
                              "ممتاز",
                              // استخدام لون نص أخضر مميز (Content Accent Green)
                              style: AppTextStyles.labelMedium(
                                color: AppColors.kContentAccentGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.padding),
              // ============================
              // أرقام الحرارة – النشاط – النبض
              // ============================
              Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatCard(
                      title: "النبض",
                      value: "82",
                      icon: "assets/icons/heart.svg",
                    ),
                    StatCard(
                      title: "النشاط",
                      value: "8547",
                      icon: "assets/icons/activity.svg",
                    ),
                    StatCard(
                      title: "الحرارة",
                      value: "38.2°",
                      icon: "assets/icons/temp.svg",
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.padding),
              // ============================
              // نصيحة اليوم
              // ============================
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.padding,
                ), // متجاوب
                padding: EdgeInsets.all(AppDimensions.padding), // متجاوب
                decoration: BoxDecoration(
                  // استخدام لون خلفية حالة النجاح
                  color: AppColors.kStatusSuccessBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radius,
                  ), // متجاوب
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "💡",
                      // حجم خط متجاوب
                      style: AppTextStyles.headlineMedium(),
                    ),
                    SizedBox(width: AppDimensions.paddingS), // متجاوب
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "نصيحة اليوم",
                            // استخدام لون النص الأخضر المميز
                            style: AppTextStyles.labelLarge(
                              color: AppColors.kContentAccentGreen,
                            ),
                          ),
                          Text(
                            "ماكس يحتاج إلى مزيد من التمارين اليوم. نشاطه أقل من المعتاد بنسبة 15٪.",
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ============================
              // زرارين في الأسفل
              // ============================
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomButton(title: "عرض الإحصائيات المفصلة"),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        title: "التفاصيل",
                        // استخدام الألوان الوظيفية الجديدة:
                        color: colorScheme.secondaryContainer, // Surface Alt
                        txtColor: colorScheme.primary, // Brand Primary
                        onpressed: () {}, // يجب أن يحتوي على دالة
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تم تحديث الدالة لتصبح متجاوبة وتستخدم الثيم
  Widget _statItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: AppDimensions.iconL,
        ), // حجم أيقونة متجاوب
        SizedBox(height: AppDimensions.paddingXS), // تباعد متجاوب
        Text(
          title,
          // ستايل ثانوي/خافت (كجزء من الثيم)
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          value,
          // ستايل لقيمة الإحصائيات (مثل statValue) مع اللون الأساسي
          style: AppTextStyles.headlineMedium(
            color: Theme.of(context).textTheme.headlineMedium!.color,
          ),
        ),
      ],
    );
  }
}

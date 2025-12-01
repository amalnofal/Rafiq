import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
// استيراد ملف الستايلات للوصول لـ buttonLarge
import 'package:rafiq/core/constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.color,
    this.txtColor,
    this.onpressed,
    this.icon,
    this.iconColor,
    this.height,
    this.width,
    this.preserveIconColors = false,
  });

  final String title;
  final Color? color;
  final Color? txtColor;
  final Color? iconColor;
  final VoidCallback? onpressed;
  final String? icon;
  final double? height;
  final double? width;
  final bool preserveIconColors;

  @override
  Widget build(BuildContext context) {
    // استخدام AppTextStyles.buttonLarge مباشرة كما طلبت
    final TextStyle buttonTextStyle = AppTextStyles.buttonLarge(
      color: txtColor ?? Theme.of(context).colorScheme.onPrimary,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onpressed,
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.all(
              color ?? Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.all(
              txtColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
            textStyle: WidgetStateProperty.all(buttonTextStyle),
            elevation: WidgetStateProperty.all(AppDimensions.elevationS),
            shadowColor: WidgetStateProperty.all(
              const Color.fromARGB(37, 0, 0, 0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                SvgPicture.asset(
                  icon!,
                  height: 18.w,
                  colorFilter: preserveIconColors
                      ? null
                      : ColorFilter.mode(
                          iconColor ?? Theme.of(context).iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                ),
                SizedBox(width: AppDimensions.paddingS),
              ],

              // ✅ الحل الجديد: استخدام FittedBox لتصغير حجم الخط ليناسب المساحة بدلاً من النقط
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: AppDimensions.paddingXS),
                  child: FittedBox(
                    fit: BoxFit
                        .scaleDown, // يُصغر النص فقط إذا كان أكبر من المساحة
                    child: Text(
                      title,
                      style: buttonTextStyle,
                      maxLines: 1, // سطر واحد، وسيتم تصغيره ليناسب العرض
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class CollarDataCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color? color;

  const CollarDataCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingM,
          horizontal: AppDimensions.paddingXXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة SVG
            SvgPicture.asset(
              icon,
              height: AppDimensions.iconM,
              width: AppDimensions.iconM,
              colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
            ),
            SizedBox(height: AppDimensions.paddingXS),

            // العنوان (النبض، النشاط...)
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppDimensions.paddingXS),

            // القيمة (82، 38.2...)
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBackTap;
  final Widget? bottomWidget;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBackTap,
    this.bottomWidget,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXL),
          bottomRight: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBackTap ?? () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: AppDimensions.iconS,
                      ),
                      SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        AppLocalizations.of(context)!.back,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: AppDimensions.paddingL),

              Row(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                    child: Image.asset(
                      "assets/icons/rafiq_logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(color: Colors.white),
                        ),

                        SizedBox(height: AppDimensions.paddingXS),
                        Text(
                          subtitle ?? "",
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (bottomWidget != null) ...[
                SizedBox(height: 20.h),
                bottomWidget!,
              ],

              SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/change_password_sheet.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PasswordSection extends StatelessWidget {
  const PasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.password,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          CustomContainer(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding,
                vertical: 8.h,
              ),
              leading: CircleIconButton("assets/icons/security.svg"),
              title: Text(
                context.l10n.change_password,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.kContentSecondary,
                size: AppDimensions.iconXS,
              ),
            ),

            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ChangePasswordSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

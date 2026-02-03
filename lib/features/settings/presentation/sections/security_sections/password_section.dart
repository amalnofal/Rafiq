import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/change_password_sheet.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_choice_tile.dart';
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
          // SizedBox(height: AppDimensions.paddingM),
          CustomContainer(
            padding: EdgeInsets.all(0),
            child: SettingChoiceTile(
              icon: "assets/icons/security.svg",
              title: AppLocalizations.of(context)!.change_password,
              subtitle: AppLocalizations.of(context)!.password_last_update(
                DateHelper.timeAgo(
                  DateTime.now().subtract(
                    Duration(days: 65),
                  ), // مثال: قبل شهرين و5 أيام
                  context,
                ),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // مهم جداً عشان الشاشة تطلع كاملة والكيبورد ميغطيش عليها
                backgroundColor: Colors.transparent, // عشان الكيرف يبان
                builder: (context) => const ChangePasswordSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

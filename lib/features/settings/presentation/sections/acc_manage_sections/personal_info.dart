import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/edit_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PersonalInfo extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const PersonalInfo({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.personal_info,
            style: Theme.of(context).textTheme.labelMedium,
          ),

          CustomContainer(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // 2. حقل الاسم الأول
                Row(
                  children: [
                    Expanded(
                      child: EditField(
                        // hint: AppLocalizations.of(context)!.firstName,
                        isFName: true,
                        icon: "assets/icons/user_icon.svg",
                        controller: firstNameController,
                      ),
                    ),
                    Expanded(
                      child: EditField(
                        // hint: AppLocalizations.of(context)!.lastName,
                        isLName: true,
                        icon: "assets/icons/user_icon.svg",
                        controller: lastNameController,
                      ),
                    ),
                  ],
                ),

                const Divider(),
                SizedBox(height: 8.h),

                // 4. حقل الإيميل
                EditField(
                  // hint: AppLocalizations.of(context)!.email,
                  icon: "assets/icons/email.svg",
                  controller: emailController,
                ),
                const Divider(),
                SizedBox(height: 8.h),

                // 5. حقل رقم الهاتف
                EditField(
                  // hint: AppLocalizations.of(context)!.phone_number,
                  icon: "assets/icons/phone.svg",
                  controller: phoneController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rafiq/features/settings/presentation/Widgets/edit_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/constants/app_colors.dart';

class PersonalInfo extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const PersonalInfo({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              AppLocalizations.of(context)!.personal_info,
              // style: TextStyle(color: AppColors.textSecondary),
            ),
          ),

          Card(
            child: Column(
              children: [
                EditField(
                  icon: "assets/icons/user_icon.svg",
                  title: AppLocalizations.of(context)!.name,
                  controller: nameController,
                ),
                const Divider(),
                EditField(
                  icon: "assets/icons/email.svg",
                  title: AppLocalizations.of(context)!.email,
                  controller: emailController,
                ),
                const Divider(),
                EditField(
                  icon: "assets/icons/phone.svg",
                  title: AppLocalizations.of(context)!.phone_number,
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

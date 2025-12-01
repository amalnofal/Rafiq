import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/danger_zone.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/personal_info.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/save_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account_management),
      ),
      body: Column(
        children: [
          // تمرير الـ controllers ل PersonalInfo
          PersonalInfo(
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
          ),
          const DangerZone(),
          // تمرير نفس الـ controllers ل SaveButton
          SaveButton(
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
          ),
        ],
      ),
    );
  }
}

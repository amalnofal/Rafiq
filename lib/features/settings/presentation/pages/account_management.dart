import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
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
  // 1. تعريف الكنترولرز بشكل صحيح (late عشان هنعملهم init تحت)
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // 2. ملء البيانات من اليوزر (مع معالجة الـ null)
    if (user != null) {
      firstNameController = TextEditingController(text: user.firstName);
      lastNameController = TextEditingController(text: user.lastName);
      emailController = TextEditingController(text: user.email);
      // الهاتف ممكن يكون null، فلو null نخليه نص فاضي
      phoneController = TextEditingController(text: user.phone ?? '');
    } else {
      // احتياطي لو اليوزر مش موجود (نادر الحدوث هنا)
      firstNameController = TextEditingController();
      lastNameController = TextEditingController();
      emailController = TextEditingController();
      phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    // 3. تنظيف الذاكرة
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.account_management,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView( // يفضل إضافة سكرول عشان الكيبورد
        child: Column(
          children: [
            // 4. تمرير الكنترولرز المنفصلة لـ PersonalInfo
            // (تأكدي إنك عدلتي PersonalInfo عشان تستقبلهم)
            PersonalInfo(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              phoneController: phoneController,
            ),
            
            const DangerZone(),
            
            SizedBox(height: AppDimensions.paddingM),
            
            // 5. تمرير الكنترولرز لـ SaveButton (اللي لسه معدلينه)
            SaveButton(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              phoneController: phoneController,
            ),
          ],
        ),
      ),
    );
  }
}
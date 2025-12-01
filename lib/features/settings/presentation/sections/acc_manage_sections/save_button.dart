import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class SaveButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const SaveButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return CustomButton(
      title: AppLocalizations.of(context)!.save_changes,
      width: double.infinity,
      onpressed: () {
        // الحفظ يتم فقط هنا
        userProvider.updateName(nameController.text);
        userProvider.updateEmail(emailController.text);
        userProvider.updatePhone(phoneController.text);

        // رسالة للمستخدم
        CustomSnackBar.show(
          context,
          message: AppLocalizations.of(context)!.changes_saved,
        );
      },
    );
  }
}

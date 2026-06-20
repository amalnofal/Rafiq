import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class SaveButton extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const SaveButton({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return CustomButton(
      title: context.l10n.save_changes,
      fontWeight: FontWeight.w500,
      onPressed: () async {
        final fNameError = ValidationHelper.validateName(
          firstNameController.text,
          context,
        );
        final lNameError = ValidationHelper.validateName(
          lastNameController.text,
          context,
        );
        final emailError = ValidationHelper.validateEmail(
          emailController.text,
          context,
        );

        final phoneText = phoneController.text.trim();
        final phoneError = phoneText.isEmpty
            ? null
            : ValidationHelper.validatePhone(
                phoneText,
                context,
                isOptional: true,
              );

        if (fNameError != null ||
            lNameError != null ||
            emailError != null ||
            phoneError != null) {
          showSnackBar(
            context,
            fNameError ??
                lNameError ??
                emailError ??
                phoneError ??
                context.l10n.unexpectedError,
            isError: true,
          );
          return;
        }

        try {
          await userProvider.saveInfoChanges(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneText.isEmpty ? null : phoneText,
          );

          if (context.mounted) {
            showSnackBar(context, context.l10n.changes_saved, isError: false);
          }
        } catch (e) {
          if (context.mounted) {
            showSnackBar(context, context.l10n.unexpectedError, isError: true);
          }
        }
      },
    );
  }
}

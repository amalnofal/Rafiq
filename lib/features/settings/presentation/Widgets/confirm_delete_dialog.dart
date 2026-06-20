import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class DeleteAccountDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  const DeleteAccountDialog({super.key, required this.onConfirm});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm(_passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomInfoDialog(
        title: AppLocalizations.of(context)!.confirmAccountDeletion,
        description:
            "${AppLocalizations.of(context)!.deleteAccountContent}\n${AppLocalizations.of(context)!.enterPasswordToConfirm}",
        confirmBtnText: AppLocalizations.of(context)!.delete_account,
        mainColor: AppColors.kStatusError,
        icon: Icons.error_outline_rounded,

        content: PasswordField(
          controller: _passwordController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleConfirm(),
        ),

        onConfirm: _handleConfirm,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/confirm_delete_dialog.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/main.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color alertcolor = AppColors.kStatusError;
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radius),
      child: CustomContainer(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
        borderColor: alertcolor.withAlpha(50),
        child: ListTile(
          leading: CircleIconButton(
            "assets/icons/trash.svg",
            color: alertcolor,
            bgColor: alertcolor.withValues(alpha: 0.1),
          ),
          title: Text(
            AppLocalizations.of(context)!.delete_account,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.kContentWarning),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.warning_delete_account,
            style: TextStyle(color: alertcolor),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => DeleteAccountDialog(
            onConfirm: (String password) async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await context.read<UserProvider>().deleteAccount(password);

                if (!context.mounted) return;

                Navigator.pop(context);

                // التوجيه لشاشة الدخول
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;

                Navigator.pop(context);

                final errorStr = e.toString();

                if (errorStr.contains("connectionError")) {
                  return;
                }

                String errorMsg = context.l10n.unexpectedError;

                if (errorStr.contains("wrongPassword")) {
                  errorMsg = context.l10n.wrongPassword;
                } else if (errorStr.contains("serverError")) {
                  errorMsg = context.l10n.unexpectedError;
                }

                showSnackBar(context, errorMsg, isError: true);
              }
            },
          ),
        );
      },
    );
  }
}

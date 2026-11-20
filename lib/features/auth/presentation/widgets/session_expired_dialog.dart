import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/features/auth/presentation/cubit/session_cubit/session_cubit.dart';

void showSessionExpiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8.w),
            Text(
              dialogContext.l10n.sessionExpiredTitle,
              style: Theme.of(dialogContext).textTheme.headlineMedium,
            ),
          ],
        ),
        content: Text(
          dialogContext.l10n.sessionExpiredMessage,
          style: Theme.of(dialogContext).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              dialogContext.read<SessionCubit>().reset();
              // Removes the dialog and every other route, then opens login.
              Navigator.of(dialogContext).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text(
              dialogContext.l10n.login,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}
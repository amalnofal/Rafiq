import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/cancel_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/features/settings/presentation/Widgets/password_rules.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // دالة الحفظ
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await context.read<UserProvider>().changePassword(
          currentPassword: _currentController.text,
          newPassword: _newController.text,
          confirmPassword: _confirmController.text,
        );

        if (!mounted) return;
        Navigator.pop(context);

        showSnackBar(context, context.l10n.passwordChangedSuccessfully);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);

        final errorStr = e.toString();

        if (errorStr.contains("connectionError")) return;

        String errorMsg = context.l10n.unexpectedError;
        if (errorStr.contains("wrongPassword")) {
          errorMsg = context.l10n.wrongPassword;
        } else if (errorStr.contains("serverError")) {
          errorMsg = context.l10n.unexpectedError;
        }

        showSnackBar(context, errorMsg, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        left: 24.w,
        right: 24.w,
        bottom: bottomPadding + 24.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.changePassword,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: AppDimensions.iconM,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingM),

              // --- 2. Fields ---

              // كلمة المرور الحالية
              PasswordField(
                controller: _currentController,
                labelText: context.l10n.currentPassword,
                textInputAction: TextInputAction.next,
              ),

              // كلمة المرور الجديدة
              PasswordField(
                controller: _newController,
                labelText: context.l10n.newPassword,
                textInputAction: TextInputAction.next,
                validator: (val) =>
                    ValidationHelper.validateStrongPassword(val, context),
              ),

              // ج) تأكيد كلمة المرور
              PasswordField(
                controller: _confirmController,
                labelText: context.l10n.confirmPassword,
                textInputAction: TextInputAction.done,
                validator: (val) => ValidationHelper.validateMatch(
                  val,
                  _newController.text,
                  context,
                ),
              ),
              SizedBox(height: AppDimensions.paddingM),
              const PasswordRules(),

              // --- Buttons ---
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: context.l10n.save,
                              fontWeight: FontWeight.w500,
                              height: AppDimensions.buttonHeightS,
                              elevation: 0,
                              onPressed: _submit,
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingM),
                          Expanded(child: CancelButton()),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

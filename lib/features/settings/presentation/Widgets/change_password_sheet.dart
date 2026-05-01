import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/cancel_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/features/settings/presentation/Widgets/password_rules.dart';
import 'package:rafiq/l10n/app_localizations.dart';

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

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // دالة الحفظ
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // هنا كود الـ API لتغيير الباسورد
      Navigator.pop(context);
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
                    AppLocalizations.of(context)!.change_password,
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
                labelText: AppLocalizations.of(context)!.currentPassword,
                textInputAction: TextInputAction.next,
              ),

              // كلمة المرور الجديدة
              PasswordField(
                controller: _newController,
                labelText: AppLocalizations.of(context)!.newPassword,
                textInputAction: TextInputAction.next,
                validator: (val) =>
                    ValidationHelper.validateStrongPassword(val, context),
              ),

              // ج) تأكيد كلمة المرور
              PasswordField(
                controller: _confirmController,
                labelText: AppLocalizations.of(context)!.confirmPassword,
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
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: AppLocalizations.of(context)!.save,
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

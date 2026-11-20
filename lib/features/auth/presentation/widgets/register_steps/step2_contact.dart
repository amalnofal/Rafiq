import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step2Contact extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onNext;

  const Step2Contact({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.onNext,
  });

  @override
  State<Step2Contact> createState() => _Step2ContactState();
}

class _Step2ContactState extends State<Step2Contact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().verifyEmail(
        widget.emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is EmailAvailable) {
          widget.onNext();
        } else if (state is EmailTaken) {
          showSnackBar(
            context,
            AppLocalizations.of(context)!.emailAlreadyExists,
            isError: true,
          );
        } else if (state is RegisterFailure) {
          String getLocalizedMessage(String key) {
            final lang = AppLocalizations.of(context)!;
            switch (key) {
              case 'connectionError':
                return lang.connectionError;
              case 'unexpectedError':
                return lang.unexpectedError;
              default:
                return key;
            }
          }

          showSnackBar(
            context,
            getLocalizedMessage(state.errorMessage),
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is EmailCheckLoading;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EmailField(controller: widget.emailController),

                    CustomTextField(
                      controller: widget.phoneController,
                      labelText:
                          "${AppLocalizations.of(context)!.phone_number} ${AppLocalizations.of(context)!.optional}",
                      prefixIcon: "assets/icons/phone.svg",
                      keyboardType: TextInputType.phone,
                      validator: (val) => ValidationHelper.validatePhone(
                        val,
                        context,
                        isOptional: true,
                      ),
                    ),
                    NextButton(onNext: _validateAndProceed),
                  ],
                ),
              ),
            ),

            if (isLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}

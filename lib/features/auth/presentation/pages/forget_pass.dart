import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/pages/verification_screen.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Timer? _cooldownTimer;
  int _cooldown = 0;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  void _checkCooldown() {
    final lastSent = VerificationScreenState.lastTimeCodeSent;
    if (lastSent == null) return;
    final secondsPassed = DateTime.now().difference(lastSent).inSeconds;
    if (secondsPassed < 59) {
      setState(() => _cooldown = 59 - secondsPassed);
      _startCooldownTimer();
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldown <= 1) {
        timer.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_cooldown > 0) return;
    if (_formKey.currentState!.validate()) {
      VerificationScreenState.lastTimeCodeSent = null;
      context.read<ForgetPasswordCubit>().sendCode(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is SendCodeSuccess) {
          final cubit = context.read<ForgetPasswordCubit>();
          showSnackBar(
            context,
            AppLocalizations.of(context)!.codeSent,
            isError: false,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: VerificationScreen(email: _emailController.text.trim()),
              ),
            ),
          ).then((_) {
            if (mounted) _checkCooldown();
          });
        } else if (state is ForgetPasswordFailure) {
          if (state.errMessage == "userNotFound" ||
              state.errMessage == "connectionError") {
            final lang = AppLocalizations.of(context)!;
            String message = state.errMessage == "userNotFound"
                ? lang.userNotFound
                : lang.connectionError;
            showSnackBar(context, message, isError: true);
          }
        }
      },
      child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
        builder: (context, state) {
          return Stack(
            children: [
              AuthLayout(
                title: AppLocalizations.of(context)!.recoverPassword,
                subtitle: AppLocalizations.of(context)!.enterEmailSubtitle,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EmailField(
                        controller: _emailController,
                        onChanged: (_) => setState(() {}),
                        onFieldSubmitted: (_) => _submit(context),
                      ),
                      SizedBox(height: 20.h),
                      // الزرار باهت لو التايمر شغال
                      CustomButton(
                        title: AppLocalizations.of(context)!.sendCode,
                        onPressed: _cooldown > 0
                            ? null
                            : () => _submit(context),
                      ),
                      if (_cooldown > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.resendCodeText,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                " ${AppLocalizations.of(context)!.second(_cooldown)}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (state is ForgetPasswordLoading) const LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/text_styles.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/pages/reset_pass.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  static DateTime? lastTimeCodeSent;

  final TextEditingController _pinController = TextEditingController();

  Timer? _timer;
  int _start = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _checkTimer();
  }

  void _checkTimer() {
    if (lastTimeCodeSent == null) {
      lastTimeCodeSent = DateTime.now();
      _start = 59;
      startTimer();
    } else {
      final secondsPassed = DateTime.now()
          .difference(lastTimeCodeSent!)
          .inSeconds;

      if (secondsPassed < 59) {
        setState(() {
          _start = 59 - secondsPassed;
          _canResend = false;
        });
        startTimer();
      } else {
        setState(() {
          _start = 0;
          _canResend = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: AppTextStyles.headlineMedium(color: AppColors.kContentPrimary),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(
            context,
          ).inputDecorationTheme.enabledBorder!.borderSide.color,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12.r),
    );

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        log("STATE: $state");

        if (state is VerifyOtpSuccess) {
          final cubit = context.read<ForgetPasswordCubit>();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: ResetPasswordScreen(
                  email: widget.email,
                  otp: _pinController.text.trim(),
                ),
              ),
            ),
          );
        } else if (state is SendCodeSuccess) {
          showSnackBar(
            context,
            AppLocalizations.of(context)!.codeSent,
            isError: false,
          );
        } else if (state is ForgetPasswordFailure) {
          final lang = AppLocalizations.of(context)!;
          
          // ✅ تحديد رسالة واحدة فقط بناءً على نوع الخطأ
          String errorMessage;
          if (state.errMessage == 'invalidCode') {
            errorMessage = lang.invalidCode;
          } else if (state.errMessage == 'connectionError') {
            errorMessage = lang.connectionError;
          } else {
            errorMessage = lang.unexpectedError;
          }

          showSnackBar(context, errorMessage, isError: true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            AuthLayout(
              title: AppLocalizations.of(context)!.verificationCodeTitle,
              subtitle: AppLocalizations.of(
                context,
              )!.verificationCodeSubtitle(widget.email),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      autofocus: true,
                      onCompleted: (pin) {
                        log("Completed: $pin");
                        // ✅ طلب التحقق من الكيوبت فقط، الـ Navigator موجود في الـ Listener
                        context.read<ForgetPasswordCubit>().verifyOtp(
                          email: widget.email,
                          otp: pin,
                        );
                      },
                    ),
                  ),

                  // --- Timer / Resend ---
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_canResend) ...[
                          Text(
                            AppLocalizations.of(context)!.resendCodeText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            " ${AppLocalizations.of(context)!.second(_start)}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ] else
                          TextButton(
                            onPressed: state is ForgetPasswordLoading
                                ? null // تعطيل الزر أثناء التحميل
                                : () {
                                    setState(() {
                                      lastTimeCodeSent = DateTime.now();
                                      _start = 59;
                                      _canResend = false;
                                    });
                                    startTimer();
                                    context
                                        .read<ForgetPasswordCubit>()
                                        .sendCode(email: widget.email);
                                  },
                            child: Text(
                              AppLocalizations.of(context)!.resendCodeText,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Loading Overlay يظهر فوق الـ AuthLayout
            if (state is ForgetPasswordLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}

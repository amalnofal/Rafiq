import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/text_styles.dart';
import 'package:rafiq/features/auth/presentation/pages/reset_pass.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // متغير static عشان يحفظ الوقت حتى لو خرجنا من الصفحة
  static DateTime? _lastTimeCodeSent;

  final TextEditingController _pinController = TextEditingController();

  Timer? _timer;
  int _start = 57;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _checkTimer();
  }

  // دالة حساب الوقت عند فتح الصفحة
  void _checkTimer() {
    // لو أول مرة خالص يفتح التطبيق/الشاشة
    if (_lastTimeCodeSent == null) {
      _lastTimeCodeSent = DateTime.now();
      _start = 57;
      startTimer();
    } else {
      // لو كان فاتح قبل كده، نحسب الفرق
      final secondsPassed = DateTime.now()
          .difference(_lastTimeCodeSent!)
          .inSeconds;

      if (secondsPassed < 57) {
        // لسه فيه وقت متبقي
        setState(() {
          _start = 57 - secondsPassed;
          _canResend = false;
        });
        startTimer();
      } else {
        // الوقت انتهى وهو خارج الصفحة
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
    // تأكيد إلغاء أي تايمر سابق عشان ميعملش تداخل
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

    return AuthLayout(
      title: AppLocalizations.of(context)!.verificationCodeTitle,
      subtitle: AppLocalizations.of(
        context,
      )!.verificationCodeSubtitle(widget.email),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // --- 1. Pinput ---
          Pinput(
            length: 6,
            controller: _pinController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,

            autofocus: true,

            onCompleted: (pin) {
              log("Completed: $pin");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen(),
                ),
              );
            },
          ),

          // --- 2. Timer / Resend ---
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
                    AppLocalizations.of(context)!.second(_start),

                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else
                  TextButton(
                    onPressed: () {
                      // تحديث وقت آخر إرسال للوقت الحالي
                      setState(() {
                        _lastTimeCodeSent = DateTime.now();
                        _start = 57;
                        _canResend = false;
                      });

                      startTimer(); // بدء العد من جديد

                      // هنا كود الـ API لإرسال الرمز
                    },
                    child: Text(AppLocalizations.of(context)!.resendCodeText),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

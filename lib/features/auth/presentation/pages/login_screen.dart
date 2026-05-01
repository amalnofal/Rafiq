import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          showSnackBar(
            context,
            AppLocalizations.of(context)!.loginSuccess,
            isError: false,
          );

          await context.read<UserProvider>().loadUserData();

          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          }
        } else if (state is LoginFailure) {
          String getLocalizedMessage(String key) {
            final lang = AppLocalizations.of(context)!;
            switch (key) {
              case 'wrongCredentials':
                return lang.wrongCredentials;
              case 'userNotFound':
                return lang.userNotFound;
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
            getLocalizedMessage(state.errMessage),
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: isDarkMode
                  ? AppColors.kDarkMutedBackground
                  : AppColors.kSurfaceBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                    ),
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 85.h,
                              width: 85.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(2.r),
                              child: Image.asset(
                                "assets/icons/rafiq_logo.png",
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(height: 16.h),

                            Text(
                              AppLocalizations.of(context)!.rafiq,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              AppLocalizations.of(context)!.pet_care_assistant,
                              style: Theme.of(context).textTheme.labelLarge,
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 32.h),
                            EmailField(
                              controller: _emailController,
                              onChanged: (_) => setState(() {}),
                            ),

                            CustomTextField(
                              labelText: AppLocalizations.of(context)!.password,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: "assets/icons/security.svg",
                              isPassword: true,
                              controller: _passwordController,
                            ),
                            SizedBox(height: AppDimensions.paddingM),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/forget_pass');
                                },

                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingL),

                            // زر الدخول (ثابت هنا، مش بيتغير لـ loading)
                            CustomButton(
                              title: AppLocalizations.of(context)!.login,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  context.read<LoginCubit>().userLogin(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                }
                              },
                            ),

                            SizedBox(height: 32.h),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.no_account_question,
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.create_new_account,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("/register");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (state is LoginLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}

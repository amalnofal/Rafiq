import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/features/auth/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_header.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_steps/step1_name.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_steps/step2_contact.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_steps/step3_personal_info.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_steps/step4_password.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_steps/step5_account_type.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
              AuthHeader(
                title: AppLocalizations.of(context)!.create_new_account,
                subtitle: AppLocalizations.of(context)!.joinRafiq,
                onBackTap: () => _controller.prevPage(context),
                bottomWidget: _buildProgressIndicator(),
              ),
              Expanded(
                child: PageView(
                  controller: _controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: _controller.updatePage,
                  children: [
                    Step1Name(
                      fNameController: _controller.firstNameController,
                      lNameController: _controller.lastNameController,
                      onNext: _controller.nextPage,
                      onSocialLogin: (firstName, lastName, email) {
                        _controller.isSocialLogin = true;

                        // ملء البيانات في الكنترولرز
                        _controller.firstNameController.text = firstName;
                        _controller.lastNameController.text = lastName;
                        _controller.emailController.text = email;

                        _controller.pageController.jumpToPage(2);

                        _controller.updatePage(2);
                      },
                    ),
                    Step2Contact(
                      emailController: _controller.emailController,
                      phoneController: _controller.phoneController,
                      onNext: _controller.nextPage,
                    ),

                    Step3PersonalInfo(
                      dobController: _controller.dobController,
                      onGenderChanged: (val) => _controller.setGender(val),
                      onNext: _controller.nextPage,
                      selectedGender: _controller.gender,
                    ),

                    Step4Password(
                      passController: _controller.passController,
                      confirmController: _controller.confirmPassController,
                      onNext: _controller.nextPage,
                    ),

                    Step5AccountType(
                      onTypeSelected: (val) {
                        _controller.setAccountType(val);

                        _controller.registerUser(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        bool isActive = index <= _controller.currentPage;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            height: 4.h,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rafiq/features/auth/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_header.dart';
import 'package:rafiq/features/auth/presentation/widgets/register_step_indicator.dart';
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
                bottomWidget: _controller.currentPage == 4
                    ? const SizedBox()
                    : RegisterStepIndicator(
                        currentStep: _controller.currentPage,
                        totalSteps: 5,
                      ),
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
                      onSocialLogin: () {
                        _controller.isSocialLogin = true;

                        _controller.pageController.jumpToPage(4);
                        _controller.updatePage(4);
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
}

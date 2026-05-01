import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_header.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class InterestsScreen extends StatefulWidget {
  final RegisterController controller;

  const InterestsScreen({super.key, required this.controller});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<int> _selectedInterests = [];
  bool _showError = false;

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedInterests.contains(id)) {
        _selectedInterests.remove(id);
      } else {
        _selectedInterests.add(id);
      }
      if (_selectedInterests.isNotEmpty) {
        _showError = false;
      }
    });
  }

  void _submit() {
    if (_selectedInterests.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    DateTime dob;
    try {
      dob = DateFormat(
        'dd/MM/yyyy',
      ).parse(widget.controller.dobController.text);
    } catch (e) {
      dob = DateTime.now();
    }

    // 2️⃣ إرسال البيانات للكيوبت (Mapping IDs to Booleans)
    context.read<RegisterCubit>().submitRegister(
      // --- البيانات الشخصية ---
      firstName: widget.controller.firstNameController.text,
      lastName: widget.controller.lastNameController.text,
      email: widget.controller.emailController.text,
      password: widget.controller.passController.text,
      confirmPassword: widget.controller.confirmPassController.text,
      phone: widget.controller.phoneController.text,
      gender: widget.controller.gender ?? 1,
      role: widget.controller.accountType!,
      dateOfBirth: dob,

      // --- بيانات الدكتور (من الكنترولر) ---
      specialization: widget.controller.specController.text,
      subSpecialization: widget.controller.subSpecController.text,
      frontId: widget.controller.frontIdImage,
      backId: widget.controller.backIdImage,
      unionCard: widget.controller.unionCardImage,

      // --- الاهتمامات (Mapping with Enum) ---
      isHealthAndCare: _selectedInterests.contains(PostCategory.health.id),
      isNutritionAndFood: _selectedInterests.contains(PostCategory.food.id),
      isTrainingAndBehavior: _selectedInterests.contains(
        PostCategory.training.id,
      ),
      isGroomingAndAppearances: _selectedInterests.contains(
        PostCategory.grooming.id,
      ),
      isTravelAndTransport: _selectedInterests.contains(PostCategory.travel.id),
      isAdoptionAndRescue: _selectedInterests.contains(
        PostCategory.adoption.id,
      ),
      isStoriesAndExperiences: _selectedInterests.contains(
        PostCategory.stories.id,
      ),
      isUpbringingAndParenting: _selectedInterests.contains(
        PostCategory.activities.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showSnackBar(
            context,
            AppLocalizations.of(context)!.registrationSuccess,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => route.isFirst,
          );
        } else if (state is RegisterFailure) {
          String displayMessage;

          // نتحقق إذا كان الخطأ هو أحد المفاتيح التي حددناها في ARB
          if (state.errorMessage == "connectionError") {
            displayMessage = AppLocalizations.of(context)!.connectionError;
          } else if (state.errorMessage == "unexpectedError") {
            displayMessage = AppLocalizations.of(context)!.unexpectedError;
          } else if (state.errorMessage == "registrationFailed") {
            displayMessage = AppLocalizations.of(context)!.registrationFailed;
          } else {
            // إذا كانت الرسالة نصية قادمة من السيرفر مباشرة (مثل رسالة خطأ بالبريد)
            displayMessage = state.errorMessage;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    title: AppLocalizations.of(context)!.shareInterests,
                    subtitle: AppLocalizations.of(context)!.communityWaiting,
                    // زر الرجوع
                    onBackTap: () => Navigator.pop(context),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(
                              context,
                            )!.interestsSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const TextSpan(text: "  "),
                          TextSpan(
                            text: AppLocalizations.of(context)!.selectMultiple,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: PostCategory.values.length,
                      itemBuilder: (context, index) {
                        final category = PostCategory.values[index];
                        return _buildInterestCard(category);
                      },
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingL,
                      horizontal: AppDimensions.padding,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Column(
                      children: [
                        if (_showError)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Text(
                              AppLocalizations.of(context)!.selectInterestError,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        CustomButton(
                          title: AppLocalizations.of(context)!.startJourney,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (state is RegisterLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }

  Widget _buildInterestCard(PostCategory category) {
    bool isSelected = _selectedInterests.contains(category.id);

    Color borderColor;
    if (isSelected) {
      borderColor = Theme.of(context).colorScheme.primary;
    } else if (_showError) {
      borderColor = Colors.red;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }

    return InkWell(
      onTap: () => _toggleSelection(category.id),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: isSelected
                ? borderColor
                : Theme.of(context).colorScheme.outline,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: Text(category.icon, style: TextStyle(fontSize: 24.sp)),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              category.getLabel(context),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 15.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Text(
              category.getSubtitle(context),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

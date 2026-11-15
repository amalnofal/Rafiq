import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/cubit/register_cubit/register_cubit.dart';

import 'package:rafiq/features/auth/presentation/widgets/auth_header.dart';
import 'package:rafiq/features/auth/presentation/widgets/interest_card.dart';
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
      setState(() => _showError = true);
      return;
    }
    context.read<RegisterCubit>().submitRegister(
      widget.controller.toParams(_selectedInterests),
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
            (route) => false,
          );
        } else if (state is RegisterFailure) {
          String displayMessage;

          if (state.errorMessage == "connectionError") {
            displayMessage = AppLocalizations.of(context)!.connectionError;
          } else if (state.errorMessage == "unexpectedError") {
            displayMessage = AppLocalizations.of(context)!.unexpectedError;
          } else if (state.errorMessage == "registrationFailed") {
            displayMessage = AppLocalizations.of(context)!.registrationFailed;
          } else {
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
                        return InterestCard(
                          category: category,
                          isSelected: _selectedInterests.contains(category.id),
                          showError: _showError,
                          onTap: () => _toggleSelection(category.id),
                        );
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
}

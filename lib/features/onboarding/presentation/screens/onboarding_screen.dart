import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/onboarding/data/models/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;
  // final Color sageGreen = const Color(0xFF7A8D53);

  void _submitOnboarding() async {
    bool value = await CacheHelper.saveData(key: 'onBoardingSeen', value: true);

    if (!mounted) return;

    if (value) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = OnboardingModel.onboardingList(context);

    return Scaffold(
      backgroundColor: AppColors.kSurfaceBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          child: Column(
            children: [
              // 1. زر تخطي (Skip)
              Visibility(
                visible: !isLastPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: TextButton(
                    onPressed: () {
                      _submitOnboarding();
                    },
                    child: Text(
                      context.l10n.skip,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.kBrandPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. محتوى الشاشات (الصور والنصوص)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == list.length - 1;
                    });
                  },
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.asset(
                          list[index].image,
                          height: 480.h,
                          width: double.infinity,
                        ),

                        // العنوان
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            list[index].title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.sp,
                                  color: AppColors.kContentPrimary,
                                ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // الوصف
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Text(
                            list[index].description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(color: AppColors.kContentSecondary),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 3. النقط (Indicators) والزرار
              Padding(
                padding: EdgeInsets.only(
                  top: 12.h,
                  right: 12.h,
                  left: 12.h,
                  bottom: 28.h,
                ),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: list.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.kDarkBrandPrimaryLighter,
                        dotColor: const Color(0xFFE0E0E0),
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        expansionFactor: 4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // زر التالي / ابدأ
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                      ),
                      child: CustomButton(
                        title: isLastPage
                            ? context.l10n.getStarted
                            : context.l10n.next,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kBrandPrimary,
                        fontSize: 18.sp,
                        onPressed: () {
                          if (isLastPage) {
                            _submitOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/back_button.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/profile_posts_section.dart';
import 'package:rafiq/features/profile/presentation/widgets/user_specific_section.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool isMe;

  const ProfileScreen({super.key, required this.user, this.isMe = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isMe) {
        final userProvider = context.read<UserProvider>();
        if (userProvider.user == null) {
          userProvider.loadUserData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final currentUser = widget.isMe
            ? (userProvider.user ?? widget.user)
            : widget.user;

        final isLoading = widget.isMe ? userProvider.isLoading : false;

        String? coverPath;
        if (widget.isMe && userProvider.localCoverImage != null) {
          coverPath = userProvider.localCoverImage!.path;
        } else {
          coverPath = currentUser.coverUrl;
        }

        return RafiqScaffold(
          padding: EdgeInsets.zero,
          body: RefreshIndicator(
            onRefresh: () => userProvider.loadUserData(),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // الغلاف
                        Container(
                          height: 150.h,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: (coverPath != null && coverPath.isNotEmpty)
                              ? SmartImageDisplay(
                                  path: coverPath,
                                  height: 135.h,
                                  radius: 0,
                                  fit: BoxFit.cover,
                                  showLoader: false,
                                )
                              : null,
                        ),

                        // زر الكاميرا
                        if (widget.isMe)
                          PositionedDirectional(
                            top: 16.h,
                            end: 16.w,
                            child: CircleIconButton(
                              bgColor: Theme.of(context).cardColor,
                              "assets/icons/camera.svg",
                              size: 35.h,
                              onTap: () {
                                ImagePickerHelper.showOptionSheet(context, (
                                  file,
                                ) async {
                                  try {
                                    await userProvider.uploadCoverImage(file);
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        AppLocalizations.of(
                                          context,
                                        )!.imageUpdated,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        AppLocalizations.of(
                                          context,
                                        )!.unexpectedError,
                                        isError: true,
                                      );
                                    }
                                  }
                                });
                              },
                            ),
                          ),

                        // زر الرجوع
                        PositionedDirectional(
                          top: 16.h,
                          start: 16.w,
                          child: const BackButtonWidget(),
                        ),

                        // الكارت الأساسي (الاسم والصورة الشخصية)
                        Padding(
                          padding: EdgeInsets.only(top: 90.h),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.padding,
                            ),
                            child: ProfileHeaderCard(
                              user: currentUser,
                              isMe: widget.isMe,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ==========================================
                    //  الجزء الثاني: محتوى البروفايل (حيوانات وبوستات)
                    // ==========================================
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.padding,
                      ),
                      child: Builder(
                        builder: (context) {
                          if (isLoading && userProvider.user == null) {
                            return Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: const CircularProgressIndicator.adaptive(),
                            );
                          }

                          //  الحالة الطبيعية: عرض الداتا (سواء كانت من الكاش أو فريش)
                          return Column(
                            children: [
                              SizedBox(height: 8.h),
                              UserSpecificSection(
                                user: currentUser,
                                isMe: widget.isMe,
                              ),
                              ProfilePostsSection(
                                posts: [],
                                isMe: widget.isMe,
                                onSeeAllTap: () {},
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

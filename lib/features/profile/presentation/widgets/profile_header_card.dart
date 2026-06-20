import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/features/chat/presentation/screens/chat_details_screen.dart';

class ProfileHeaderCard extends StatefulWidget {
  final UserModel user;
  final bool isMe;

  const ProfileHeaderCard({super.key, required this.user, required this.isMe});

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
  bool _isLoadingFollow = false;

  @override
  Widget build(BuildContext context) {
    // 🚀 القراءة المباشرة من الـ Provider بدون الاعتماد على initState
    final userProvider = context.watch<UserProvider>();

    // تحديد المستخدم الحالي: إذا كان بروفايلي، نأخذ بياناتي من البروفايدر (بما فيها عدد البوستات)، وإلا نأخذ بيانات المستخدم الممرر
    final currentUser = widget.isMe && userProvider.user != null
        ? userProvider.user!
        : widget.user;

    // تحديد حالة المتابعة وعدد المتابعين بشكل حي ومباشر
    final isFollowing =
        userProvider.getFollowState(widget.user.id) ?? widget.user.isFollowing;
    final followersCount =
        userProvider.getFollowersCount(widget.user.id) ??
        widget.user.followersCount;

    return CustomContainer(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingXL,
        horizontal: AppDimensions.paddingL,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, _) {
                      ImageProvider image;

                      if (widget.isMe &&
                          userProvider.localProfileImage != null) {
                        image = FileImage(userProvider.localProfileImage!);
                      } else if (currentUser.photoUrl != null &&
                          currentUser.photoUrl!.isNotEmpty) {
                        image = CachedNetworkImageProvider(
                          currentUser.photoUrl!,
                          cacheKey: currentUser.photoUrl!.contains('?')
                              ? currentUser.photoUrl!.split('?').first
                              : currentUser.photoUrl!,
                        );
                      } else {
                        image = const AssetImage(
                          "assets/images/user_placeholder.jpg",
                        );
                      }

                      return Container(
                        padding: EdgeInsets.all(3.r),
                        width: 85.r,
                        height: 85.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            width: 2.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28.r,
                          backgroundColor: Colors.grey[100],
                          backgroundImage: image,
                        ),
                      );
                    },
                  ),

                  // Change Profile Image Button
                  if (widget.isMe)
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: CircleIconButton(
                        "assets/icons/camera.svg",
                        size: 25.h,
                        iconSize: 14.h,
                        bgColor: Theme.of(context).colorScheme.primary,
                        color: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          ImagePickerHelper.showOptionSheet(context, (
                            file,
                          ) async {
                            try {
                              await userProvider.uploadProfileImage(file);

                              if (!context.mounted) return;

                              showSnackBar(context, context.l10n.imageUpdated);
                            } catch (e) {
                              if (!mounted) return;

                              final String errorKey = e
                                  .toString()
                                  .replaceAll("Exception: ", "")
                                  .trim();

                              final local = context.l10n;

                              String message;

                              if (errorKey == "imageUpdateFailed") {
                                message = local.imageUpdateFailed;
                              } else if (errorKey == "sessionExpired") {
                                message = local.sessionExpired;
                              } else if (errorKey == "serverError") {
                                message = local.serverError;
                              } else if (errorKey == "connectionError") {
                                message = local.connectionError;
                              } else {
                                message = local.unexpectedError;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.error,
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ),
                ],
              ),

              SizedBox(width: AppDimensions.padding),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              currentUser.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),

                        SizedBox(width: 2.w),

                        // Gender Icon
                        if (currentUser.gender != null &&
                            currentUser.role != UserType.admin)
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Icon(
                              currentUser.gender == 1
                                  ? Icons.male
                                  : Icons.female,
                              size: 20.sp,
                              color: currentUser.gender == 1
                                  ? const Color(0xFF5A9BD5)
                                  : const Color(0xFFE06B9A),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Role
                    Text(
                      currentUser.role == UserType.admin
                          ? context.l10n.adminTitle
                          : currentUser.role == UserType.vet
                          ? context.l10n.vetTitle
                          : context.l10n.petOwnerTitle,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (currentUser.role == UserType.vet) ...[
                      const SizedBox(height: 4),

                      Text(
                        "${currentUser.specialization}"
                        "${currentUser.subSpecialization != null ? ' | ${currentUser.subSpecialization}' : ''}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],

                    SizedBox(height: 4.h),

                    // Joined Date
                    Text(
                      "${context.l10n.joined} "
                      "${DateHelper.formatYearMonth(currentUser.joinedAt ?? DateTime.now(), context)}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                context.l10n.postsCountLabel,
                currentUser.postsCount,
              ),
              _buildStatItem(
                context,
                context.l10n.followersLabel,
                widget.isMe ? currentUser.followersCount : followersCount,
              ),
              _buildStatItem(
                context,
                context.l10n.followingLabel,
                currentUser.followingCount,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          if (!widget.isMe) ...[
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: AppDimensions.buttonHeightS,
                    elevation: isFollowing ? 0 : 2,
                    icon: isFollowing
                        ? "assets/icons/public_profile.svg"
                        : "assets/icons/follow.svg",
                    iconSize: 18.h,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                    txtColor: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    color: isFollowing
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.8)
                        : null,
                    title: isFollowing
                        ? context.l10n.unfollowBtn
                        : context.l10n.followBtn,
                    onPressed: _isLoadingFollow
                        ? null
                        : () async {
                            setState(() {
                              _isLoadingFollow = true;
                            });

                            final success = await userProvider.toggleFollow(
                              widget.user.id,
                              isFollowing,
                              followersCount,
                            );

                            if (!context.mounted) return;

                            setState(() {
                              _isLoadingFollow = false;
                            });

                            if (!success) {
                              showSnackBar(
                                context,
                                context.l10n.unexpectedError,
                                isError: true,
                              );
                            }
                          },
                  ),
                ),

                // chat button
                if (currentUser.receiveChatFromOtherUsers)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CircleIconButton(
                      "assets/icons/chat.svg",
                      bgColor: Theme.of(context).colorScheme.primary,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 45.h,
                      iconSize: 19.h,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => getIt<ChatCubit>(),
                              child: ChatDetailsScreen(
                                otherUserId: widget.user.id.toString(),
                                otherUserName: widget.user.fullName,
                                otherUserPhotoUrl: widget.user.photoUrl,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
        ),
        SizedBox(height: 4.h),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

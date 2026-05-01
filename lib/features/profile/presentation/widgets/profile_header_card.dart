import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/profile/presentation/pages/appointments_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ProfileHeaderCard extends StatefulWidget {
  final UserModel user;
  final bool isMe;
  final bool initialIsFollowing;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.isMe,
    this.initialIsFollowing = false,
  });

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialIsFollowing;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomContainer(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
                      } else if (widget.user.photoUrl != null &&
                          widget.user.photoUrl!.isNotEmpty) {
                        image = CachedNetworkImageProvider(
                          widget.user.photoUrl!,
                          cacheKey: widget.user.photoUrl!.contains('?')
                              ? widget.user.photoUrl!.split('?').first
                              : widget.user.photoUrl!,
                        );
                      } else {
                        image = const AssetImage(
                          "assets/images/user_placeholder.jpg",
                        );
                      }

                      return Container(
                        padding: EdgeInsets.all(3.r),
                        width: 92.r,
                        height: 92.r,
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

                  // زر تغيير الصورة
                  if (widget.isMe)
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, _) => CircleIconButton(
                          size: 26.h,
                          iconSize: 15.h,
                          bgColor: Theme.of(context).colorScheme.primary,
                          "assets/icons/camera.svg",
                          color: Theme.of(context).colorScheme.onPrimary,
                          onTap: () {
                            ImagePickerHelper.showOptionSheet(context, (
                              file,
                            ) async {
                              try {
                                await userProvider.uploadProfileImage(file);

                                if (!context.mounted) return;
                                showSnackBar(
                                  context,
                                  AppLocalizations.of(context)!.imageUpdated,
                                );
                              } catch (e) {
                                if (mounted) {
                                  final String errorKey = e
                                      .toString()
                                      .replaceAll("Exception: ", "")
                                      .trim();
                                  final local = AppLocalizations.of(context)!;

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
                              }
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: AppDimensions.paddingL),

              // User Info (الاسم - النوع - الدور - تاريخ الانضمام)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Name
                        Text(
                          widget.user.fullName,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
                        ),
                        SizedBox(width: 4.w),

                        // Gender
                        if (widget.user.gender != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Icon(
                              widget.user.gender == 1
                                  ? Icons.male
                                  : Icons.female,
                              size: 20.sp,
                              color: widget.user.gender == 1
                                  ? const Color(0xFF5A9BD5)
                                  : const Color(0xFFE06B9A),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Role
                    Text(
                      widget.user.role == UserType.vet
                          ? "${widget.user.specialization}${widget.user.subSpecialization != null ? ' . ${widget.user.subSpecialization}' : ''}"
                          : AppLocalizations.of(context)!.petOwnerTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    SizedBox(height: 4.h),

                    // Joined Date
                    Text(
                      "${AppLocalizations.of(context)!.joined} ${DateHelper.formatYearMonth(widget.user.joinedAt ?? DateTime.now(), context)}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // followers - following - posts count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                AppLocalizations.of(context)!.postsCountLabel,
                widget.user.postsCount,
              ),
              _buildStatItem(
                context,
                AppLocalizations.of(context)!.followersLabel,
                widget.user.followersCount,
              ),
              _buildStatItem(
                context,
                AppLocalizations.of(context)!.followingLabel,
                widget.user.followingCount,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          if (widget.isMe) ...[
            SizedBox(height: 16.h),
            CustomButton(
              height: 45.h,
              elevation: 0,
              title: AppLocalizations.of(context)!.manageAppointmentsBtn,
              icon: "assets/icons/calendar.svg",
              iconSize: 18.h,
              color: isDark
                  ? const Color(0xFF1E3A8A).withValues(alpha: 0.5)
                  : const Color(0xFFDBEAFE),
              txtColor: isDark
                  ? const Color(0xFF93C5FD)
                  : const Color(0xFF1E40AF),
              iconColor: isDark
                  ? const Color(0xFF93C5FD)
                  : const Color(0xFF1E40AF),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentsScreen(),
                  ),
                );
              },
            ),
          ],
          if (!widget.isMe) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: AppDimensions.buttonHeightS,
                    elevation: 2,
                    icon: _isFollowing
                        ? "assets/icons/user_icon.svg"
                        : "assets/icons/follow.svg",
                    iconSize: 18.h,
                    iconColor: _isFollowing
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onPrimary,
                    txtColor: _isFollowing
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,

                    color: _isFollowing
                        ? Theme.of(context).cardTheme.color
                        : null,
                    title: _isFollowing
                        ? AppLocalizations.of(context)!.unfollowBtn
                        : AppLocalizations.of(context)!.followBtn,
                    onPressed: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                    },
                  ),
                ),
                // Phone Number
                if (widget.user.phone != null &&
                    widget.user.phone!.isNotEmpty &&
                    !widget.isMe)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        // اعرض الرقم او اتصل
                      },
                      child: CircleIconButton(
                        "assets/icons/phone.svg",
                        bgColor: Theme.of(context).colorScheme.primary,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 45.h,
                        iconSize: 19.h,
                      ),
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

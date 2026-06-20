import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/community_provider.dart';

import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/back_button.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/no_internet_widget.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/profile/presentation/pages/all_posts_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/profile_posts_section.dart';
import 'package:rafiq/features/profile/presentation/widgets/user_specific_section.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool isMe;

  const ProfileScreen({super.key, required this.user, this.isMe = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _fetchedOtherUser;
  bool _isLoadingOtherUser = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();

      if (widget.isMe) {
        userProvider.loadUserData().then((_) {
          if (mounted) {
            _refreshPostsDetails(userProvider);
          }
        });
      } else {
        _fetchOtherUserData();
      }
    });
  }

  Future<void> _fetchOtherUserData() async {
    setState(() {
      _isLoadingOtherUser = true;
      _hasError = false;
    });

    try {
      final communityProvider = context.read<CommunityProvider>();
      final fetched = await context.read<UserProvider>().fetchUserProfileById(
        widget.user.id,
      );

      if (fetched != null) {
        List<PostModel> updatedPosts = [];

        for (var post in fetched.posts ?? []) {
          final fullPost = await communityProvider.getPostDetails(post.id);
          if (fullPost != null) {
            updatedPosts.add(fullPost);
          } else {
            updatedPosts.add(post);
          }
        }

        final updatedUser = fetched.copyWith(posts: updatedPosts);

        if (mounted) {
          setState(() {
            _fetchedOtherUser = updatedUser;
            _isLoadingOtherUser = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingOtherUser = false;
            _hasError = true;
          });
        }
      }
    } catch (e) {
      log("❌ Error fetching user profile: $e");
      if (mounted) {
        setState(() {
          _isLoadingOtherUser = false;
          _hasError = true;
        });
      }
    }
  }

  void _refreshPostsDetails(UserProvider userProvider) {
    if (!mounted) return;
    if (userProvider.user?.posts == null) return;

    final communityProvider = context.read<CommunityProvider>();
    for (var post in userProvider.user!.posts!) {
      communityProvider.getPostDetails(post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, UserModel?>(
      selector: (context, provider) => provider.user,
      builder: (context, userData, _) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final currentUser = widget.isMe
            ? (userData ?? widget.user)
            : (_fetchedOtherUser ?? widget.user);

        final isLoading = widget.isMe
            ? userProvider.isLoading
            : _isLoadingOtherUser;

        String? coverPath;
        if (widget.isMe && userProvider.localCoverImage != null) {
          coverPath = userProvider.localCoverImage!.path;
        } else {
          coverPath = currentUser.coverUrl;
        }

        return RafiqScaffold(
          padding: EdgeInsets.zero,
          body: RefreshIndicator(
            onRefresh: () async {
              if (widget.isMe) {
                await userProvider.loadUserData();
              } else {
                await _fetchOtherUserData();
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
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
                                        context.l10n.imageUpdated,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        context.l10n.unexpectedError,
                                        isError: true,
                                      );
                                    }
                                  }
                                });
                              },
                            ),
                          ),

                        PositionedDirectional(
                          top: 16.h,
                          start: 16.w,
                          child: const BackButtonWidget(),
                        ),

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

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.padding,
                      ),
                      child: Builder(
                        builder: (context) {
                          if (_hasError && !widget.isMe) {
                            return Column(
                              children: [
                                SizedBox(height: 30.h),
                                NoInternetWidget(onRetry: _fetchOtherUserData),
                              ],
                            );
                          }

                          if (isLoading &&
                              _fetchedOtherUser == null &&
                              !widget.isMe) {
                            return Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: const CircularProgressIndicator.adaptive(),
                            );
                          }

                          final List<PostModel> userPosts =
                              currentUser.posts ?? [];

                          return Column(
                            children: [
                              UserSpecificSection(
                                user: currentUser,
                                isMe: widget.isMe,
                              ),
                              ProfilePostsSection(
                                key: ValueKey(currentUser.posts?.length ?? 0),
                                posts: userPosts,
                                isMe: widget.isMe,
                                onSeeAllTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AllPostsScreen(posts: userPosts),
                                    ),
                                  );
                                },
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

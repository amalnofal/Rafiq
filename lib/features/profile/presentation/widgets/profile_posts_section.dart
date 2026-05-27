import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/profile/presentation/pages/post_details_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/empty_state_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/post_preview_item.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ProfilePostsSection extends StatelessWidget {
  final VoidCallback onSeeAllTap;
  final List<PostModel> posts;
  final bool isMe;

  const ProfilePostsSection({
    super.key,
    required this.onSeeAllTap,
    required this.posts,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isMe
                    ? AppLocalizations.of(context)!.myPostsTitle
                    : AppLocalizations.of(context)!.userPostsTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              if (posts.isNotEmpty)
                GestureDetector(
                  onTap: onSeeAllTap,
                  child: Text(
                    AppLocalizations.of(context)!.seeAllBtn,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 12.h),

          posts.isEmpty
              ? EmptyStateCard(
                  message: AppLocalizations.of(context)!.noPostsYet,
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: posts.length > 6 ? 6 : posts.length,
                  itemBuilder: (context, index) {
                    final currentPost = posts[index];

                    return PostPreviewItem(
                      post: currentPost,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PostDetailsScreen(post: currentPost),
                          ),
                        );
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}

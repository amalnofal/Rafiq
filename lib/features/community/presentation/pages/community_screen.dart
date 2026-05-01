import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/manager/community_provider.dart';
import 'package:rafiq/features/community/presentation/pages/create_post_screen.dart';
import 'package:rafiq/features/community/presentation/widgets/create_post_trigger.dart';
import 'package:rafiq/features/community/presentation/widgets/post_item.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommunityProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 110.h;
    final double overlap = 15.h;

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      body: Stack(
        children: [
          Consumer<CommunityProvider>(
            builder: (context, provider, child) {
              return ListView(
                padding: EdgeInsets.only(
                  top: headerHeight - overlap,
                  bottom: 100.h,
                ),
                children: [
                  CreatePostTrigger(
                    onTap: () async {
                      final newPost = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );

                      if (newPost != null && newPost is PostModel) {
                        provider.addPost(newPost);
                      }
                    },
                  ),

                  SizedBox(height: 4.h),

                  if (provider.isLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Center(child: Text(provider.errorMessage!)),
                    )
                  else if (provider.posts.isEmpty)
                    Column(
                      children: [
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.noPostsYet} 🐾",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    )
                  else
                    ...provider.posts.map((post) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: PostItem(
                          post: post,
                          author: post.user,
                          timeAgo: DateHelper.timeAgoShort(
                            post.createdAt,
                            context,
                          ),
                          postText: post.text,
                          categories: post.categories,
                          likesCount: post.likesCount,
                          commentsCount: post.commentsCount,
                          postImageUrl: post.imageUrl,

                          onDelete: () {
                            provider.deletePost(post);
                          },

                          onEdit: () async {
                            final updatedPost = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreatePostScreen(postToEdit: post),
                              ),
                            );
                            if (updatedPost != null &&
                                updatedPost is PostModel) {
                              provider.updatePost(updatedPost);
                            }
                          },
                        ),
                      );
                    }),
                ],
              );
            },
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: headerHeight,
              child: MainHeader(
                title: AppLocalizations.of(context)!.community,
                icon: "assets/icons/community.svg",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

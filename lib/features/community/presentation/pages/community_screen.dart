import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/no_internet_widget.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/pages/community_search_screen.dart';
import 'package:rafiq/features/community/presentation/pages/create_post_screen.dart';
import 'package:rafiq/features/community/presentation/widgets/create_post_trigger.dart';
import 'package:rafiq/features/community/presentation/widgets/post_item.dart';
import 'package:rafiq/features/community/presentation/widgets/post_shimmer_item.dart';
import 'package:rafiq/core/controller/community_provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommunityProvider>(context, listen: false).fetchPosts();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<CommunityProvider>().loadMorePosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 120.h;
    final double overlap = 15.h;

    final provider = context.watch<CommunityProvider>();

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      body: Stack(
        children: [
          RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            edgeOffset: headerHeight,
            onRefresh: () async {
              await context.read<CommunityProvider>().fetchPosts();
            },
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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

                      if (context.mounted) {
                        context.read<UserProvider>().addPostLocally(newPost);

                        showSnackBar(context, context.l10n.postCreatedSuccess);
                      }
                    }
                  },
                ),

                SizedBox(height: 4.h),

                if (provider.isLoading && provider.posts.isEmpty)
                  ...List.generate(3, (index) => const PostShimmerItem())
                else if (provider.hasConnectionError && provider.posts.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: NoInternetWidget(
                      onRetry: () {
                        context.read<CommunityProvider>().fetchPosts();
                      },
                    ),
                  )
                else if (provider.errorMessage != null &&
                    provider.posts.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: Center(
                      child: Text(
                        context.l10n.unexpectedError,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else if (provider.posts.isEmpty && !provider.isLoading)
                  Column(
                    children: [
                      SizedBox(height: 50.h),
                      Center(
                        child: Text(
                          "${context.l10n.noPostsYet} 🐾",
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
                        key: ValueKey(post.id),
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
                        postMedia: post.media,
                      ),
                    );
                  }),
                if (provider.isFetchingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: headerHeight,
              child: MainHeader(
                title: context.l10n.community,
                icon: "assets/icons/search.svg",
                onIconTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunitySearchScreen(),
                    ),
                  );
                },
              ),
            ),
          ),

          if (provider.isActionLoading)
            const Positioned.fill(child: LoadingOverlay()),
        ],
      ),
    );
  }
}

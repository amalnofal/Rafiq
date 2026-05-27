import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/post_preview_item.dart';
import 'package:rafiq/features/profile/presentation/pages/post_details_screen.dart';

class AllPostsScreen extends StatelessWidget {
  final List<PostModel> posts;

  const AllPostsScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();

    List<PostModel> displayPosts = posts;
    if (posts.isNotEmpty &&
        userProv.user != null &&
        posts.first.userId == userProv.user!.id) {
      displayPosts = userProv.user!.posts ?? posts;
    }

    return RafiqScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.myPostsTitle),
            Text(
              context.l10n.postsWithCount(displayPosts.length),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 1,
        ),
        itemCount: displayPosts.length,
        itemBuilder: (context, index) {
          final currentPost = displayPosts[index];

          return PostPreviewItem(
            post: currentPost,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailsScreen(post: currentPost),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

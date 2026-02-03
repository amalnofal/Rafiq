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
    // ✅ 1. بنطلب من البروفايدر يجيب الداتا أول ما الصفحة تفتح
    // بنستخدم addPostFrameCallback عشان نتأكد إن الـ build خلص
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommunityProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 115.h;
    final double overlap = 15.h;

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      body: Stack(
        children: [
          // ✅ 2. هنا بنسمع للتغييرات في البروفايدر
          Consumer<CommunityProvider>(
            builder: (context, provider, child) {
              return ListView(
                padding: EdgeInsets.only(
                  top: headerHeight - overlap,
                  bottom: 100.h,
                ),
                children: [
                  // ✅ زرار إنشاء البوست مكانه ثابت فوق
                  CreatePostTrigger(
                    onTap: () async {
                      final newPost = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );

                      // لو راجع ببوست جديد، البروفايدر هو اللي يضيفه
                      if (newPost != null && newPost is PostModel) {
                        provider.addPost(newPost);
                      }
                    },
                  ),

                  SizedBox(height: 4.h),

                  // ✅ 3. التعامل مع الحالات المختلفة (تحميل - خطأ - بيانات)
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
                            "${AppLocalizations.of(context)!.emptyCommunityText} 🐾",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    )
                  else
                    // ✅ 4. عرض البوستات من البروفايدر
                    ...provider.posts.map((post) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: PostItem(
                          post: post,
                          author: post.user,
                          timeAgo: DateHelper.timeAgo(post.createdAt, context),
                          postText: post.text,
                          categories: post.categories,
                          likesCount: post.likesCount,
                          commentsCount: post.commentsCount,
                          postImageUrl: post.imageUrl,

                          // ✅ الحذف عن طريق البروفايدر
                          onDelete: () {
                            provider.deletePost(post);
                          },

                          // ✅ التعديل (لسه زي ما هو UI Logic + Provider update)
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

          // الهيدر الثابت مكانه فوق
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

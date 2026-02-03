import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/auth/data/models/user_model.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/widgets/post_interaction_bar.dart';
import 'package:rafiq/features/community/presentation/widgets/selection_chip.dart';
import 'package:rafiq/features/community/presentation/widgets/post_user_header.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostItem extends StatelessWidget {
  final UserModel author;
  final PostModel post;
  final String timeAgo;
  final String postText;
  final String? postImageUrl;
  final List<PostCategory> categories;
  final int likesCount;
  final int commentsCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostItem({
    super.key,
    required this.post,
    required this.author,
    required this.timeAgo,
    required this.postText,
    this.postImageUrl,
    required this.categories,
    required this.likesCount,
    required this.commentsCount,
    this.onEdit,
    this.onDelete,
  });

  void _showPostOptions(BuildContext context, Offset globalPosition) {
    MenuUtils.showContextMenu(
      context,
      globalPosition,

      onEdit: () {
        if (onEdit != null) onEdit!();
      },

      onDelete: () {
        showDialog(
          context: context,
          builder: (context) {
            return CustomInfoDialog(
              title: AppLocalizations.of(context)!.deletePostTitle,
              description: AppLocalizations.of(context)!.deleteDialogMessage,
              confirmBtnText: AppLocalizations.of(context)!.deleteAction,

              mainColor: Colors.red,

              onConfirm: () {
                if (onDelete != null) onDelete!();

                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من ملكية البوست
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isMyPost = currentUser != null && post.userId == currentUser.id;
    String finalSubtitle = timeAgo;

    if (post.isEdited) {
      finalSubtitle += " • ${AppLocalizations.of(context)!.edited}";
    }
    return Container(
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostUserHeader(
            user: post.user,
            subtitle: finalSubtitle,
            onMoreTap: isMyPost
                ? (offset) => _showPostOptions(context, offset)
                : null,
          ),

          SizedBox(height: 12.h),
          Text(
            postText,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),

          if (categories.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: categories.map((cat) {
                return SelectionChip(
                  label: cat.getLabel(context),
                  icon: cat.icon,
                  isSmall: true,
                  isSelected: true,
                );
              }).toList(),
            ),
            SizedBox(height: 12.h),
          ],

          if (postImageUrl != null && postImageUrl!.isNotEmpty) ...[
            SmartImageDisplay(path: postImageUrl!),
            SizedBox(height: 12.h),
          ],

          PostInteractionBar(
            initialLikes: likesCount,
            initialComments: commentsCount,
          ),
        ],
      ),
    );
  }
}

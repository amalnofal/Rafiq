import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart';

class PostUserHeader extends StatelessWidget {
  final UserModel user;
  final String? subtitle;
  final Function(Offset)? onMoreTap;

  const PostUserHeader({
    super.key,
    required this.user,
    this.subtitle,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    //  1. هنجيب بيانات اليوزر الحالي من البروفايدر
    final userProvider = context.read<UserProvider>();
    final isMe = user.id.isNotEmpty && user.id == userProvider.user?.id;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user, isMe: isMe),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: [
                // الصورة الشخصية
                _buildAvatar(isMe, userProvider),

                SizedBox(width: 12.w),

                // الاسم والوصف (أو الوقت)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle ??
                            (user.role == UserType.vet
                                ? AppLocalizations.of(context)!.vetTitle
                                : AppLocalizations.of(context)!.petOwnerTitle),
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (onMoreTap != null)
          GestureDetector(
            onTapDown: (details) {
              onMoreTap!(details.globalPosition);
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(right: 8.w, left: 8.w, bottom: 8.w),
              child: Icon(Icons.more_vert, size: 20.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar(bool isMe, UserProvider userProvider) {
    if (isMe && userProvider.localProfileImage != null) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: FileImage(userProvider.localProfileImage!),
      );
    } else if (user.photoUrl != null &&
        user.photoUrl!.isNotEmpty &&
        user.photoUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: user.photoUrl!,
        useOldImageOnUrlChange: true,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) =>
            CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[200]),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: const AssetImage(
            "assets/images/user_placeholder.jpg",
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: const AssetImage("assets/images/user_placeholder.jpg"),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/features/auth/data/models/user_model.dart';

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
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null
              ? Icon(Icons.person, color: Colors.grey, size: 24.sp)
              : null,
        ),
        SizedBox(width: 12.w),

        // الاسم والوصف (أو الوقت)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.fullName, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              subtitle ?? user.userType,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),

        const Spacer(),

        if (onMoreTap != null)
          GestureDetector(
            onTapDown: (details) {
              onMoreTap!(details.globalPosition);
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.more_vert, color: Colors.grey, size: 24.sp),
            ),
          ),
      ],
    );
  }
}

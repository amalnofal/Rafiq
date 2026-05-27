import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        return GestureDetector(
          onTap: () {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user, isMe: true),
                ),
              );
            }
          },
          child: Row(
            children: [
              // ايقون البروفايل
              Container(
                padding: EdgeInsets.all(2.r),
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
                  radius: 22.r,
                  backgroundImage: userProvider.localProfileImage != null
                      ? FileImage(userProvider.localProfileImage!)
                      : (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                          user.photoUrl!,
                          cacheKey: user.photoUrl!.contains('?')
                              ? user.photoUrl!.split('?').first
                              : user.photoUrl!,
                        )
                      : const AssetImage("assets/images/user_placeholder.jpg")
                            as ImageProvider,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),

              // الترحيب والاسم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.welcome,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    user?.firstName ?? "Unknown",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

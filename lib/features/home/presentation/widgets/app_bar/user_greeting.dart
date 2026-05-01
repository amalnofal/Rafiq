import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart'; // 1. تأكدي من الـ Import ده
import 'package:rafiq/l10n/app_localizations.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        // تجهيز الاسم والصورة
        final String displayName = user != null
            ? "${user.firstName} ${user.lastName}"
            : "Rafiq User";

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
              CircleAvatar(
                radius: 20.r,
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
              SizedBox(width: AppDimensions.paddingM),

              // الترحيب والاسم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.welcome}،',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.bodyLarge,
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

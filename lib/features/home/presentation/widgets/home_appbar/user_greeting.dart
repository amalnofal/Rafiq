import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        // 1. تجهيز الاسم والصورة بشكل آمن
        final String displayName = user != null
            ? "${user.firstName} ${user.lastName}"
            : "زائر";

        final String? photoUrl = user?.photoUrl;

        return Row(
          children: [
            // صورة المستخدم
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                  ? NetworkImage(photoUrl)
                  : null,
              child: (photoUrl == null || photoUrl.isEmpty)
                  ? SvgPicture.asset(
                      'assets/icons/user_icon.svg',
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.kSurfaceCard,
                        BlendMode.srcIn,
                      ),
                    )
                  : null,
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
                  displayName, // ✅ الاسم المعدل (أول + أخير)
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

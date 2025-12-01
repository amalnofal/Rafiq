import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/l10n/app_localizations.dart';

// ============================================================================
// USER GREETING - ترحيب المستخدم في الـ Home
// ============================================================================

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key, required this.userName, this.avatarUrl});

  final String userName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        return Row(
          children: [
            // صورة المستخدم
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? SvgPicture.asset(
                      'assets/icons/user_icon.svg',
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
                // "مرحباً،"
                Text(
                  '${AppLocalizations.of(context)!.welcome}،',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // اسم المستخدم
                Text(user.name, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        );
      },
    );
  }
}

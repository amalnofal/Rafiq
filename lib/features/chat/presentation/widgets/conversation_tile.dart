import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool isTyping;
  final String? photoUrl;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    this.isTyping = false,
    this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CustomContainer(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            GestureDetector(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.r),
                    width: 52.r,
                    height: 52.r,
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
                      radius: 25.r,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                          ? CachedNetworkImageProvider(
                              photoUrl!,
                              cacheKey: photoUrl!.contains('?')
                                  ? photoUrl!.split('?').first
                                  : photoUrl!,
                            )
                          : const AssetImage(
                                  "assets/images/user_placeholder.jpg",
                                )
                                as ImageProvider,
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C950),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.w),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // تفاصيل الرسالة والاسم
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(time, style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // إظهار "يكتب الآن..." أو الرسالة الأخيرة
                  Text(
                    isTyping ? context.l10n.isTyping : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

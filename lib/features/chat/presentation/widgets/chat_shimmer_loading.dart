import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).cardColor;
    final highlightColor = Theme.of(context).scaffoldBackgroundColor;

    return ListView.builder(
      reverse: true,
      itemCount: 8,
      padding: EdgeInsets.all(AppDimensions.padding),
      itemBuilder: (context, index) {
        bool isMe = index % 2 != 0;

        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusL),
                    topRight: Radius.circular(AppDimensions.radiusL),
                    bottomLeft: Radius.circular(
                      isMe ? AppDimensions.radiusL : 0,
                    ),
                    bottomRight: Radius.circular(
                      isMe ? 0 : AppDimensions.radiusL,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isMe ? 120.w : 180.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    // سطر ثانٍ وهمي للرسائل الطويلة الطرف الآخر
                    if (!isMe) ...[
                      SizedBox(height: 8.h),
                      Container(
                        width: 100.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

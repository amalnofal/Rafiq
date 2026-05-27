import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rafiq/core/widgets/custom_container.dart';

class ConversationShimmer extends StatelessWidget {
  const ConversationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).cardColor;
    final highlightColor = Theme.of(context).scaffoldBackgroundColor;
    
    final innerColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8, 
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: CustomContainer(
            child: Row(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: innerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: innerColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: innerColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        margin: EdgeInsets.only(right: 40.w), 
                        decoration: BoxDecoration(
                          color: innerColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
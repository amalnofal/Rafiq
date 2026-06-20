import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';

class OrderItemRow extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double unitPrice;
  final int quantity;

  const OrderItemRow({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. صورة المنتج
          SmartImageDisplay(
            path: imageUrl,
            width: 48.r,
            height: 48.r,
            radius: 12,
            iconSize: 24,
          ),

          SizedBox(width: 12.w),

          // 2. اسم المنتج
          Expanded(
            child: Text(
              productName,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: 12.w),

          // 3. السعر والكمية
          Text(
            "$quantity × $unitPrice ${context.l10n.currencyEGP}",
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/store/data/cart_model.dart';
import 'package:rafiq/features/store/presentation/pages/product_details_screen.dart';
import 'package:rafiq/features/store/presentation/widgets/quantity_counter.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<int> onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  void _goToDetails(BuildContext context) async {
    // 1. عرض مؤشر تحميل (Loading) عشان اليوزر يعرف إننا بنجيب الداتا
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 2. جلب الداتا الحقيقية للمنتج من السيرفر
    final provider = context.read<StoreProvider>();
    final realProduct = await provider.getProductById(item.productId);

    // 3. إخفاء مؤشر التحميل
    if (context.mounted) {
      Navigator.pop(context);
    }

    // 4. التأكد إن الداتا رجعت، وبعدين نفتح الشاشة
    if (context.mounted) {
      if (realProduct != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: realProduct),
          ),
        );
      } else {
        showSnackBar(context, context.l10n.unexpectedError, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      margin: EdgeInsets.all(0),
      child: Row(
        children: [
          // صورة المنتج (قابلة للضغط)
          GestureDetector(
            onTap: () => _goToDetails(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SmartImageDisplay(
                path: item.imageUrl,
                height: 80.h,
                width: 80.w,
              ),
            ),
          ),

          SizedBox(width: 16.w),
          // تفاصيل المنتج والأزرار
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المنتج (قابل للضغط)
                GestureDetector(
                  onTap: () => _goToDetails(context),
                  child: Text(
                    item.productName,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // سعر الوحدة
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${item.unitPrice} ",
                                style: theme.textTheme.titleLarge?.copyWith(),
                              ),
                              TextSpan(
                                text: context.l10n.currencyEGP,
                                style: theme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // متحكم الكمية
                        SizedBox(
                          height: 32.h,
                          width: 90.w,
                          child: QuantityCounter(
                            quantity: item.quantity,
                            onIncrement: () =>
                                onUpdateQuantity(item.quantity + 1),
                            onDecrement: () {
                              if (item.quantity > 1) {
                                onUpdateQuantity(item.quantity - 1);
                              } else {
                                onRemove();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // زر الحذف
                    CircleIconButton(
                      "assets/icons/trash.svg",
                      onTap: onRemove,
                      color: theme.colorScheme.error,
                      bgColor: theme.colorScheme.error.withValues(alpha: 0.1),
                      size: 32.h,
                      iconSize: 16.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

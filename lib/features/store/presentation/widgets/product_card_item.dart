import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/store/data/product_model.dart';

class ProductCardItem extends StatelessWidget {
  final ProductModel product;
  final bool isAdmin;
  final VoidCallback onCartTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback onTap;

  const ProductCardItem({
    super.key,
    required this.product,
    required this.isAdmin,
    required this.onCartTap,
    required this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // 💡 1. التحقق من حالة المخزون
    final bool isOutOfStock = product.stockQuantity <= 0;

    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💡 2. صورة المنتج مع تأثير نفاذ الكمية
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SmartImageDisplay(
                        path: product.imageUrl,
                        width: double.infinity,
                        customBorderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),

                      // نفذت الكمية
                      if (isOutOfStock)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              context.l10n.outOfStock,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: Color(0XFF2D3319),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // تفاصيل المنتج
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${product.price} ${context.l10n.currencyEGP}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),

                            // أيقونة السلة
                            CircleIconButton(
                              "assets/icons/cart.svg",
                              size: 28.r,
                              iconSize: 16.r,
                              onTap: isOutOfStock
                                  ? () {}
                                  : () async {
                                      final provider = context
                                          .read<StoreProvider>();

                                      final success = await provider.addToCart(
                                        product.id,
                                        1,
                                      );

                                      if (!context.mounted) return;

                                      if (success) {
                                        showSnackBar(
                                          context,
                                          context.l10n.productAddedToCart,
                                        );
                                      } else {
                                        showSnackBar(
                                          context,
                                          context.l10n.unexpectedError,
                                          isError: true,
                                        );
                                      }
                                    },
                              bgColor: isOutOfStock
                                  ? null
                                  : Theme.of(context).colorScheme.primary,
                              color: isOutOfStock ? null : Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // تعديل وحذف المنتج للادمن
            if (isAdmin)
              PositionedDirectional(
                top: 8.h,
                end: 8.w,
                child: Container(
                  height: 28.h,
                  width: 28.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      MenuUtils.showContextMenu(
                        context,
                        details.globalPosition,
                        onEdit: () => onEdit?.call(),
                        onDelete: () => onDelete?.call(),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.more_vert,
                        size: 16.r,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

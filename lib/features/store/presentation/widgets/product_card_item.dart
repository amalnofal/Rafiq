import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
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
                // صورة المنتج
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      cacheKey: product.imageUrl.split('?').first,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
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
                              "${product.price.toInt()} ${context.l10n.currencyEGP}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),

                            CircleIconButton(
                              "assets/icons/cart.svg",
                              size: 28.r,
                              iconSize: 16.r,
                              onTap: onCartTap,
                              bgColor: Theme.of(context).colorScheme.primary,
                              color: Colors.white,
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

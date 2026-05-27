import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/expandable_text.dart';
import 'package:rafiq/features/store/data/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    // نتأكد إنه ميزيدش عن الكمية المتاحة في المخزن
    if (_quantity < widget.product.stockQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    // نتأكد إنه ميقلش عن 1
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStock = widget.product.stockQuantity > 0;
    final isArabicDesc = RegExp(
      r'[\u0600-\u06FF]',
    ).hasMatch(widget.product.description);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.productDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // الجزء السفلي الثابت (زرار الإضافة والعداد)
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 3,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // زرار إضافة للسلة
              Expanded(
                flex: 2,
                child: CustomButton(
                  title: context.l10n.addToCart,
                  fontWeight: FontWeight.w500,
                  icon: "assets/icons/cart.svg",
                  iconColor: Colors.white,
                  iconSize: 20.r,
                  height: 50.h,
                  onPressed: hasStock
                      ? () {
                          // دالة الإضافة للسلة هنا
                          debugPrint(
                            "Adding $_quantity of ${widget.product.name} to cart",
                          );
                        }
                      : null,
                ),
              ),
              SizedBox(width: 16.w),

              // عداد الكمية
              Expanded(
                flex: 1,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _decrementQuantity,
                        child: Icon(
                          Icons.remove,
                          size: 20.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '$_quantity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: _incrementQuantity,
                        child: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // محتوى الصفحة (بيعمل سكرول)
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Hero(
              tag: 'product_image_${widget.product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl,
                  cacheKey: widget.product.imageUrl.split('?').first,
                  width: double.infinity,
                  height: 300.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(height: 300.h, color: Colors.grey[100]),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // حالة المخزن (متاح/غير متاح)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: hasStock
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasStock ? Icons.check_circle_outline : Icons.error_outline,
                    color: hasStock ? const Color(0xFF00A63E) : Colors.red,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      hasStock
                          ? context.l10n.inStock(widget.product.stockQuantity)
                          : context.l10n.outOfStock,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: hasStock ? const Color(0xFF00A63E) : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // اسم المنتج
            Text(
              widget.product.name,
              textAlign: isArabicDesc ? TextAlign.right : TextAlign.left,
              textDirection: isArabicDesc
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),

            // السعر
            Row(
              children: [
                Text(
                  "${widget.product.price % 1 == 0 ? widget.product.price.toInt() : widget.product.price}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  " ${context.l10n.currencyEGP}",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Divider(),
            SizedBox(height: 16.h),

            // عنوان الوصف
            Text(context.l10n.description, style: theme.textTheme.bodyMedium),
            SizedBox(height: 10.h),

            ExpandableText(
              widget.product.description,
              style: theme.textTheme.labelMedium,
              isArabic: isArabicDesc,
            ),
          ],
        ),
      ),
    );
  }
}

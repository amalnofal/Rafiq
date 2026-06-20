import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/expandable_text.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/store/data/product_model.dart';
import 'package:rafiq/features/store/presentation/widgets/quantity_counter.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  late ProductModel _currentProduct;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    _fetchFreshProductData();
  }

  Future<void> _fetchFreshProductData() async {
    setState(() => _isRefreshing = true);

    final provider = context.read<StoreProvider>();
    final freshProduct = await provider.getProductById(_currentProduct.id);

    if (mounted && freshProduct != null) {
      setState(() {
        _currentProduct = freshProduct;

        // لو المخزون الجديد أقل من الكمية اللي اليوزر مختارها، نقلل الكمية
        if (_currentProduct.stockQuantity <= 0) {
          _quantity = 1;
        } else if (_quantity > _currentProduct.stockQuantity) {
          _quantity = _currentProduct.stockQuantity;
        }
      });
    }

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _incrementQuantity() {
    if (_quantity < _currentProduct.stockQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStock = _currentProduct.stockQuantity > 0;
    final isArabicDesc = RegExp(
      r'[\u0600-\u06FF]',
    ).hasMatch(_currentProduct.description);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.productDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

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
                      ? () async {
                          final provider = context.read<StoreProvider>();
                          final success = await provider.addToCart(
                            _currentProduct.id,
                            _quantity,
                          );

                          if (context.mounted) {
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
                          }
                        }
                      : null,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 1,
                child: QuantityCounter(
                  quantity: _quantity,
                  onIncrement: _incrementQuantity,
                  onDecrement: _decrementQuantity,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_image_${_currentProduct.id}',
              child: SmartImageDisplay(
                path: _currentProduct.imageUrl,
                height: 300.h,
                width: double.infinity,
                customBorderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 20.h),

            // حالة المخزن
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
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
                        hasStock
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        color: hasStock ? const Color(0xFF00A63E) : Colors.red,
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          hasStock
                              ? context.l10n.inStock(
                                  _currentProduct.stockQuantity,
                                )
                              : context.l10n.outOfStock,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: hasStock
                                ? const Color(0xFF00A63E)
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_isRefreshing) ...[
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 14.r,
                    height: 14.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16.h),

            Text(
              _currentProduct.name,
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

            Row(
              children: [
                Text(
                  "${_currentProduct.price % 1 == 0 ? _currentProduct.price.toInt() : _currentProduct.price}",
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

            Text(context.l10n.description, style: theme.textTheme.bodyMedium),
            SizedBox(height: 10.h),

            ExpandableText(
              _currentProduct.description,
              style: theme.textTheme.labelMedium,
              isArabic: isArabicDesc,
            ),
          ],
        ),
      ),
    );
  }
}

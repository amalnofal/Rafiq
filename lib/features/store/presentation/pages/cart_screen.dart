import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/store/data/cart_model.dart';
import 'package:rafiq/features/store/presentation/pages/delivery_info_screen.dart';
import 'package:rafiq/features/store/presentation/widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().fetchCart();
    });
  }

  // ==========================================
  // 🗑️ تفريغ السلة بالكامل
  // ==========================================
  void _onClearCart() {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomInfoDialog(
        title: context.l10n.emptyCart,
        description: context.l10n.confirmEmptyCartMessage,
        confirmBtnText: context.l10n.emptyCart,
        mainColor: Colors.red,
        onConfirm: () async {
          Navigator.pop(dialogContext);
          final success = await context.read<StoreProvider>().clearCart();
          if (mounted && success) {
            showSnackBar(context, context.l10n.cartClearedSuccessfully);
          }
        },
      ),
    );
  }

  // ==========================================
  // ➖➕ تحديث الكمية (مع التحقق من المخزون)
  // ==========================================
  Future<void> _updateQuantity(String cartItemId, int newQty) async {
    if (newQty < 1) return;

    final success = await context.read<StoreProvider>().updateCartQuantity(cartItemId, newQty);

    if (mounted && !success) {
      showSnackBar(
        context,
        context.l10n.requestedQuantityNotAvailable,
        isError: true,
      );
    }
  }
  // ==========================================
  // ❌ حذف منتج واحد
  // ==========================================
  Future<void> _removeItem(String cartItemId) async {
    final success = await context.read<StoreProvider>().removeFromCart(
      cartItemId,
    );
    if (mounted && success) {
      showSnackBar(context, context.l10n.productRemovedFromCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final cart = storeProvider.cart;
    final isLoading = storeProvider.isCartLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.shoppingCart),
        actions: [
          if (cart != null && cart.items.isNotEmpty)
            TextButton(
              onPressed: _onClearCart,
              child: Text(
                context.l10n.emptyCart,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: isLoading && cart == null
          ? const Center(child: CircularProgressIndicator())
          : (cart == null || cart.items.isEmpty)
          ? _buildEmptyCart()
          : Column(
              children: [
                // قائمة المنتجات
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return CartItemCard(
                        item: cart.items[index],
                        onUpdateQuantity: (newQty) =>
                            _updateQuantity(cart.items[index].id, newQty),
                        onRemove: () => _removeItem(cart.items[index].id),
                      );
                    },
                  ),
                ),
                // ملخص الدفع بالأسفل
                _buildCheckoutSummary(cart),
              ],
            ),
    );
  }

  // ==========================================
  // 💳 ملخص الدفع أسفل الشاشة
  // ==========================================
  Widget _buildCheckoutSummary(CartModel cart) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الإجمالي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.totalAmountLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "${cart.totalAmount} ${context.l10n.currencyEGP}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // زر إتمام الطلب
            CustomButton(
              title: context.l10n.completeOrderBtn,
              fontWeight: FontWeight.w500,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeliveryInfoScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 📭 واجهة السلة الفارغة
  // ==========================================
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/cart.svg",
            width: 90.w,
            height: 90.h,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onTertiary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.cartIsEmpty,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.addProductsToCart,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

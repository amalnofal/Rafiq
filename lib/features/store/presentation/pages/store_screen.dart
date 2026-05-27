import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/store/data/product_model.dart';
import 'package:rafiq/features/store/presentation/pages/product_details_screen.dart';
import 'package:rafiq/features/store/presentation/widgets/add_product_dialog.dart';
import 'package:rafiq/features/store/presentation/widgets/product_card_item.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> _products = [];
  bool _isLoading = true;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _loadMoreProducts();
    }
  }

  Future<void> _fetchInitialProducts() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    final provider = context.read<StoreProvider>();
    final data = await provider.getProducts(page: _currentPage);

    if (mounted) {
      setState(() {
        _products = data;
        _isLoading = false;
        if (data.length < 20) {
          _hasMoreData = false;
        }
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    // 👈 لو بنحمل حالياً، أو لو مفيش داتا تانية، نوقف الفانكشن فوراً
    if (_isFetchingMore || !_hasMoreData) return;

    setState(() => _isFetchingMore = true);
    _currentPage++;

    final newData = await context.read<StoreProvider>().getProducts(
      page: _currentPage,
    );

    if (mounted) {
      setState(() {
        if (newData.isEmpty) {
          // 👈 لو السيرفر رجع لستة فاضية، نقفل الحنفية
          _hasMoreData = false;
        } else {
          _products.addAll(newData);
          // 👈 لو رجع داتا أقل من 20، معناها دي آخر صفحة
          if (newData.length < 20) {
            _hasMoreData = false;
          }
        }
        _isFetchingMore = false;
      });
    }
  }

  void _onDeleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomInfoDialog(
        title: "${context.l10n.deleteAction} ${product.name}?",
        description: context.l10n.deleteDialogMessage,
        confirmBtnText: context.l10n.deleteAction,
        mainColor: Colors.red,
        onConfirm: () async {
          // 1. نقفل الديالوج بتاع التأكيد الأول
          Navigator.pop(dialogContext);

          // 2. نشغل مؤشر التحميل في الشاشة
          setState(() => _isLoading = true);

          // 3. نكلم البروفايدر عشان يحذف من السيرفر
          final provider = context.read<StoreProvider>();
          bool success = await provider.deleteProduct(product.id);

          // 4. نتأكد إن الشاشة لسه موجودة
          if (!mounted) return;

          if (success) {
            // لو نجح، نمسح المنتج من اللستة ونقفل التحميل
            setState(() {
              _products.removeWhere((p) => p.id == product.id);
              _isLoading = false;
            });
            showSnackBar(context, context.l10n.productDeletedSuccessfully);
          } else {
            // لو فشل، نقفل التحميل ونظهر إيرور
            setState(() => _isLoading = false);
            showSnackBar(context, context.l10n.unexpectedError, isError: true);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user?.role == UserType.admin;

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      // زر الإضافة للادمن فقط
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                // بنستنى النتيجة من الديالوج
                final result = await showDialog(
                  context: context,
                  builder: (context) => const AddProductDialog(),
                );
                // لو الديالوج رجع true (يعني الإضافة نجحت)، نعمل ريفريش
                if (result == true) {
                  setState(() => _isLoading = true);
                  _fetchInitialProducts();
                }
              },
              backgroundColor: const Color(0xFF7A8D56),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          MainHeader(
            title: AppLocalizations.of(context)!.store,
            icon: "assets/icons/cart.svg",
            searchHintText: context.l10n.searchProductHint,
            height: 195.h,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) => ProductCardItem(
                      product: _products[index],
                      isAdmin: isAdmin,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: _products[index]),
                          ),
                        );
                      },
                      onCartTap: () => debugPrint("إضافة للسلة"),

                      onDelete: () => _onDeleteProduct(_products[index]),
                      onEdit: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              AddProductDialog(product: _products[index]),
                        );
                        if (result == true) {
                          setState(() => _isLoading = true);
                          _fetchInitialProducts();
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

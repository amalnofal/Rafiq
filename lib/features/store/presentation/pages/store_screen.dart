import 'dart:async';
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
import 'package:rafiq/features/store/presentation/pages/cart_screen.dart';
import 'package:rafiq/features/store/presentation/pages/orders_screen.dart';
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

  String _searchQuery = '';
  Timer? _debounce;

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

    final data = _searchQuery.isEmpty
        ? await provider.getProducts(page: _currentPage)
        : await provider.searchProducts(_searchQuery, page: _currentPage);

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
    if (_isFetchingMore || !_hasMoreData) return;

    setState(() => _isFetchingMore = true);
    _currentPage++;

    final provider = context.read<StoreProvider>();

    final newData = _searchQuery.isEmpty
        ? await provider.getProducts(page: _currentPage)
        : await provider.searchProducts(_searchQuery, page: _currentPage);

    if (mounted) {
      setState(() {
        if (newData.isEmpty) {
          _hasMoreData = false;
        } else {
          _products.addAll(newData);
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
          Navigator.pop(dialogContext);
          setState(() => _isLoading = true);

          final provider = context.read<StoreProvider>();
          bool success = await provider.deleteProduct(product.id);

          if (!mounted) return;

          if (success) {
            setState(() {
              _products.removeWhere((p) => p.id == product.id);
              _isLoading = false;
            });
            showSnackBar(context, context.l10n.productDeletedSuccessfully);
          } else {
            setState(() => _isLoading = false);
            showSnackBar(context, context.l10n.unexpectedError, isError: true);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => const AddProductDialog(),
                );
                if (result == true) {
                  setState(() => _isLoading = true);
                  _fetchInitialProducts();
                }
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          MainHeader(
            title: AppLocalizations.of(context)!.store,
            icon: "assets/icons/cart.svg",
            onIconTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            secondIcon: "assets/icons/bag.svg",
            onSecondIconTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdersScreen(isAdmin: isAdmin),
                ),
              );
            },
            searchHintText: context.l10n.searchProductHint,
            height: 195.h,
            onSearchChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  _searchQuery = value.trim();
                });
                _fetchInitialProducts();
              });
            },
            onClearSearch: () {
              setState(() {
                _searchQuery = '';
              });
              _fetchInitialProducts();
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchInitialProducts,
                    child: GridView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
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
                              builder: (context) => ProductDetailsScreen(
                                product: _products[index],
                              ),
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
          ),
        ],
      ),
    );
  }
}

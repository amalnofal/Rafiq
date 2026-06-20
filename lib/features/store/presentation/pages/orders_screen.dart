import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/store/data/order_model.dart';
import 'package:rafiq/features/store/presentation/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  final bool isAdmin;

  const OrdersScreen({super.key, this.isAdmin = false});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilterIndex = 0;

  List<OrderModel> _realOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final provider = context.read<StoreProvider>();

    final orders = widget.isAdmin
        ? await provider.getAllOrders()
        : await provider.getMyOrders();

    if (mounted) {
      setState(() {
        _realOrders = orders;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // حساب أعداد الطلبات لكل فلتر
    final pendingCount = _realOrders.where((o) => o.status == 0).length;
    final approvedCount = _realOrders.where((o) => o.status == 1).length;

    // قائمة الفلاتر
    final List<Map<String, dynamic>> filters = [
      {
        'title': '${context.l10n.pending} ($pendingCount)',
        'activeColor': Theme.of(context).colorScheme.primary,
        'inactiveBg': isDark
            ? const Color(0xFFE87E41).withValues(alpha: 0.15)
            : const Color(0xFFFFF3EB),
        'inactiveText': const Color(0xFFE87E41),
      },
      {
        'title': '${context.l10n.confirmed} ($approvedCount)',
        'activeColor': Theme.of(context).colorScheme.primary,
        'inactiveBg': isDark
            ? const Color(0xFF34C759).withValues(alpha: 0.15)
            : const Color(0xFFE0FBE8),
        'inactiveText': const Color(0xFF34C759),
      },
    ];

    // تطبيق الفلتر
    final filteredOrders = _realOrders.where((order) {
      if (_selectedFilterIndex == 0) return order.status == 0;
      if (_selectedFilterIndex == 1) return order.status == 1;
      return true;
    }).toList();

    return RafiqScaffold(
      appBar: AppBar(title: Text(context.l10n.ordersTitle), centerTitle: true),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: 16.h,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // شريط الفلاتر
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(filters.length, (index) {
                      final filter = filters[index];
                      final isSelected = _selectedFilterIndex == index;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilterIndex = index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? filter['activeColor']
                                  : filter['inactiveBg'],
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              filter['title'],
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : filter['inactiveText'],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // قائمة الطلبات
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchOrders,
                    child: filteredOrders.isEmpty
                        ? CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/bag.svg",
                                      width: 100.w,
                                      height: 100.h,
                                      colorFilter: ColorFilter.mode(
                                        theme.colorScheme.onTertiary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      context.l10n.noOrdersToDisplay,
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              return OrderCard(
                                order: filteredOrders[index],
                                isAdmin: widget.isAdmin,
                                onAccept: () async {
                                  // إرسال ريكويست القبول للباك إند (status = 1)
                                  final success = await context
                                      .read<StoreProvider>()
                                      .updateOrderStatus(
                                        filteredOrders[index].orderId,
                                        1,
                                      );

                                  if (context.mounted) {
                                    if (success) {
                                      _fetchOrders();
                                      showSnackBar(
                                        context,
                                        context.l10n.orderAcceptedSuccessfully,
                                      );
                                    } else {
                                      showSnackBar(
                                        context,
                                        context.l10n.unexpectedError,
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                                onCancel: () async {
                                  final success = await context
                                      .read<StoreProvider>()
                                      .cancelOrder(
                                        filteredOrders[index].orderId
                                            .toString(),
                                      );

                                  if (context.mounted) {
                                    if (success) {
                                      _fetchOrders();
                                      showSnackBar(
                                        context,
                                        context.l10n.orderCanceledSuccessfully,
                                      );
                                    } else {
                                      showSnackBar(
                                        context,
                                        context.l10n.unexpectedError,
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}

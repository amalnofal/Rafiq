import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/stat_card.dart';
import 'package:rafiq/features/store/data/order_model.dart';
import 'package:rafiq/features/store/presentation/widgets/order_item_row.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;
  final bool isAdmin;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.isAdmin = false,
    this.onAccept,
    this.onCancel,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final int status = widget.order.status;
    final List items = widget.order.items;

    final Color statusColor = status == 1
        ? const Color(0xFF34C759)
        : const Color(0xFFE87E41);
    final Color statusBgColor = status == 1
        ? (isDark
              ? const Color(0xFF34C759).withValues(alpha: 0.15)
              : const Color(0xFFE0FBE8))
        : (isDark
              ? const Color(0xFFE87E41).withValues(alpha: 0.15)
              : const Color(0xFFFFF3EB));

    final String statusText = status == 1
        ? context.l10n.confirmed
        : context.l10n.pending;
    final IconData statusIcon = status == 1
        ? Icons.check_circle_outline
        : Icons.access_time;

    String dateStr = widget.order.orderDate;
    if (dateStr.isNotEmpty &&
        !dateStr.endsWith('Z') &&
        !dateStr.contains('+')) {
      dateStr += 'Z';
    }

    DateTime orderDate =
        DateTime.tryParse(dateStr)?.toLocal() ?? DateTime.now();

    String formattedDate = DateHelper.formatFullDate(orderDate, context);
    String formattedTime = DateHelper.formatTime(
      "${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}",
      context,
    );

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الهيدر (رقم الطلب + الحالة)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/box.svg",
                    width: 16.r,
                    height: 16.r,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.orderNumber(widget.order.orderId),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              // حالة الطلب
              StatCard(
                title: statusText,
                bgcolor: statusBgColor,
                color: statusColor,
                icon: statusIcon,
              ),
            ],
          ),

          // التاريخ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "$formattedDate • $formattedTime",
              style: theme.textTheme.labelSmall,
            ),
          ),
          SizedBox(height: 8.h),

          // 2. بيانات العميل (للآدمن فقط)
          if (widget.isAdmin) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    _buildAdminInfoRow(
                      "assets/icons/user_icon.svg",
                      widget.order.userName ?? "عميل رفيق",
                    ),
                    SizedBox(height: 8.h),
                    _buildAdminInfoRow(
                      "assets/icons/phone.svg",
                      widget.order.phoneNumber ?? "رقم الهاتف غير متوفر",
                      isLtr: true,
                    ),
                    SizedBox(height: 8.h),
                    _buildAdminInfoRow(
                      "assets/icons/location.svg",
                      widget.order.shippingAddress,
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Divider(),

          // 3. المنتجات
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                ...items
                    .take(_isExpanded ? items.length : 2)
                    .map(
                      (item) => OrderItemRow(
                        imageUrl: item.imageUrl,
                        productName: item.productName,
                        unitPrice: item.unitPrice,
                        quantity: item.quantity,
                      ),
                    ),

                if (items.length > 2)
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded
                                ? context.l10n.showLessBtn
                                : context.l10n.otherProductsCount(
                                    items.length - 2,
                                  ),
                            style: theme.textTheme.titleSmall,
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18.r,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Divider(),
          SizedBox(height: 12.h),

          // 4. الفوتر (الإجمالي + أزرار التحكم)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.totalAmountLabel,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${widget.order.totalAmount} ${context.l10n.currencyEGP}",
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // لو الطلب قيد الانتظار (Status == 0)
              if (status == 0) ...[
                SizedBox(height: 16.h),

                if (widget.isAdmin)
                  // تأكيد طلبات اليوزرز (للأدمن)
                  CustomButton(
                    onPressed: widget.onAccept,
                    title: context.l10n.completeOrderBtn,
                    fontWeight: FontWeight.w500,
                    height: 52.h,
                  )
                else
                  // إلغاء الاوردر بتاعي
                  InkWell(
                    onTap: widget.onCancel != null
                        ? () => widget.onCancel!()
                        : null,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF3F1D1D)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        context.l10n.cancelOrderBtn,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFE7000B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminInfoRow(String icon, String text, {bool isLtr = false}) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16.r,
          height: 16.r,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
            textDirection: isLtr ? TextDirection.ltr : null,
          ),
        ),
      ],
    );
  }
}

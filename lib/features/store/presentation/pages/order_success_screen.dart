import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/store/presentation/pages/orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      body: Center(
        child: CustomContainer(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100.r,
                color: Colors.green,
              ),
              SizedBox(height: 24.h),
              Text(
                context.l10n.orderPlacedSuccessfully,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 12.h),
              Text(
                context.l10n.orderSuccessMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),

              CustomButton(
                title: context.l10n.viewMyOrders,
                elevation: 0,
                height: 52.h,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: Text(context.l10n.continueShopping),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

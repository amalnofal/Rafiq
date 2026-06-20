import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/store/presentation/pages/order_success_screen.dart';

class DeliveryInfoScreen extends StatefulWidget {
  const DeliveryInfoScreen({super.key});

  @override
  State<DeliveryInfoScreen> createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RafiqScaffold(
      appBar: AppBar(title: Text(context.l10n.deliveryInfo)),
      padding: EdgeInsets.all(20.w),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. رقم الهاتف
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/phone.svg",
                        width: 18.r,
                        height: 18.r,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          context.l10n.phone_number,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        ValidationHelper.validatePhone(val, context),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // 2. عنوان التوصيل
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/location.svg",
                    width: 18.r,
                    height: 18.r,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      context.l10n.deliveryAddress,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: _addressController,
                hintText: context.l10n.deliveryAddressHint,
                maxLines: 3,
                validator: (val) =>
                    ValidationHelper.validateAddress(val, context),
              ),
              SizedBox(height: 8.h),

              // 3. طريقة الدفع (الدفع عند الاستلام)
              CustomContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/payment.svg",
                          width: 18.r,
                          height: 18.r,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            context.l10n.paymentMethod,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Card(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/check.svg",
                              width: 18.r,
                              height: 18.r,
                              colorFilter: ColorFilter.mode(
                                theme.colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Text(
                                context.l10n.cashOnDelivery,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      title: context.l10n.confirmOrder,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          final success = await context
                              .read<StoreProvider>()
                              .checkout(
                                phone: _phoneController.text,
                                address: _addressController.text,
                              );

                          if (context.mounted) {
                            setState(() => _isLoading = false);

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderSuccessScreen(),
                                ),
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
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

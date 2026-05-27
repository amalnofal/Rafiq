import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/image_upload_card.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/store/data/product_model.dart';

class AddProductDialog extends StatefulWidget {
  final ProductModel? product;

  const AddProductDialog({super.key, this.product});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _qtyController.text = widget.product!.stockQuantity.toString();
      _existingImageUrl = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: Theme.of(context).cardColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogHeader(
                    title: widget.product == null
                        ? context.l10n.addProductTitle
                        : context.l10n.editProductTitle,
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // صورة المنتج
                                ImageUploadCard(
                                  height: 180.h,
                                  imageFile: _selectedImage,
                                  imageUrl: _existingImageUrl,
                                  showError: _imageError,
                                  onTap: () {
                                    ImagePickerHelper.showOptionSheet(context, (
                                      file,
                                    ) {
                                      setState(() {
                                        _selectedImage = file;
                                        _existingImageUrl = null;
                                        _imageError = false;
                                      });
                                    });
                                  },
                                  onRemove: () {
                                    setState(() {
                                      _selectedImage = null;
                                      _existingImageUrl = null;
                                    });
                                  },
                                ),
                                SizedBox(height: 16.h),
                                // اسم المنتج
                                Text(
                                  context.l10n.productNameLabel,
                                  style: Theme.of(context).textTheme.labelSmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                CustomTextField(controller: _nameController),
                                SizedBox(height: 16.h),

                                // وصف المنتج
                                Text(
                                  context.l10n.productDescLabel,
                                  style: Theme.of(context).textTheme.labelSmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                CustomTextField(
                                  controller: _descController,
                                  maxLines: 5,
                                  minLines: 3,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                ),
                                SizedBox(height: 16.h),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // كمية المنتج
                                          Text(
                                            context.l10n.quantityLabel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          CustomTextField(
                                            controller: _qtyController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return context
                                                    .l10n
                                                    .fieldRequired;
                                              }
                                              return null;
                                            },
                                            contentpadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                  horizontal: 12.w,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // سعر المنتج
                                          Text(
                                            "${context.l10n.priceLabel} (${context.l10n.currencyEGP})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          CustomTextField(
                                            controller: _priceController,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(
                                                  decimal: true,
                                                ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return context
                                                    .l10n
                                                    .fieldRequired;
                                              }
                                              return null;
                                            },
                                            contentpadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                  horizontal: 12.w,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),

                                CustomButton(
                                  title: widget.product == null
                                      ? context.l10n.save
                                      : context.l10n.editAction,
                                  fontWeight: FontWeight.w500,
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (widget.product == null &&
                                        _selectedImage == null) {
                                      setState(() => _imageError = true);
                                      return;
                                    }
                                    final provider = context
                                        .read<StoreProvider>();

                                    setState(() => _isLoading = true);

                                    try {
                                      final formData = FormData.fromMap({
                                        'ProductName': _nameController.text,
                                        'Description': _descController.text,
                                        'Price': _priceController.text,
                                        'StockQuantity': _qtyController.text,
                                      });

                                      if (_selectedImage != null) {
                                        formData.files.add(
                                          MapEntry(
                                            'ImageFile',
                                            await MultipartFile.fromFile(
                                              _selectedImage!.path,
                                            ),
                                          ),
                                        );
                                      }

                                      bool success = false;

                                      if (widget.product == null) {
                                        success = await provider.addProduct(
                                          formData,
                                        );
                                      } else {
                                        success = await provider.editProduct(
                                          widget.product!.id,
                                          formData,
                                        );
                                      }

                                      if (!context.mounted) return;
                                      if (success) {
                                        Navigator.pop(context, true);
                                      } else {
                                        showSnackBar(
                                          context,
                                          context.l10n.unexpectedError,
                                          isError: true,
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

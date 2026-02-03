import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/image_upload_card.dart';
import 'package:rafiq/features/auth/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_header.dart';
import 'package:rafiq/features/auth/presentation/widgets/review_note.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VetVerification extends StatefulWidget {
  final RegisterController controller;

  const VetVerification({super.key, required this.controller});

  @override
  State<VetVerification> createState() => _VetVerificationState();
}

class _VetVerificationState extends State<VetVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _attemptedSubmit = false;

  File? _idFrontImage;
  File? _idBackImage;
  File? _licenseImage;

  void _validateAndSubmit() {
    setState(() {
      _attemptedSubmit = true;
    });

    bool isTextValid = _formKey.currentState!.validate();
    bool areImagesValid =
        _idFrontImage != null && _idBackImage != null && _licenseImage != null;

    if (isTextValid && areImagesValid) {
      widget.controller.uploadVetDocuments(
        idFront: _idFrontImage!,
        idBack: _idBackImage!,
        license: _licenseImage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AuthHeader(
            title: AppLocalizations.of(context)!.professionalInfoTitle,
            subtitle: AppLocalizations.of(context)!.professionalInfoSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: widget.controller.specController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.specializationLabel,
                            prefixIcon: "assets/icons/vet.svg",
                            validator: (val) =>
                                ValidationHelper.validateRequired(val, context),
                          ),

                          CustomTextField(
                            controller: widget.controller.subSpecController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.subSpecializationLabel,
                            prefixIcon: "assets/icons/work.svg",
                            validator: (val) =>
                                ValidationHelper.validateRequired(val, context),
                          ),

                          SizedBox(height: 24.h),

                          // البطاقة الأمامية
                          ImageUploadCard(
                            label:
                                "${AppLocalizations.of(context)!.idFrontLabel}*",
                            imageFile: _idFrontImage,
                            showError:
                                _attemptedSubmit && _idFrontImage == null,
                            onTap: () {
                              ImagePickerHelper.showOptionSheet(context, (
                                file,
                              ) {
                                setState(() {
                                  _idFrontImage = file;
                                });
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          // البطاقة الخلفية
                          ImageUploadCard(
                            label:
                                "${AppLocalizations.of(context)!.idBackLabel}*",
                            imageFile: _idBackImage,
                            showError: _attemptedSubmit && _idBackImage == null,
                            onTap: () {
                              ImagePickerHelper.showOptionSheet(context, (
                                file,
                              ) {
                                setState(() {
                                  _idBackImage = file;
                                });
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          // الكارنيه
                          ImageUploadCard(
                            label:
                                "${AppLocalizations.of(context)!.vetCardLabel}*",
                            imageFile: _licenseImage,
                            showError:
                                _attemptedSubmit && _licenseImage == null,
                            onTap: () {
                              ImagePickerHelper.showOptionSheet(context, (
                                file,
                              ) {
                                setState(() {
                                  _licenseImage = file;
                                });
                              });
                            },
                          ),

                          const ReviewNote(),

                          CustomButton(
                            title: AppLocalizations.of(
                              context,
                            )!.submitForReviewBtn,
                            onpressed: _validateAndSubmit,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

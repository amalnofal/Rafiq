import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/image_upload_card.dart';
import 'package:rafiq/features/auth/controller/register_controller.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/auth/presentation/pages/interests_screen.dart';
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
      widget.controller.setVetImages(
        front: _idFrontImage!,
        back: _idBackImage!,
        union: _licenseImage!,
      );

      final currentCubit = context.read<RegisterCubit>();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: currentCubit,
            child: InterestsScreen(controller: widget.controller),
          ),
        ),
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
            onBackTap: () => Navigator.pop(context),
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
                                ValidationHelper.validateSpecialization(
                                  val,
                                  context,
                                ),
                          ),

                          CustomTextField(
                            controller: widget.controller.subSpecController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.subSpecializationLabel,
                            prefixIcon: "assets/icons/work.svg",
                            validator: (val) =>
                                ValidationHelper.validateSpecialization(
                                  val,
                                  context,
                                ),
                          ),

                          SizedBox(height: 24.h),

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
                                setState(() => _idFrontImage = file);
                              });
                            },
                            onRemove: () {
                              setState(() {
                                _idFrontImage = null;
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          ImageUploadCard(
                            label:
                                "${AppLocalizations.of(context)!.idBackLabel}*",
                            imageFile: _idBackImage,
                            showError: _attemptedSubmit && _idBackImage == null,
                            onTap: () {
                              ImagePickerHelper.showOptionSheet(context, (
                                file,
                              ) {
                                setState(() => _idBackImage = file);
                              });
                            },
                            onRemove: () {
                              setState(() {
                                _idBackImage = null;
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

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
                                setState(() => _licenseImage = file);
                              });
                            },
                            onRemove: () {
                              setState(() {
                                _licenseImage = null;
                              });
                            },
                          ),

                          const ReviewNote(),

                          CustomButton(
                            title: AppLocalizations.of(
                              context,
                            )!.submitForReviewBtn,
                            onPressed: _validateAndSubmit,
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

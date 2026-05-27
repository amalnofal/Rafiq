import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/back_button.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/latest_medical_record_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/upcoming_appointment_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/helper/date_helper.dart';

class PetProfileScreen extends StatefulWidget {
  final PetModel pet;
  final bool isMe;

  const PetProfileScreen({super.key, required this.pet, this.isMe = true});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  File? _localPetImage;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPetProfile(widget.pet.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petProvider = context.watch<PetProvider>();

    final isProfileLoading = petProvider.isLoading;
    final profile = petProvider.currentPetProfile;
    final upcomingAppointments = petProvider.upcomingAppointments;
    final medicalRecords = petProvider.medicalRecords;

    final isCurrentPetLoaded =
        profile != null &&
        (profile['petId']?.toString() == widget.pet.id ||
            profile['id']?.toString() == widget.pet.id);

    final isInitialLoading = isProfileLoading && !isCurrentPetLoaded;

    PetModel displayPet = widget.pet;

    if (isCurrentPetLoaded) {
      displayPet = PetModel.fromJson(profile);
    }

    return RafiqScaffold(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingS,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  child: const BackButtonWidget(),
                ),
                SizedBox(height: 12.h),

                // ==========================================
                // 1. حالة التحميل (استخدمنا isInitialLoading)
                // ==========================================
                if (isInitialLoading)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                // ==========================================
                // 2. عرض الداتا (شيلنا شاشة الإيرور خالص)
                // ==========================================
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (context.mounted) {
                          await context.read<PetProvider>().fetchPetProfile(
                            widget.pet.id,
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomContainer(
                              margin: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingS,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        children: [
                                          PetImage(
                                            imageUrl:
                                                _localPetImage?.path ??
                                                displayPet.imageUrl,
                                            size: 90.r,
                                          ),
                                          if (widget.isMe)
                                            PositionedDirectional(
                                              bottom: 0.h,
                                              end: 0.w,
                                              child: CircleIconButton(
                                                "assets/icons/camera.svg",
                                                size: 30.h,
                                                iconSize: 16.h,
                                                bgColor: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                onTap: () {
                                                  ImagePickerHelper.showOptionSheet(
                                                    context,
                                                    (file) async {
                                                      setState(() {
                                                        _localPetImage = file;
                                                        _isUploadingImage =
                                                            true;
                                                      });

                                                      try {
                                                        await context
                                                            .read<PetProvider>()
                                                            .uploadPetPhoto(
                                                              widget.pet.id,
                                                              file,
                                                            );

                                                        if (!context.mounted) {
                                                          return;
                                                        }

                                                        await context
                                                            .read<PetProvider>()
                                                            .fetchPetProfile(
                                                              widget.pet.id,
                                                            );

                                                        if (!context.mounted) {
                                                          return;
                                                        }

                                                        showSnackBar(
                                                          context,
                                                          l10n.imageUpdated,
                                                          isError: false,
                                                        );
                                                      } catch (e) {
                                                        setState(() {
                                                          _localPetImage = null;
                                                        });

                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        showSnackBar(
                                                          context,
                                                          l10n.unexpectedError,
                                                          isError: true,
                                                        );
                                                      } finally {
                                                        if (mounted) {
                                                          setState(() {
                                                            _isUploadingImage =
                                                                false;
                                                          });
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: PetInfoCard(pet: displayPet),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),

                                  _buildInfoRow(
                                    icon: "assets/icons/calendar.svg",
                                    label: l10n.dateOfBirthLabel,
                                    value: DateHelper.formatFullDate(
                                      displayPet.dob,
                                      context,
                                    ),
                                    context: context,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildInfoRow(
                                    icon: "assets/icons/weight.svg",
                                    label: l10n.weightLabel,
                                    value:
                                        "${displayPet.weight} ${l10n.kgLabel}",
                                    context: context,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildInfoRow(
                                    icon: "assets/icons/color.svg",
                                    label: l10n.colorLabel,
                                    value: displayPet.color,
                                    context: context,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // 1. السجل الطبي
                            LatestMedicalRecordCard(
                              records: medicalRecords,
                              showOnlyLatest: false,
                            ),

                            // 2. المواعيد القادمة
                            UpcomingAppointmentCard(
                              appointments: upcomingAppointments,
                              showOnlyNext: false,
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_isUploadingImage) const LoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text("$label:", style: Theme.of(context).textTheme.labelMedium),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

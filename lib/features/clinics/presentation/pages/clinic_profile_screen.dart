import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/back_button.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_profile_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_rating_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_reviews_list.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ClinicProfileScreen extends StatefulWidget {
  final ClinicModel clinic;
  final bool isMe;

  const ClinicProfileScreen({
    super.key,
    required this.clinic,
    this.isMe = false,
  });

  @override
  State<ClinicProfileScreen> createState() => _ClinicProfileScreenState();
}

class _ClinicProfileScreenState extends State<ClinicProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    final clinicId = widget.clinic.id;

    if (clinicId != 0) {
      await context.read<ClinicProvider>().fetchClinicDetails(clinicId);
    } else {
      debugPrint("⚠️ Warning: Clinic ID is invalid or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().user;
    final clinicProvider = context.watch<ClinicProvider>();

    final bool isInitialLoading =
        clinicProvider.isLoading && clinicProvider.currentClinicDetails == null;

    final currentClinic = clinicProvider.currentClinicDetails ?? widget.clinic;

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      body: SafeArea(
        child: isInitialLoading
            ? Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  PositionedDirectional(
                    top: 16.h,
                    start: 16.w,
                    child: const BackButtonWidget(),
                  ),
                ],
              )
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    color: Theme.of(context).colorScheme.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Builder(
                                builder: (context) {
                                  final localImage = clinicProvider
                                      .getLocalClinicImage(currentClinic.id);

                                  String? coverPath;
                                  if (localImage != null) {
                                    coverPath = localImage.path;
                                  } else if (currentClinic.hasImage) {
                                    coverPath = currentClinic.imageUrl;
                                  }

                                  return Column(
                                    children: [
                                      Container(
                                        height: 150.h,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child:
                                            (coverPath != null &&
                                                coverPath.isNotEmpty)
                                            ? SmartImageDisplay(
                                                path: coverPath,
                                                height: 135.h,
                                                radius: 0,
                                                fit: BoxFit.cover,
                                                showLoader: false,
                                              )
                                            : null,
                                      ),
                                    ],
                                  );
                                },
                              ),

                              if (widget.isMe)
                                PositionedDirectional(
                                  top: 16.h,
                                  end: 16.w,
                                  child: CircleIconButton(
                                    bgColor: Theme.of(context).cardColor,
                                    "assets/icons/camera.svg",
                                    size: 35.h,
                                    onTap: () {
                                      ImagePickerHelper.showOptionSheet(
                                        context,
                                        (file) async {
                                          try {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => const Center(
                                                child: LoadingOverlay(),
                                              ),
                                            );

                                            await context
                                                .read<ClinicProvider>()
                                                .uploadClinicPhoto(
                                                  context,
                                                  currentClinic.id,
                                                  file,
                                                );

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              showSnackBar(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.imageUpdated,
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              showSnackBar(
                                                context,
                                                AppLocalizations.of(
                                                  context,
                                                )!.unexpectedError,
                                                isError: true,
                                              );
                                            }
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),

                              PositionedDirectional(
                                top: 16.h,
                                start: 16.w,
                                child: const BackButtonWidget(),
                              ),

                              // العنوان والمواعيد والتخصص
                              ClinicProfileCard(
                                currentClinic: currentClinic,
                                currentUser: currentUser,
                                isMe: widget.isMe,
                              ),
                            ],
                          ),

                          ClinicRatingCard(
                            clinic: currentClinic,
                            isMe: widget.isMe,
                            isDoctor: currentUser?.role == UserType.vet,
                          ),

                          ClinicReviewsList(clinic: currentClinic),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),

                  if (clinicProvider.isLoading &&
                      clinicProvider.currentClinicDetails != null)
                    const Positioned.fill(child: LoadingOverlay()),
                ],
              ),
      ),
    );
  }
}

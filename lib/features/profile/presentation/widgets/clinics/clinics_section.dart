import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/profile/presentation/pages/add_clinic_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/clinics/vet_clinic_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/empty_state_card.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ClinicsSection extends StatefulWidget {
  final bool isMe;
  final UserModel? user;

  const ClinicsSection({super.key, required this.isMe, this.user});

  @override
  State<ClinicsSection> createState() => _ClinicsSectionState();
}

class _ClinicsSectionState extends State<ClinicsSection> {
  int _visibleCount = 2;

  @override
  Widget build(BuildContext context) {
    final clinicProvider = context.watch<ClinicProvider>();

    List<dynamic> clinicsList = [];
    if (widget.isMe) {
      clinicsList = clinicProvider.clinics;
    } else {
      if (widget.user?.doctorDetails != null &&
          widget.user!.doctorDetails!['clinics'] != null) {
        final List rawClinics = widget.user!.doctorDetails!['clinics'];
        clinicsList = rawClinics.map((c) => ClinicModel.fromJson(c)).toList();
      }
    }

    String title = widget.isMe
        ? AppLocalizations.of(context)!.myClinicsTitle
        : AppLocalizations.of(context)!.clinics;

    if (clinicsList.isNotEmpty) {
      title += " (${clinicsList.length})";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            Spacer(),
            if (widget.isMe)
              CircleIconButton(
                "assets/icons/add.svg",
                size: 32.r,
                iconSize: 18.r,
                bgColor: Theme.of(context).colorScheme.primary,
                color: Colors.white,
                onTap: () async {
                  final newClinicData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClinicScreen(),
                    ),
                  );

                  if (newClinicData != null && context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: LoadingOverlay()),
                    );

                    try {
                      await context.read<ClinicProvider>().addClinicToServer(
                        context,
                        newClinicData,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        showSnackBar(
                          context,
                          AppLocalizations.of(context)!.addClinicSuccess,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        showSnackBar(
                          context,
                          AppLocalizations.of(context)!.unexpectedError,
                          isError: true,
                        );
                      }
                    }
                  }
                },
              ),
          ],
        ),
        SizedBox(height: 12.h),

        clinicsList.isEmpty
            ? EmptyStateCard(
                message: AppLocalizations.of(context)!.noClinicsAdded,
              )
            : AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    ...clinicsList
                        .take(_visibleCount)
                        .map(
                          (clinic) => VetClinicCard(
                            clinic: clinic,
                            isMe: widget.isMe,
                            // 1. التعديل (Edit)
                            onEdit: () async {
                              final editedData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddClinicScreen(clinicToEdit: clinic),
                                ),
                              );

                              if (editedData != null && context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                      const Center(child: LoadingOverlay()),
                                );

                                try {
                                  await context
                                      .read<ClinicProvider>()
                                      .updateClinicInServer(
                                        context,
                                        clinic.id,
                                        editedData,
                                      );

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    showSnackBar(
                                      context,
                                      AppLocalizations.of(
                                        context,
                                      )!.changes_saved,
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
                              }
                            },
                            // 2. الحذف (Delete)
                            onDelete: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) =>
                                    const Center(child: LoadingOverlay()),
                              );

                              try {
                                await context
                                    .read<ClinicProvider>()
                                    .deleteClinicFromServer(context, clinic.id);

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  showSnackBar(
                                    context,
                                    AppLocalizations.of(
                                      context,
                                    )!.deleteClinicSuccess,
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
                          ),
                        ),
                    if (clinicsList.length > 2)
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_visibleCount >= clinicsList.length) {
                                _visibleCount = 2;
                              } else {
                                _visibleCount += 2;
                              }
                            });
                          },
                          child: Text(
                            _visibleCount >= clinicsList.length
                                ? AppLocalizations.of(context)!.showLessBtn
                                : AppLocalizations.of(context)!.showMoreBtn,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}

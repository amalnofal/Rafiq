import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/profile/presentation/pages/add_pet_screen.dart';
import 'package:rafiq/features/profile/presentation/pages/pet_profile_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;
  final bool isMe;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PetCard({
    super.key,
    required this.pet,
    this.isMe = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: isMe
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfileScreen(pet: pet),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingM,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PetImage(imageUrl: pet.imageUrl),
                    SizedBox(width: 12.w),
                    Expanded(child: PetInfoCard(pet: pet)),
                  ],
                ),
              ),

              if (isMe)
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    MenuUtils.showContextMenu(
                      context,
                      details.globalPosition,

                      onEdit: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPetScreen(petToEdit: pet),
                          ),
                        );

                        if (result == true && context.mounted) {
                          await context.read<PetProvider>().fetchMyPets(
                            context,
                          );
                        }
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            final l10n = AppLocalizations.of(context)!;

                            return CustomInfoDialog(
                              title: l10n.deletePetTitle(pet.name),
                              description: l10n.deletePetWarning,
                              confirmBtnText: l10n.deleteAction,
                              onConfirm: () async {
                                final navigator = Navigator.of(context);

                                navigator.pop();

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                      const Center(child: LoadingOverlay()),
                                );

                                try {
                                  await context.read<PetProvider>().deletePet(
                                    pet.id,
                                  );

                                  navigator.pop();

                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      l10n.removePetSuccess,
                                    );
                                  }
                                } catch (e) {
                                  navigator.pop();

                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      l10n.unexpectedError,
                                      isError: true,
                                    );
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                      actiontxt: AppLocalizations.of(context)!.deleteAction,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20.r,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

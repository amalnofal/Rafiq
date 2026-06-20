import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/features/profile/presentation/pages/add_pet_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/empty_state_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_card.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetsSection extends StatefulWidget {
  final bool isMe;
  final UserModel? user;

  const PetsSection({super.key, required this.isMe, this.user});

  @override
  State<PetsSection> createState() => _PetsSectionState();
}

class _PetsSectionState extends State<PetsSection> {
  int _visibleCount = 2;

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();

    List<dynamic> petsList = [];
    if (widget.isMe) {
      petsList = petProvider.pets;
    } else {
      if (widget.user != null &&
          widget.user!.petOwnerDetails != null &&
          widget.user!.petOwnerDetails!['pets'] != null) {
        final List rawPets = widget.user!.petOwnerDetails!['pets'];
        petsList = rawPets.map((p) => PetModel.fromJson(p)).toList();
      }
    }

    String title = widget.isMe
        ? AppLocalizations.of(context)!.myPetsTitle
        : AppLocalizations.of(context)!.userPetsTitle;

    if (petsList.isNotEmpty) {
      title += " (${petsList.length})";
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            if (widget.isMe)
              CircleIconButton(
                "assets/icons/add.svg",
                size: 32.r,
                iconSize: 18.r,
                bgColor: Theme.of(context).colorScheme.primary,
                color: Colors.white,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPetScreen(),
                    ),
                  );
                  if (result == true && context.mounted) {
                    await context.read<PetProvider>().fetchMyPets(context);
                    setState(() => _visibleCount++);
                  }
                },
              ),
          ],
        ),
        SizedBox(height: 12.h),

        // 1. لو اليوزر خافي حيواناته أو القائمة فاضية
        if (petsList.isEmpty)
          EmptyStateCard(
            message: widget.isMe
                ? AppLocalizations.of(context)!.noPetsAdded
                : AppLocalizations.of(context)!.petsHidden,
          )
        // 2. عرض الحيوانات لو مفيش أي موانع
        else
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ...petsList
                    .take(_visibleCount)
                    .map(
                      (pet) => PetCard(
                        key: ValueKey(pet.id),
                        pet: pet,
                        isMe: widget.isMe,
                        onEdit: widget.isMe
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddPetScreen(petToEdit: pet),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                if (petsList.length > 2)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_visibleCount >= petsList.length) {
                            _visibleCount = 2;
                          } else {
                            _visibleCount += 2;
                          }
                        });
                      },
                      child: Text(
                        _visibleCount >= petsList.length
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

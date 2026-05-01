import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/profile/data/models/pet_model.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetInfoCard extends StatelessWidget {
  final PetModel? pet;

  final String? customName;
  final int? customTypeId;
  final String? customTypeName;
  final String? customBreed;
  final DateTime? customDob;
  final int? customGender;

  const PetInfoCard({
    super.key,
    this.pet,
    this.customName,
    this.customTypeId,
    this.customTypeName,
    this.customBreed,
    this.customDob,
    this.customGender,
  });

  String _getPetTypeName(BuildContext context, int typeId) {
    final l10n = AppLocalizations.of(context)!;
    switch (typeId) {
      case 1:
        return l10n.dog;
      case 2:
        return l10n.cat;
      case 3:
        return l10n.bird;
      case 4:
        return l10n.rabbit;
      case 5:
        return l10n.turtle;
      default:
        return l10n.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final name = pet?.name ?? customName ?? "";
    final breed = pet?.breed ?? customBreed ?? "";
    final gender = pet?.gender ?? customGender;
    final isMale = gender == 1;
    final dob = pet?.dob ?? customDob;

    String typeDisplay = "";
    if (pet != null) {
      typeDisplay = _getPetTypeName(context, pet!.type);
    } else if (customTypeId != null) {
      typeDisplay = _getPetTypeName(context, customTypeId!);
    } else {
      typeDisplay = customTypeName ?? "";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // اسم الحيوان
            Flexible(
              child: Text(
                name,
                style: textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // (الجنس) لو موجود
            SizedBox(width: 6.w),
            SvgPicture.asset(
              isMale ? "assets/icons/male.svg" : "assets/icons/female.svg",
              colorFilter: ColorFilter.mode(
                isMale ? const Color(0xFF5A9BD5) : const Color(0xFFE06B9A),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),

        // السطر الثاني: النوع والسلالة
        Text("$typeDisplay ($breed)", style: textTheme.labelMedium),
        SizedBox(height: 4.h),

        // السطر الثالث: العمر
        Text(
          dob != null ? DateHelper.calculateAge(dob, context) : "-",
          style: textTheme.labelMedium,
        ),
      ],
    );
  }
}

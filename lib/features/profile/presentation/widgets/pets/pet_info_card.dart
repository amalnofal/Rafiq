import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetInfoCard extends StatelessWidget {
  final PetModel? pet;

  final String? customName;
  final int? customTypeId;
  final String? customTypeName;
  final String? customBreed;
  final DateTime? customDob;
  final int? customGender;
  final bool isInline;

  const PetInfoCard({
    super.key,
    this.pet,
    this.customName,
    this.customTypeId,
    this.customTypeName,
    this.customBreed,
    this.customDob,
    this.customGender,
    this.isInline = false,
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
    final ageStr = dob != null ? DateHelper.calculateAge(dob, context) : "-";

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
            Flexible(
              child: Text(
                name,
                style: textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (gender != null) ...[
              SizedBox(width: 6.w),
              SvgPicture.asset(
                isMale ? "assets/icons/male.svg" : "assets/icons/female.svg",
                colorFilter: ColorFilter.mode(
                  isMale ? const Color(0xFF5A9BD5) : const Color(0xFFE06B9A),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),

        if (isInline) ...[
          Text(
            "$breed ($typeDisplay)  •  $ageStr",
            style: textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ] else ...[
          Text("$breed ($typeDisplay)", style: textTheme.labelMedium),
          SizedBox(height: 4.h),
          Text(ageStr, style: textTheme.labelMedium),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'pets/pets_section.dart';
import 'clinics/clinics_section.dart';

class UserSpecificSection extends StatelessWidget {
  final UserModel user;
  final bool isMe;

  const UserSpecificSection({
    super.key,
    required this.user,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (user.role != UserType.petOwner) ...[
          CustomContainer(
            padding: EdgeInsets.all(AppDimensions.paddingXL),
            child: ClinicsSection(isMe: isMe, user: user),
          ),
        ],
        CustomContainer(
          padding: EdgeInsets.all(AppDimensions.paddingXL),
          child: PetsSection(isMe: isMe, user: user),
        ),
      ],
    );
  }
}

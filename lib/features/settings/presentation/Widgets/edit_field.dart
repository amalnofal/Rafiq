import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/rounded_text_field.dart';

class EditField extends StatelessWidget {
  const EditField({
    super.key,
    required this.title,
    required this.controller,
    required this.icon,
    // required this.onChanged,
  });

  final String title;
  final TextEditingController controller;
  final String icon;
  // final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              title,
              // style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Row(
            children: [
              CircleIconButton(icon),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: RoundedTextField(
                    controller: controller,
                    // onChanged: onChanged,
                  ),
                ),
              ),
              SvgPicture.asset("assets/icons/edit.svg", height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

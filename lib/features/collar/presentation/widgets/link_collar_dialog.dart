import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart'; 
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/pet_selector_widget.dart';

class LinkCollarDialog extends StatefulWidget {
  const LinkCollarDialog({super.key});

  @override
  State<LinkCollarDialog> createState() => _LinkCollarDialogState();
}

class _LinkCollarDialogState extends State<LinkCollarDialog> {
  final TextEditingController _idController = TextEditingController();

  String? _selectedPetId;

  final String _validCollarId = "RC-100";
  String? _errorMessage;

  void _onLinkTapped() {
    if (_idController.text.trim() != _validCollarId) {
      setState(() => _errorMessage = context.l10n.invalidCollarIdError);
      return;
    }
    if (_selectedPetId == null) {
      setState(() => _errorMessage = context.l10n.selectPetFirstError);
      return;
    }

    final petsList = context.read<PetProvider>().pets;
    final selectedPet = petsList.firstWhere((pet) => pet.id == _selectedPetId);

    Navigator.pop(context, {'collarId': _validCollarId, 'pet': selectedPet});
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsList = context.watch<PetProvider>().pets;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DialogHeader(title: context.l10n.linkSmartCollarTitle),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.collarSerialNumberLabel, 
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),

                CustomTextField(
                  controller: _idController,
                  hintText: context.l10n.enterCollarNumberHint,
                  prefixIcon: "assets/icons/qr_scan.svg",
                  textCapitalization: TextCapitalization.characters,
                ),

                SizedBox(height: 24.h),

                Text(
                  context.l10n.selectPetLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.h),

                if (petsList.isEmpty)
                  Text(
                    context.l10n.noPetsFoundTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                else
                  PetSelectorWidget(
                    pets: petsList,
                    selectedPetId: _selectedPetId,
                    onPetSelected: (id) {
                      setState(() {
                        _selectedPetId = id;
                        _errorMessage = null;
                      });
                    },
                  ),

                SizedBox(height: 16.h),

                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                CustomButton(
                  title: context.l10n.linkCollarBtn,
                  onPressed: _onLinkTapped,
                  elevation: 0,
                  radius: 12.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
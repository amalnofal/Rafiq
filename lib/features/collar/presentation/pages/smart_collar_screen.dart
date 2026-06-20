import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/collar/presentation/widgets/smart_collar_card.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/features/collar/presentation/widgets/link_collar_dialog.dart';
import 'collar_detail_screen.dart';

class SmartCollarScreen extends StatefulWidget {
  const SmartCollarScreen({super.key});

  @override
  State<SmartCollarScreen> createState() => _SmartCollarScreenState();
}

class _SmartCollarScreenState extends State<SmartCollarScreen> {
  List<Map<String, dynamic>> _connectedCollars = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCollars();
  }

  void _loadSavedCollars() {
    final savedData = CacheHelper.getData(key: 'connected_collars');
    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      setState(() {
        _connectedCollars = List<Map<String, dynamic>>.from(decoded);
      });

      // أول ما نقرا الداتا من الكاش، نبلغ البروفايدر عشان يسمع في الداشبورد
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final petProvider = context.read<PetProvider>();
          for (var collar in _connectedCollars) {
            if (collar['petId'] != null) {
              petProvider.linkCollarLocally(collar['petId'], collar['id']);
            }
          }
        }
      });
    }
  }

  void _saveCollarsToLocal() async {
    await CacheHelper.saveData(
      key: 'connected_collars',
      value: jsonEncode(_connectedCollars),
    );
  }

  void _showLinkDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: const LinkCollarDialog(),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      final selectedPet = result['pet'] as PetModel;
      final newCollarId = result['collarId'];

      setState(() {
        _connectedCollars.add({
          "id": newCollarId,
          "petId": selectedPet.id,
          "petName": selectedPet.name,
          "petImage": selectedPet.imageUrl ?? "",
          "lastSync": DateTime.now().toIso8601String(),
        });
      });

      // إرسال أمر الربط للداشبورد فوراً
      context.read<PetProvider>().linkCollarLocally(
        selectedPet.id,
        newCollarId,
      );

      _saveCollarsToLocal();
    }
  }

  void _removeCollar(int index) {
    final collar = _connectedCollars[index];

    // إرسال أمر فك الربط للداشبورد
    if (collar['petId'] != null) {
      context.read<PetProvider>().unlinkCollarLocally(collar['petId']);
    }

    setState(() {
      _connectedCollars.removeAt(index);
    });
    _saveCollarsToLocal();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      body: Column(
        children: [
          MainHeader(
            title: context.l10n.smartCollar,
            subtitle: context.l10n.connectedCollarsCount(
              _connectedCollars.length,
            ),
            icon: 'assets/icons/add.svg',
            height: 130.h,
            onIconTap: _showLinkDialog,
          ),

          Expanded(
            child: _connectedCollars.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sensors_off_rounded,
                          size: 60.sp,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          context.l10n.noConnectedCollarsMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                    itemCount: _connectedCollars.length,
                    itemBuilder: (context, index) {
                      return SmartCollarCard(
                        collarData: _connectedCollars[index],
                        onUnlink: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomInfoDialog(
                              title: context.l10n.unlinkCollarConfirmTitle,
                              description: context.l10n.unlinkCollarConfirmDesc,
                              confirmBtnText: context.l10n.unlinkBtn,
                              onConfirm: () {
                                Navigator.pop(context);
                                _removeCollar(index);
                              },
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollarDetailScreen(
                                collarData: _connectedCollars[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

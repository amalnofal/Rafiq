import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/collar/presentation/widgets/smart_collar_card.dart';
import 'collar_detail_screen.dart';

class SmartCollarScreen extends StatelessWidget {
  const SmartCollarScreen({super.key});

  final List<Map<String, dynamic>> dummyCollars = const [
    {
      "id": "RC-2026-0057",
      "petName": "ماكس",
      "model": "RafeeqCollar Pro X1",
      "battery": 85,
      "lastSync": "منذ 5 دقائق",
      "petImage": "assets/images/max.png",
      "isConnected": true,
    },
    {
      "id": "RC-2025-0015",
      "petName": "ريكس",
      "model": "RafeeqCollar Pro X2",
      "battery": 70,
      "lastSync": "منذ 15 دقائق",
      "petImage": "assets/images/pet_placeholder.png",
      "isConnected": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int connectedCount = dummyCollars
        .where((c) => c['isConnected'] == true)
        .length;

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      hasMainBottomNav: true,
      body: Column(
        children: [
          MainHeader(
            title: context.l10n.smartCollar,
            subtitle: context.l10n.connectedCollarsCount(connectedCount),
            icon: 'assets/icons/add.svg',
            height: 130.h,
            onIconTap: () {},
          ),

          // 3. لستة الأطواق
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
              itemCount: dummyCollars.length,
              itemBuilder: (context, index) {
                return SmartCollarCard(
                  collarData: dummyCollars[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CollarDetailScreen(collarData: dummyCollars[index]),
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

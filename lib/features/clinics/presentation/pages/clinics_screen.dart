import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  int _selectedIndex = 0;

  final List<String> categories = [
    "الكل",
    "الأقرب",
    "الأعلى تقييماً",
    "نوع آخر",
  ];
  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: EdgeInsets.all(0),
      hasMainBottomNav: true,

      body: Column(
        children: [
          MainHeader(
            title: AppLocalizations.of(context)!.vetClinicsTitle,
            icon: "assets/icons/clinics.svg",
            searchHintText: "ابحث عن عيادة...",
            filterCategories: const [
              "الكل",
              "الأقرب",
              "الأعلى تقييماً",
              "مفتوح الآن",
            ],
            selectedFilterIndex: _selectedIndex,

            onFilterSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Spacer(),
          Text(
            "Coming Soon ",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _categories = const [
    "الكل",
    "طعام",
    "أدوات",
    "ألعاب",
    "أدوية",
  ];

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: const EdgeInsets.all(0),
      hasMainBottomNav: true,
      body: Column(
        children: [
          MainHeader(
            title: AppLocalizations.of(context)!.store,
            icon: "assets/icons/cart.svg",
            searchHintText: "ابحث عن منتج...",

            filterCategories: _categories,

            selectedFilterIndex: _selectedFilterIndex,

            onFilterSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
              debugPrint("تغيير الفلتر إلى: ${_categories[index]}");
            },
          ),

          const Spacer(),
          Text("Coming Soon", style: Theme.of(context).textTheme.displayMedium),
          const Spacer(),
        ],
      ),
    );
  }
}

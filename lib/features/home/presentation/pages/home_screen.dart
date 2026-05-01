import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:rafiq/features/home/presentation/widgets/empty_home/home_empty_state.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/home_dashboard.dart';
import 'package:rafiq/core/controller/pet_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final myPets = petProvider.pets;

    if (_selectedPetIndex >= myPets.length && myPets.isNotEmpty) {
      _selectedPetIndex = 0;
    }

    final currentPet = myPets.isNotEmpty ? myPets[_selectedPetIndex] : null;

    return RafiqScaffold(
      padding: EdgeInsets.only(
        top: AppDimensions.paddingS,
        left: AppDimensions.paddingS,
        right: AppDimensions.paddingS,
      ),
      appBar: homeAppBar(notificationsCount: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          await petProvider.fetchMyPets(context);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 20.h),
          child: myPets.isEmpty
              ? const HomeEmptyState()
              : HomeDashboard(
                  pets: myPets,
                  currentPet: currentPet!,
                  onPetChanged: (index) {
                    setState(() {
                      _selectedPetIndex = index;
                    });
                  },
                ),
        ),
      ),
      hasMainBottomNav: true,
    );
  }
}

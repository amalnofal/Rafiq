import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/empty_state_weidget.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinic_profile_screen.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinic_search_screen.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_card.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicProvider>().fetchAllClinics();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<ClinicProvider>().searchClinics(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _refreshClinics() async {
    await context.read<ClinicProvider>().fetchAllClinics();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: const EdgeInsets.all(0),
      hasMainBottomNav: true,
      body: Column(
        children: [
          MainHeader(
            title: context.l10n.vetClinicsTitle,
            icon: "assets/icons/clinics.svg",
            searchHintText: context.l10n.searchClinicHint,
            onSearchChanged: _onSearchChanged,

            readOnlySearch: true,
            onSearchTap: () {
              context.read<ClinicProvider>().clearSearch();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClinicSearchScreen()),
              );
            },
          ),
          Expanded(
            child: Consumer<ClinicProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.allClinics.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: _refreshClinics,
                  color: Theme.of(context).colorScheme.primary,
                  child: provider.allClinics.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 150.h),
                            EmptyStateWidget(
                              iconPath: "assets/icons/clinics.svg",
                              title: context.l10n.noClinicsAvailable,
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          itemCount: provider.allClinics.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 0.h),
                          itemBuilder: (context, index) {
                            final clinic = provider.allClinics[index];

                            return ClinicCard(
                              clinic: clinic,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClinicProfileScreen(
                                      clinic: clinic,
                                      isMe: false,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

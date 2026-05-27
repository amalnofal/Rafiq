import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/empty_state_weidget.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/no_internet_widget.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/clinics/presentation/pages/appointments_screen.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinic_profile_screen.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_card.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicProvider>().fetchAllClinics();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {});

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (query.trim().isEmpty) {
          context.read<ClinicProvider>().clearSearch();
        } else {
          context.read<ClinicProvider>().searchClinics(query);
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshClinics() async {
    _searchController.clear();
    context.read<ClinicProvider>().clearSearch();
    setState(() {});
    await context.read<ClinicProvider>().fetchAllClinics();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.trim().isNotEmpty;

    return RafiqScaffold(
      padding: const EdgeInsets.all(0),
      hasMainBottomNav: true,
      body: Column(
        children: [
          MainHeader(
            title: context.l10n.vetClinicsTitle,
            icon: "assets/icons/calendar.svg",
            height: 195.h,
            onIconTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
              );
            },
            searchHintText: context.l10n.searchClinicHint,
            onSearchChanged: _onSearchChanged,
            readOnlySearch: false,
            searchController: _searchController,
            onClearSearch: () {
              _searchController.clear();
              context.read<ClinicProvider>().clearSearch();
              setState(() {});
              FocusScope.of(context).unfocus();
            },
          ),
          Expanded(
            child: Consumer<ClinicProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.allClinics.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.hasConnectionError &&
                    provider.allClinics.isEmpty) {
                  return NoInternetWidget(
                    onRetry: () => provider.fetchAllClinics(),
                  );
                }

                final displayList = isSearching
                    ? provider.searchResults
                    : provider.allClinics;

                return RefreshIndicator(
                  onRefresh: _refreshClinics,
                  color: Theme.of(context).colorScheme.primary,
                  child: displayList.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 150.h),
                            // لو اليوزر بيبحث ومفيش نتايج
                            if (isSearching)
                              Center(
                                child: Text(
                                  context.l10n.noMatchingResults(
                                    _searchController.text,
                                  ),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            // لو مفيش عيادات خالص في التطبيق
                            else
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
                          itemCount: displayList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 0.h),
                          itemBuilder: (context, index) {
                            final clinic = displayList[index];

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

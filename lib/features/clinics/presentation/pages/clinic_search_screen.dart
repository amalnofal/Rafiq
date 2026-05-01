import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_search_bar.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinic_profile_screen.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_card.dart';

class ClinicSearchScreen extends StatefulWidget {
  const ClinicSearchScreen({super.key});

  @override
  State<ClinicSearchScreen> createState() => _ClinicSearchScreenState();
}

class _ClinicSearchScreenState extends State<ClinicSearchScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    setState(() {});

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // =====================================
          // الهيدر المخصص لشاشة البحث
          // =====================================
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 10.w,
              right: 10.w,
              bottom: 12.h,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  spreadRadius: -4,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                // 1. زرار الرجوع
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.only(left: 8.w, right: 12.w),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 22.sp,
                    ),
                  ),
                ),

                // 2. شريط البحث
                Expanded(
                  child: CustomSearchBar(
                    hintText: context.l10n.search,
                    controller: _searchController,
                    autofocus: true,
                    onChanged: _onSearchChanged,
                    onClear: () {
                      setState(() {});
                      context.read<ClinicProvider>().clearSearch();
                    },
                  ),
                ),
              ],
            ),
          ),

          // =====================================
          // منطقة عرض النتائج
          // =====================================
          Expanded(
            child: Consumer<ClinicProvider>(
              builder: (context, provider, child) {
                if (provider.isSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 80.w, color: Colors.grey[200]),
                        SizedBox(height: 16.h),
                        Text(
                          context.l10n.searchClinicHint,
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  );
                }

                if (provider.searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.noMatchingResults(_searchController.text),
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: provider.searchResults.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final clinic = provider.searchResults[index];
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

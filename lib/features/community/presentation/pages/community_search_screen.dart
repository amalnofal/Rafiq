import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/no_internet_widget.dart';
import 'package:rafiq/core/widgets/search_header.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart';

class CommunitySearchScreen extends StatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  State<CommunitySearchScreen> createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends State<CommunitySearchScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasConnectionError = false;
  String _currentQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty && query != _currentQuery) {
        _currentQuery = query.trim();
        _performSearch(_currentQuery);
      } else if (query.trim().isEmpty) {
        setState(() {
          _searchResults.clear();
          _currentQuery = '';
          _isLoading = false;
          _hasConnectionError = false;
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasConnectionError = false;
    });

    try {
      final provider = context.read<UserProvider>();
      final results = await provider.searchUsers(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasConnectionError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          SearchHeader(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (_hasConnectionError) {
      return NoInternetWidget(
        onRetry: () {
          if (_currentQuery.isNotEmpty) {
            _performSearch(_currentQuery);
          }
        },
      );
    }

    // 2. لسه مكتبش حاجة
    if (_currentQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80.w,
              color: theme.colorScheme.onSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              context.l10n.searchStartMessage,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      );
    }

    // 3. ملقاش نتائج
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 85.w),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                context.l10n.noSearchResults(_currentQuery),
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      );
    }

    // 4. عرض النتائج السليمة
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: CircleAvatar(
              radius: 24.r,
              backgroundColor: Colors.grey[100],
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(user.photoUrl!)
                  : const AssetImage("assets/images/user_placeholder.jpg")
                        as ImageProvider,
            ),
          ),
          title: Text(
            user.fullName,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            final currentUserId = context.read<UserProvider>().user?.id;

            final isMyProfile =
                currentUserId != null && currentUserId == user.id;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(user: user, isMe: isMyProfile),
              ),
            );
          },
        );
      },
    );
  }
}

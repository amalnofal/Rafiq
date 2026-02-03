import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/app_colors.dart';

class RafiqScaffold extends StatelessWidget {
  const RafiqScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.padding,
    this.bottomNavBar,
    this.backgroundColor,
    this.hasMainBottomNav = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavBar;
  final Color? backgroundColor;
  final bool hasMainBottomNav;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    EdgeInsetsGeometry effectivePadding =
        padding ??
        EdgeInsets.only(
          right: AppDimensions.padding,
          left: AppDimensions.padding,
          top: AppDimensions.paddingS,
        );

    Widget content = Padding(padding: effectivePadding, child: body);

    if (hasMainBottomNav) {
      content = Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).padding.bottom + AppDimensions.paddingS,
        ),
        child: content,
      );
    } else {
      content = SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: content,
      );
    }

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavBar == null
          ? null
          : SafeArea(top: false, child: bottomNavBar!),

      extendBody: true,
      extendBodyBehindAppBar: false,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildDecoration(context, isDarkMode),
        child: content,
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context, bool isDarkMode) {
    if (backgroundColor != null) {
      return BoxDecoration(color: backgroundColor);
    }
    if (isDarkMode) {
      return const BoxDecoration(color: AppColors.kDarkSurfaceBackground);
    }
    return BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor);
  }
}

import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'auth_header.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AuthHeader(
            title: title,
            subtitle: subtitle,
            onBackTap: onBackTap,
            showBackButton: showBackButton,
          ),
          SizedBox(height: AppDimensions.padding),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingL,
                horizontal: AppDimensions.paddingXL,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

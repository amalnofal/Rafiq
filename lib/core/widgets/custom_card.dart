import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class CustomCard extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const CustomCard({super.key, this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding),
        child: child,
      ),
    );
  }
}

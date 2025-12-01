import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class RafiqScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const RafiqScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    content = SingleChildScrollView(child: content);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingS,
          ),
          child: content,
        ),
      ),
    );
  }
}

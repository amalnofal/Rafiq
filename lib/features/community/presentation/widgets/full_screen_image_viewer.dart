import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Dismissible(
        key: const Key('image_viewer'),
        direction: DismissDirection.vertical,
        onDismissed: (_) {
          Navigator.pop(context);
        },
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Hero(
                tag: heroTag,
                child: SmartImageDisplay(
                  path: imageUrl,
                  fit: BoxFit.contain,
                  radius: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetImage extends StatefulWidget {
  final String? imageUrl;
  final double? size;

  const PetImage({super.key, required this.imageUrl, this.size});

  @override
  State<PetImage> createState() => _PetImageState();
}

class _PetImageState extends State<PetImage> {
  late String? _currentUrl;
  String? _previousUrl;
  @override
  void initState() {
    super.initState();
    _currentUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant PetImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldBase = oldWidget.imageUrl?.split('?').first;
    final newBase = widget.imageUrl?.split('?').first;

    if (oldBase != newBase) {
      _previousUrl = _currentUrl;
      _currentUrl = widget.imageUrl;
    }
  }

  Widget _buildAssetPlaceholder() {
    return Image.asset('assets/images/pet_placeholder.png', fit: BoxFit.cover);
  }

  Widget _buildActualImage() {
    if (_currentUrl == null || _currentUrl!.isEmpty) {
      return _buildAssetPlaceholder();
    }

    // 1. لو صورة من السيرفر
    if (_currentUrl!.startsWith('http') || _currentUrl!.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: _currentUrl!,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        cacheKey: _currentUrl!.contains('?')
            ? _currentUrl!.split('?').first
            : _currentUrl!,

        placeholder: (context, url) {
          if (_previousUrl != null &&
              (_previousUrl!.startsWith('http') ||
                  _previousUrl!.startsWith('https'))) {
            return CachedNetworkImage(
              imageUrl: _previousUrl!,
              fit: BoxFit.cover,
              cacheKey: _previousUrl!.contains('?')
                  ? _previousUrl!.split('?').first
                  : _previousUrl!,
              placeholder: (context, url) => _buildAssetPlaceholder(),
              errorWidget: (context, url, error) => _buildAssetPlaceholder(),
            );
          }
          // لو مفيش صورة قديمة، اعرض الرمادي عادي
          return _buildAssetPlaceholder();
        },
        errorWidget: (context, url, error) => _buildAssetPlaceholder(),
      );
    }

    // 2. لو صورة وهمية من الـ Assets
    if (_currentUrl!.startsWith('assets')) {
      return Image.asset(
        _currentUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildAssetPlaceholder(),
      );
    }

    // 3. لو صورة من هارد الموبايل
    return Image.file(
      File(_currentUrl!),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildAssetPlaceholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double finalSize = widget.size ?? 55.r;

    return Container(
      width: finalSize,
      height: finalSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: _buildActualImage(),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmartImageDisplay extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double radius;
  final BorderRadiusGeometry? customBorderRadius;
  final BoxFit fit;
  final Color? assetBgColor;
  final double iconSize;
  final bool showLoader;

  const SmartImageDisplay({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.customBorderRadius,
    this.radius = 16,
    this.fit = BoxFit.cover,
    this.assetBgColor,
    this.iconSize = 48,
    this.showLoader = true,
  });

  bool get _isNetwork =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: customBorderRadius ?? BorderRadius.circular(radius.r),
      child: SizedBox(
        width: width,
        height: height ?? 250.h,
        child: _buildImage(),
      ),
    );
  }

  // صورة حقيقية: network أو local file
  Widget _buildImage() {
    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        cacheKey: path.contains('?') ? path.split('?').first : path,

        useOldImageOnUrlChange: true,

        maxWidthDiskCache: 1000,
        maxHeightDiskCache: 1000,
        fit: fit,

        placeholder: (context, url) => (showLoader)
            ? const Center(child: CircularProgressIndicator.adaptive())
            : const SizedBox.shrink(),

        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(milliseconds: 300),

        errorWidget: (context, url, error) => _buildError(),
      );
    }

    // Local File
    final file = File(path);
    if (!file.existsSync()) return _buildError();
    return Image.file(file, fit: fit, errorBuilder: (_, _, _) => _buildError());
  }

  // حالة الخطأ = صورة مكسورة خلفيتها رمادي (هتظهر في إيرور 403 أو 404)
  Widget _buildError() {
    return Container(
      color: Colors.grey.shade200,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey.shade400,
            size: iconSize.r,
          ),
          SizedBox(height: 4.h),
          Text(
            "غير متاحة",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}

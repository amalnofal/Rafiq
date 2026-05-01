import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleIconButton extends StatelessWidget {
  final String assetName;
  final Color? bgColor;
  final Color? color;
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final BoxBorder? border;

  const CircleIconButton(
    this.assetName, {
    super.key,
    this.bgColor,
    this.color,
    this.onTap,
    this.size,
    this.iconSize,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final double size = this.size ?? 40.h;
    return InkWell(
      borderRadius: BorderRadius.circular(size),
      onTap: onTap ?? () {},
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Center(
          child: SvgPicture.asset(
            height: iconSize ?? 20.h,
            assetName,
            colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).colorScheme.onSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

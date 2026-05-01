import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentStatusBanner extends StatelessWidget {
  final String text;
  final VoidCallback onCancel;

  const CommentStatusBanner({
    super.key,
    required this.text,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: Row(
        children: [
          Text(text, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          GestureDetector(
            onTap: onCancel,
            child: Icon(Icons.close, size: 16.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

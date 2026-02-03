import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommentInputArea extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const CommentInputArea({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              hintText: AppLocalizations.of(context)!.writeCommentHint,
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: onSend,
            icon: Icon(Icons.send, size: 22.h),
          ),
        ],
      ),
    );
  }
}
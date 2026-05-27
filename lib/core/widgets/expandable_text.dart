import 'package:flutter/material.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool isArabic;

  const ExpandableText(
    this.text, {
    super.key,
    this.style,
    required this.isArabic,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = widget.isArabic;

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: 3,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          // إزالة الـ SizedBox من هنا
          return Text(
            widget.text,
            style: widget.style,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          );
        }

        // إزالة الـ SizedBox من هنا أيضاً
        return Column(
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                isExpanded
                    ? context.l10n.showLessBtn
                    : context.l10n.showMoreBtn,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final backgroundColor = isError
      ? theme.colorScheme.error
      : theme.colorScheme.primary;
  final messageColor = isError
      ? theme.colorScheme.onError
      : theme.colorScheme.onPrimary;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: _TopSnackBar(
            message: message,
            backgroundColor: backgroundColor,
            messageColor: messageColor,
            textStyle: theme.textTheme.bodyMedium,
            onDismissed: () => entry.remove(),
            isError: isError,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(entry);
}

class _TopSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color messageColor;
  final TextStyle? textStyle;
  final VoidCallback onDismissed;
  final bool isError;

  const _TopSnackBar({
    required this.message,
    required this.backgroundColor,
    required this.messageColor,
    required this.textStyle,
    required this.onDismissed,
    required this.isError,
  });

  @override
  State<_TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isDark
                  ? []
                  : const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Icon(
                  widget.isError
                      ? Icons.error_outline
                      : Icons.check_circle_outline_rounded,
                  color: widget.messageColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      widget.message,
                      style: widget.textStyle?.copyWith(
                        color: widget.messageColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

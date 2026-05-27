import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SegmentedCircularIndicator extends StatefulWidget {
  final double progress;

  const SegmentedCircularIndicator({super.key, required this.progress});

  @override
  State<SegmentedCircularIndicator> createState() =>
      _SegmentedCircularIndicatorState();
}

class _SegmentedCircularIndicatorState extends State<SegmentedCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // حركة ناعمة
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(60.w, 60.w),
          painter: _SegmentedPainter(
            isDarkMode: isDarkMode,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _SegmentedPainter extends CustomPainter {
  final bool isDarkMode;
  final double animationValue;

  _SegmentedPainter({required this.isDarkMode, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 3.5;

    final bgPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF262626) : const Color(0xFFF5F3ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius, bgPaint);

    final redPaint = Paint()
      ..color = const Color(0xFFE63946)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final double maxSweepAngle = 35 * (math.pi / 180);
    final double currentSweepAngle = maxSweepAngle * animationValue;

    final List<double> targetAngles = [
      0,
      math.pi / 2,
      math.pi,
      (3 * math.pi) / 2,
    ];

    for (var angle in targetAngles) {
      double startAngle = angle - (currentSweepAngle / 2);

      if (currentSweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          currentSweepAngle,
          false,
          redPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

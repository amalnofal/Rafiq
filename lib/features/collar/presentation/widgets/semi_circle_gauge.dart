import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SemiCircleGauge extends StatelessWidget {
  final int score;
  final Color color;

  const SemiCircleGauge({super.key, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    // نسبة التقدم من 0 لـ 1
    final double progress = (score.clamp(0, 100)) / 100.0;

    final Color bgColor = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.6);
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: SizedBox(
        width: 100.w,
        height: 50.w,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: Size(100.w, 50.w),
              painter: _SemiCirclePainter(
                progress: progress,
                color: color,
                bgColor: bgColor,
              ),
            ),
            Text(
              score.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _SemiCirclePainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // إعدادات فرشاة الخلفية
    Paint bgPaint = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.w;

    // إعدادات فرشاة التقدم (الملونة)
    Paint progressPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.w;

    // نقطة المركز (في النص من تحت)
    Offset center = Offset(size.width / 2, size.height);
    // نصف القطر
    double radius = size.width / 2;

    // رسم الخلفية (من 180 درجة لحد 360 درجة)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    // رسم التقدم
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

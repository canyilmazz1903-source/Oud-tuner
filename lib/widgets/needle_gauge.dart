import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class NeedleGaugePainter extends CustomPainter {
  final double centsDeviation; // Range: -50.0 to +50.0
  final bool isInTune;

  NeedleGaugePainter({
    required this.centsDeviation,
    required this.isInTune,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final double radius = size.width / 2 - 20;

    // Background Arc (Translucent gray arc)
    final paintArc = Paint()
      ..color = const Color(0xFF1E1E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Dial arc: 180 degrees (pi radians) starting from left (pi)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      paintArc,
    );

    // Tick marks (-50, -25, 0, 25, 50 cent points)
    final paintTicks = Paint()
      ..color = AppColors.secondaryText.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i <= 4; i++) {
      double angle = pi + (i * pi / 4);
      Offset start = Offset(
        center.dx + (radius - 5) * cos(angle),
        center.dy + (radius - 5) * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius + 5) * cos(angle),
        center.dy + (radius + 5) * sin(angle),
      );
      canvas.drawLine(start, end, paintTicks);
    }

    // Perfect Center Tick (0 Cents)
    final paintCenterTick = Paint()
      ..color = isInTune ? AppColors.accentOlive : AppColors.accentAmber.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawLine(
      Offset(center.dx, center.dy - radius + 8),
      Offset(center.dx, center.dy - radius - 8),
      paintCenterTick,
    );

    // Needle Drawing
    // centsDeviation: -50 maps to pi radians, +50 maps to 2*pi radians, 0 maps to 1.5*pi radians
    final double normalizedDeviation = (centsDeviation + 50.0) / 100.0; // 0.0 to 1.0
    final double needleAngle = pi + (normalizedDeviation * pi);

    final paintNeedle = Paint()
      ..color = isInTune ? AppColors.accentOlive : AppColors.accentAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // End point of the needle
    Offset needleTip = Offset(
      center.dx + (radius - 12) * cos(needleAngle),
      center.dy + (radius - 12) * sin(needleAngle),
    );

    canvas.drawLine(center, needleTip, paintNeedle);

    // Center Circle (Needle base)
    final paintBase = Paint()
      ..color = isInTune ? AppColors.accentOlive : AppColors.accentAmber
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 6.0, paintBase);
    
    // Outer details
    final paintBaseOuter = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.0, paintBaseOuter);
  }

  @override
  bool shouldRepaint(covariant NeedleGaugePainter oldDelegate) {
    return oldDelegate.centsDeviation != centsDeviation || oldDelegate.isInTune != isInTune;
  }
}

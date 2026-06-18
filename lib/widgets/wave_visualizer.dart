import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Mikrofon sinyalinin şiddetine tepki veren minimalist ses dalgası animasyonu.
class WaveVisualizer extends StatefulWidget {
  final double amplitude; // 0.0 – 1.0 arası ses şiddeti
  final bool isActive;
  final Color? color;

  const WaveVisualizer({
    super.key,
    required this.amplitude,
    required this.isActive,
    this.color,
  });

  @override
  State<WaveVisualizer> createState() => _WaveVisualizerState();
}

class _WaveVisualizerState extends State<WaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 48),
          painter: _WavePainter(
            phase: _controller.value * 2 * pi,
            amplitude: widget.isActive ? widget.amplitude : 0.0,
            color: widget.color ?? AppColors.accentAmber,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double phase;
  final double amplitude;
  final Color color;

  _WavePainter({
    required this.phase,
    required this.amplitude,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final maxAmp = size.height * 0.35 * amplitude.clamp(0.0, 1.0);

    // Üç katmanlı dalga efekti (farklı frekanslar ve opaklıklar)
    for (int layer = 0; layer < 3; layer++) {
      final paint = Paint()
        ..color = color.withOpacity(0.12 + (0.12 * (2 - layer)))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 - (layer * 0.3)
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final freq = 2.0 + (layer * 0.7);
      final phaseShift = phase + (layer * 0.8);
      final amp = maxAmp * (1.0 - layer * 0.25);

      for (double x = 0; x <= size.width; x += 1.5) {
        final normalX = x / size.width;
        // Kenarlardan orta kısma doğru yükselen zarf (envelope)
        final envelope = sin(normalX * pi);
        final y = centerY + sin(normalX * freq * pi + phaseShift) * amp * envelope;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => true;
}

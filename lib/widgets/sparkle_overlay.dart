import 'dart:math';
import 'package:flutter/material.dart';

class SparkleOverlay extends StatefulWidget {
  final Widget child;
  const SparkleOverlay({super.key, required this.child});

  @override
  State<SparkleOverlay> createState() => _SparkleOverlayState();
}

class _SparkleOverlayState extends State<SparkleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_SparkleParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 45; i++) {
      _particles.add(_SparkleParticle.random(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _SparklePainter(_particles, _controller.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SparkleParticle {
  double x;
  double y;
  double size;
  double alphaSpeed;
  double currentAlpha;
  double phase;
  bool isStar;

  _SparkleParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.alphaSpeed,
    required this.currentAlpha,
    required this.phase,
    required this.isStar,
  });

  factory _SparkleParticle.random(Random r) {
    return _SparkleParticle(
      x: r.nextDouble(),
      y: r.nextDouble(),
      size: 2.0 + r.nextDouble() * 5.0,
      alphaSpeed: 1.0 + r.nextDouble() * 3.0,
      currentAlpha: r.nextDouble(),
      phase: r.nextDouble() * 2 * pi,
      isStar: r.nextDouble() > 0.4,
    );
  }
}

class _SparklePainter extends CustomPainter {
  final List<_SparkleParticle> particles;
  final double time;

  _SparklePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (var p in particles) {
      final double currentY = (p.y - time * 0.05) % 1.0;
      final double opacity =
          (sin(time * 2 * pi * p.alphaSpeed + p.phase) + 1) / 2;
      final double finalAlpha = (0.2 + opacity * 0.8).clamp(0.0, 1.0);

      paint.color = Colors.white.withOpacity(finalAlpha * 0.85);

      final double px = p.x * size.width;
      final double py = currentY * size.height;

      if (p.isStar) {
        // Draw 4-point sparkle star
        final double arm = p.size * (0.8 + opacity * 0.5);
        final Path starPath = Path();
        starPath.moveTo(px, py - arm);
        starPath.quadraticBezierTo(px, py, px + arm, py);
        starPath.quadraticBezierTo(px, py, px, py + arm);
        starPath.quadraticBezierTo(px, py, px - arm, py);
        starPath.quadraticBezierTo(px, py, px, py - arm);
        canvas.drawPath(starPath, paint);

        // Glow center
        final glowPaint = Paint()
          ..color = const Color(0xFFFFD1DC).withOpacity(finalAlpha * 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(px, py), arm * 0.5, glowPaint);
      } else {
        // Soft glowing dot
        canvas.drawCircle(Offset(px, py), p.size * 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) => true;
}

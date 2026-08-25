import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/lithica_theme.dart';

class LithicaBackground extends StatelessWidget {
  const LithicaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ColoredBox(
      color: dark
          ? LithicaColors.darkBackground
          : LithicaColors.lightBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? const [
                        Color(0xFF061521),
                        Color(0xFF091F30),
                        Color(0xFF102A43),
                      ]
                    : const [
                        Color(0xFFF1F3F0),
                        Color(0xFFF6F7F4),
                        Color(0xFFEDF0EC),
                      ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.82, -0.78),
                radius: 1.05,
                colors: [
                  LithicaColors.logoTeal.withValues(alpha: dark ? 0.11 : 0.065),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.92, 0.9),
                radius: 0.9,
                colors: [
                  LithicaColors.logoGreen.withValues(
                    alpha: dark ? 0.07 : 0.045,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          RepaintBoundary(
            child: IgnorePointer(
              child: CustomPaint(painter: _TopographicBackgroundPainter(dark)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _TopographicBackgroundPainter extends CustomPainter {
  const _TopographicBackgroundPainter(this.dark);

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = (dark ? const Color(0xFF79A8A4) : LithicaColors.logoTeal)
          .withValues(alpha: dark ? 0.09 : 0.07);

    _drawContourFamily(
      canvas,
      size,
      linePaint,
      center: Offset(size.width * 0.04, size.height * 0.18),
      maxRadius: size.shortestSide * 0.58,
      stretch: 1.5,
      phase: 0.45,
      count: 12,
    );
    _drawContourFamily(
      canvas,
      size,
      linePaint..color = linePaint.color.withValues(alpha: dark ? 0.07 : 0.05),
      center: Offset(size.width * 0.94, size.height * 0.82),
      maxRadius: size.shortestSide * 0.5,
      stretch: 1.7,
      phase: 2.1,
      count: 10,
    );
    _drawCommunityNetwork(canvas, size);
  }

  void _drawCommunityNetwork(Canvas canvas, Size size) {
    const normalized = [
      Offset(0.12, 0.73),
      Offset(0.28, 0.58),
      Offset(0.43, 0.76),
      Offset(0.61, 0.52),
      Offset(0.78, 0.7),
      Offset(0.9, 0.43),
    ];
    final points = normalized
        .map((point) => Offset(point.dx * size.width, point.dy * size.height))
        .toList();
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = LithicaColors.logoTeal.withValues(alpha: dark ? 0.2 : 0.15);
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], line);
      if (i + 2 < points.length) {
        canvas.drawLine(points[i], points[i + 2], line);
      }
    }
    for (final point in points) {
      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = LithicaColors.logoGreen.withValues(
            alpha: dark ? 0.2 : 0.14,
          ),
      );
      canvas.drawCircle(point, 3, Paint()..color = line.color);
    }
  }

  void _drawContourFamily(
    Canvas canvas,
    Size size,
    Paint paint, {
    required Offset center,
    required double maxRadius,
    required double stretch,
    required double phase,
    required int count,
  }) {
    for (var i = 1; i <= count; i++) {
      final progress = i / count;
      final radius = maxRadius * progress;
      final path = Path();
      const points = 72;

      for (var p = 0; p <= points; p++) {
        final angle = (p / points) * math.pi * 2;
        final wave =
            math.sin(angle * 3 + phase + i * 0.35) * 14 +
            math.cos(angle * 5 - i * 0.2) * 9;
        final currentRadius = radius + wave;
        final x = center.dx + math.cos(angle) * currentRadius * stretch;
        final y = center.dy + math.sin(angle) * currentRadius;

        if (p == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TopographicBackgroundPainter oldDelegate) =>
      oldDelegate.dark != dark;
}

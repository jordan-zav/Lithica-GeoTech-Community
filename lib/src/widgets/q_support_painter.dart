import 'dart:math' as math;
import 'package:flutter/material.dart';

class QSupportZone {
  final int id;
  final String name;
  final Color color;
  final Color stroke;
  final String shotcrete;

  const QSupportZone({
    required this.id,
    required this.name,
    required this.color,
    required this.stroke,
    required this.shotcrete,
  });
}

const List<QSupportZone> bartonZones = [
  QSupportZone(
    id: 1,
    name: "Sin Soporte",
    color: Color(0x1F60A040),
    stroke: Color(0xFF60A040),
    shotcrete: "0 cm",
  ),
  QSupportZone(
    id: 2,
    name: "Pernado Ocasional",
    color: Color(0x1871888A),
    stroke: Color(0xFF71888A),
    shotcrete: "Pernos puntuales sb",
  ),
  QSupportZone(
    id: 3,
    name: "Pernado Sistemático",
    color: Color(0x18718390),
    stroke: Color(0xFF718390),
    shotcrete: "Pernos S = 1.3-2.5m",
  ),
  QSupportZone(
    id: 4,
    name: "Shotcrete / HP (4-5 cm) + Pernos",
    color: Color(0x187A8088),
    stroke: Color(0xFF7A8088),
    shotcrete: "HP S(fr) 4-5 cm + Pernos",
  ),
  QSupportZone(
    id: 5,
    name: "HP con Fibra (5-9 cm) + Pernos",
    color: Color(0x18887F72),
    stroke: Color(0xFF887F72),
    shotcrete: "HP S(fr) 5-9 cm + Pernos",
  ),
  QSupportZone(
    id: 6,
    name: "HP con Fibra (9-12 cm) + Pernos",
    color: Color(0x18927D68),
    stroke: Color(0xFF927D68),
    shotcrete: "HP S(fr) 9-12 cm + Pernos",
  ),
  QSupportZone(
    id: 7,
    name: "HP con Fibra (12-15 cm) + Pernos",
    color: Color(0x18956E68),
    stroke: Color(0xFF956E68),
    shotcrete: "HP S(fr) 12-15 cm + Pernos",
  ),
  QSupportZone(
    id: 8,
    name: "Revestimiento / Arcos RRS (>15 cm)",
    color: Color(0x18806C78),
    stroke: Color(0xFF806C78),
    shotcrete: "Arcos HP Reforzados RRS >15 cm",
  ),
  QSupportZone(
    id: 9,
    name: "Revestimiento Especial CCA Armado",
    color: Color(0x186F626D),
    stroke: Color(0xFF6F626D),
    shotcrete: "Cerchas Acero + CCA Fundido",
  ),
];

QSupportZone getBartonZone(double q, double de) {
  final limit1 = 2.2 * math.pow(q, 0.42);
  final limit2 = 4.2 * math.pow(q, 0.40);
  final limit3 = 7.5 * math.pow(q, 0.38);
  final limit4 = 12.0 * math.pow(q, 0.36);
  final limit5 = 18.0 * math.pow(q, 0.34);
  final limit6 = 26.0 * math.pow(q, 0.32);
  final limit7 = 35.0 * math.pow(q, 0.30);
  final limit8 = 48.0 * math.pow(q, 0.28);

  if (de <= limit1) return bartonZones[0];
  if (de <= limit2) return bartonZones[1];
  if (de <= limit3) return bartonZones[2];
  if (de <= limit4) return bartonZones[3];
  if (de <= limit5) return bartonZones[4];
  if (de <= limit6) return bartonZones[5];
  if (de <= limit7) return bartonZones[6];
  if (de <= limit8) return bartonZones[7];
  return bartonZones[8];
}

class QSupportPainter extends CustomPainter {
  final double qValue;
  final double deValue;
  final bool isDarkMode;

  QSupportPainter({
    required this.qValue,
    required this.deValue,
    this.isDarkMode = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill Background
    final bgPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF0B2238) : const Color(0xFFF5F6F3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      bgPaint,
    );

    const padL = 50.0;
    const padR = 55.0; // Space for right bolt length Y-axis
    const padT = 45.0; // Space for top NGI quality bar
    const padB = 40.0;
    final plotW = size.width - padL - padR;
    final plotH = size.height - padT - padB;

    const minQLog = -3.0;
    const maxQLog = 3.0;
    final minDeLog = math.log(0.5) / math.ln10;
    final maxDeLog = math.log(50.0) / math.ln10;

    double qToX(double q) {
      final qClamped = q.clamp(0.001, 1000.0);
      final logQ = math.log(qClamped) / math.ln10;
      return padL + ((logQ - minQLog) / (maxQLog - minQLog)) * plotW;
    }

    double deToY(double de) {
      final deClamped = de.clamp(0.5, 50.0);
      final logDe = math.log(deClamped) / math.ln10;
      return size.height -
          padB -
          ((logDe - minDeLog) / (maxDeLog - minDeLog)) * plotH;
    }

    // 1. Top NGI Quality Header Bar
    final categories = [
      _Cat("Excepc. Mala", 0.001, 0.01, const Color(0x4D6F626D)),
      _Cat("Extrem. Mala", 0.01, 0.1, const Color(0x4D806C78)),
      _Cat("Muy Mala", 0.1, 1, const Color(0x4D956E68)),
      _Cat("Mala", 1, 4, const Color(0x4D927D68)),
      _Cat("Regular", 4, 10, const Color(0x4D887F72)),
      _Cat("Buena", 10, 40, const Color(0x4D718390)),
      _Cat("Muy Buena", 40, 100, const Color(0x4D71888A)),
      _Cat("Extrem. Buena", 100, 400, const Color(0x4D60A040)),
      _Cat("Excepc. Buena", 400, 1000, const Color(0x4D80C030)),
    ];

    const topBarY = 12.0;
    const topBarH = 18.0;

    for (final cat in categories) {
      final x1 = qToX(cat.min);
      final x2 = qToX(cat.max);
      final catW = x2 - x1;

      canvas.drawRect(
        Rect.fromLTWH(x1, topBarY, catW, topBarH),
        Paint()..color = cat.color,
      );

      final borderPaint = Paint()
        ..color = isDarkMode ? const Color(0x33FFFFFF) : const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRect(Rect.fromLTWH(x1, topBarY, catW, topBarH), borderPaint);

      if (catW > 20) {
        final tp = TextPainter(
          text: TextSpan(
            text: cat.name,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x1 + (catW - tp.width) / 2, topBarY + 3));
      }
    }

    // 2. Barton Zone Shading Bands
    final activeZone = getBartonZone(qValue, deValue);
    final curves = [
      _Curve(0.42, 2.2, bartonZones[0], "0 cm"),
      _Curve(0.40, 4.2, bartonZones[1], "5 cm"),
      _Curve(0.38, 7.5, bartonZones[2], "6 cm"),
      _Curve(0.36, 12.0, bartonZones[3], "9 cm"),
      _Curve(0.34, 18.0, bartonZones[4], "12 cm"),
      _Curve(0.32, 26.0, bartonZones[5], "15 cm"),
      _Curve(0.30, 35.0, bartonZones[6], "25 cm"),
      _Curve(0.28, 48.0, bartonZones[7], "RRS / Arcos"),
    ];

    for (var bIdx = curves.length - 1; bIdx >= 0; bIdx--) {
      final curve = curves[bIdx];
      final path = Path()..moveTo(padL, size.height - padB);

      const steps = 40;
      for (var i = 0; i <= steps; i++) {
        final qVal = math
            .pow(10, minQLog + (i / steps) * (maxQLog - minQLog))
            .toDouble();
        final deVal = curve.coef * math.pow(qVal, curve.exp);
        final x = qToX(qVal);
        final y = deToY(deVal);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.lineTo(padL + plotW, size.height - padB);
      path.close();

      canvas.drawPath(path, Paint()..color = curve.zone.color);
    }

    // 3. Boundary Lines & Zone Watermarks
    for (var idx = 0; idx < curves.length; idx++) {
      final curve = curves[idx];
      final path = Path();

      const steps = 40;
      for (var i = 0; i <= steps; i++) {
        final qVal = math
            .pow(10, minQLog + (i / steps) * (maxQLog - minQLog))
            .toDouble();
        final deVal = curve.coef * math.pow(qVal, curve.exp);
        final x = qToX(qVal);
        final y = deToY(deVal);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final isActive = activeZone.id == curve.zone.id;
      final linePaint = Paint()
        ..color = isActive
            ? const Color(0xFF80C030)
            : (isDarkMode ? const Color(0x665E737D) : const Color(0x666B7D82))
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 2.5 : 1.2;

      canvas.drawPath(path, linePaint);

      // Watermark Zone Number
      final labelQ = math.pow(10, -2.2 + idx * 0.62).toDouble();
      final labelDe = curve.coef * math.pow(labelQ, curve.exp) * 0.72;
      final lx = qToX(labelQ);
      final ly = deToY(labelDe);
      if (lx > padL &&
          lx < padL + plotW &&
          ly > padT + 10 &&
          ly < size.height - padB) {
        final tp = TextPainter(
          text: TextSpan(
            text: "Z${curve.zone.id}",
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0x88FFFFFF)
                  : const Color(0x88000000),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(lx, ly));
      }
    }

    // 4. Grid Ticks & Labels
    final gridPaint = Paint()
      ..color = isDarkMode ? const Color(0x33407080) : const Color(0x33475569)
      ..strokeWidth = 1;

    final qTicks = [0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0];
    final textStyle = TextStyle(
      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF475569),
      fontSize: 9,
    );

    for (final tick in qTicks) {
      final x = qToX(tick);
      canvas.drawLine(
        Offset(x, padT),
        Offset(x, size.height - padB),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: tick >= 1 ? tick.toInt().toString() : tick.toStringAsFixed(3),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - padB + 4));
    }

    final deTicks = [0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0];
    for (final tick in deTicks) {
      final y = deToY(tick);
      canvas.drawLine(Offset(padL, y), Offset(padL + plotW, y), gridPaint);

      // Left De tick label
      final tpL = TextPainter(
        text: TextSpan(
          text: "${tick < 1 ? tick : tick.toInt()}m",
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tpL.paint(canvas, Offset(padL - tpL.width - 4, y - 5));

      // Right Bolt Length L = 2 + 0.15 * De (ESR=1)
      final boltL = (2 + 0.15 * tick).toStringAsFixed(1);
      final tpR = TextPainter(
        text: TextSpan(
          text: "${boltL}m",
          style: textStyle.copyWith(color: const Color(0xFF78979A)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tpR.paint(canvas, Offset(padL + plotW + 4, y - 5));
    }

    // 5. Operating Point Marker (Q, De)
    final curX = qToX(qValue);
    final curY = deToY(deValue);
    final userBoltL = (2 + 0.15 * deValue).toStringAsFixed(1);

    // Crosshairs
    final dashPaint = Paint()
      ..color = const Color(0x9980C030)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(curX, size.height - padB),
      Offset(curX, curY),
      dashPaint,
    );
    canvas.drawLine(Offset(padL, curY), Offset(padL + plotW, curY), dashPaint);

    // Marker Pulse Ring & Dot
    canvas.drawCircle(
      Offset(curX, curY),
      10,
      Paint()..color = const Color(0x4480C030),
    );
    canvas.drawCircle(Offset(curX, curY), 4, Paint()..color = Colors.white);

    // Floating HUD: its size follows the text and it stays inside the plot.
    final hudLabel =
        "Z${activeZone.id}: ${activeZone.name} | Q=${qValue.toStringAsFixed(2)}, De=${deValue.toStringAsFixed(2)}m | Perno ~${userBoltL}m";
    const hudHorizontalPadding = 10.0;
    const hudVerticalPadding = 7.0;
    final maxHudWidth = math.max(60.0, plotW - 12).toDouble();
    final maxHudTextWidth = maxHudWidth - hudHorizontalPadding * 2;
    final hudText = TextPainter(
      text: TextSpan(
        text: hudLabel,
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 3,
      ellipsis: "…",
    )..layout();

    if (hudText.width > maxHudTextWidth) {
      hudText.layout(maxWidth: maxHudTextWidth);
    }

    final hudWidth = math
        .min(maxHudWidth, hudText.width + hudHorizontalPadding * 2)
        .toDouble();
    final hudHeight = hudText.height + hudVerticalPadding * 2;
    final minHudLeft = padL + 6;
    final maxHudLeft = padL + plotW - hudWidth - 6;
    final hudLeft = (curX - hudWidth / 2)
        .clamp(minHudLeft, maxHudLeft)
        .toDouble();
    final preferredHudTop = curY - hudHeight - 12;
    final hudTop =
        (preferredHudTop >= padT + 4
                ? preferredHudTop
                : math.min(curY + 12, size.height - padB - hudHeight - 4))
            .toDouble();
    final hudRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(hudLeft, hudTop, hudWidth, hudHeight),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      hudRect,
      Paint()
        ..color = isDarkMode
            ? const Color(0xEE0B2238)
            : const Color(0xEEFFFFFF),
    );
    canvas.drawRRect(
      hudRect,
      Paint()
        ..color = activeZone.stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    hudText.paint(
      canvas,
      Offset(hudLeft + hudHorizontalPadding, hudTop + hudVerticalPadding),
    );
  }

  @override
  bool shouldRepaint(covariant QSupportPainter oldDelegate) =>
      oldDelegate.qValue != qValue ||
      oldDelegate.deValue != deValue ||
      oldDelegate.isDarkMode != isDarkMode;
}

class _Cat {
  final String name;
  final double min;
  final double max;
  final Color color;
  _Cat(this.name, this.min, this.max, this.color);
}

class _Curve {
  final double exp;
  final double coef;
  final QSupportZone zone;
  final String thick;
  _Curve(this.exp, this.coef, this.zone, this.thick);
}

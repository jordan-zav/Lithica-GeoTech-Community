import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/geotech_calculations.dart';
import '../theme/lithica_theme.dart';

class HoekEnvelopePainter extends CustomPainter {
  final double sigCi;
  final double mb;
  final double s;
  final double a;
  final double mi;
  final double sigT;
  final double cohesionKPa;
  final double frictionDeg;
  final bool isDarkMode;
  final String plotMode; // 'mohr' or 'principal'

  HoekEnvelopePainter({
    required this.sigCi,
    required this.mb,
    required this.s,
    required this.a,
    this.mi = 15.0,
    this.sigT = -0.5,
    this.cohesionKPa = 500,
    this.frictionDeg = 35.0,
    this.isDarkMode = true,
    this.plotMode = 'mohr',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF0B2238) : const Color(0xFFF5F6F3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      bgPaint,
    );

    if (plotMode == 'mohr') {
      _paintMohrPlane(canvas, size);
    } else {
      _paintPrincipalPlane(canvas, size);
    }
  }

  void _paintMohrPlane(Canvas canvas, Size size) {
    const padL = 50.0;
    const padR = 25.0;
    const padT = 30.0;
    const padB = 40.0;
    final plotW = size.width - padL - padR;
    final plotH = size.height - padT - padB;

    final minSigma = sigT * 1.5;
    final maxSigma = math.max(10.0, sigCi * 1.0);
    final maxTau = maxSigma * 0.6;

    double toX(double sigma) =>
        padL + ((sigma - minSigma) / (maxSigma - minSigma)) * plotW;
    double toY(double tau) => size.height - padB - (tau / maxTau) * plotH;

    // Grid lines & Zero vertical separator line
    final gridPaint = Paint()
      ..color = isDarkMode ? const Color(0x33407080) : const Color(0x33475569)
      ..strokeWidth = 1;
    final textStyle = TextStyle(
      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF475569),
      fontSize: 9,
    );

    final zeroX = toX(0);
    canvas.drawLine(
      Offset(zeroX, padT),
      Offset(zeroX, size.height - padB),
      Paint()
        ..color = isDarkMode ? const Color(0x55FFFFFF) : const Color(0x55000000)
        ..strokeWidth = 1,
    );

    // X-Ticks
    for (var i = 0; i <= 5; i++) {
      final sigVal = minSigma + (i / 5) * (maxSigma - minSigma);
      final x = toX(sigVal);
      canvas.drawLine(
        Offset(x, padT),
        Offset(x, size.height - padB),
        gridPaint,
      );

      final tpX = TextPainter(
        text: TextSpan(text: "${sigVal.toInt()} MPa", style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tpX.paint(canvas, Offset(x - tpX.width / 2, size.height - padB + 4));
    }

    // Y-Ticks
    for (var i = 0; i <= 4; i++) {
      final tauVal = (i / 4) * maxTau;
      final y = toY(tauVal);
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), gridPaint);

      final tpY = TextPainter(
        text: TextSpan(text: "${tauVal.toInt()}", style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tpY.paint(canvas, Offset(padL - tpY.width - 4, y - 5));
    }

    // 1. Calculate Exact Hoek-Brown Shear Strength Envelope tau(sigma)
    const steps = 60;
    final minSig3 = sigT;
    final maxSig3 = maxSigma * 0.5;

    final shearPath = Path();
    for (var i = 0; i <= steps; i++) {
      final sig3 = minSig3 + (i / steps) * (maxSig3 - minSig3);
      final point = calculateHoekBrownShearPoint(
        sigma3MPa: sig3,
        intactUcsMPa: sigCi,
        mb: mb,
        s: s,
        a: a,
      );
      final x = toX(point.normalStressMPa);
      final y = toY(point.shearStressMPa);

      if (i == 0)
        shearPath.moveTo(x, y);
      else
        shearPath.lineTo(x, y);
    }

    // Fill under shear curve
    final fillPath = Path.from(shearPath)
      ..lineTo(toX(maxSigma), size.height - padB)
      ..lineTo(toX(minSigma), size.height - padB)
      ..close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        LithicaColors.logoGreen.withValues(alpha: 0.25),
        LithicaColors.logoGreen.withValues(alpha: 0.0),
      ],
    );
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = fillGradient.createShader(
          Rect.fromLTWH(0, padT, size.width, plotH),
        ),
    );

    // Draw Mohr Circles
    final circleConfinements = [sigT, 0.0, maxSigma * 0.2];
    final circlePaint = Paint()
      ..color = const Color(0x6680C030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final s3 in circleConfinements) {
      final s1 = s3 + sigCi * math.pow(mb * (s3 / sigCi) + s, a);
      final centerSig = (s1 + s3) / 2;
      final radiusSig = (s1 - s3) / 2;

      final centerX = toX(centerSig.toDouble());
      final centerY = size.height - padB;
      final radiusPx = (radiusSig / (maxSigma - minSigma)) * plotW;

      if (centerX + radiusPx > padL && centerX - radiusPx < padL + plotW) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radiusPx),
          math.pi,
          math.pi,
          false,
          circlePaint,
        );

        // Mark intercepts on horizontal axis
        final sig3X = toX(s3);
        final sig1X = toX(s1.toDouble());
        canvas.drawCircle(
          Offset(sig3X, centerY),
          3,
          Paint()..color = LithicaColors.logoGreen,
        );
        canvas.drawCircle(
          Offset(sig1X, centerY),
          3,
          Paint()..color = LithicaColors.logoGreen,
        );
      }
    }

    // Draw Mohr-Coulomb Line
    final mcTan = math.tan(frictionDeg * math.pi / 180);
    final mcCohesionMPa = cohesionKPa / 1000;
    final mcPath = Path()
      ..moveTo(toX(0), toY(mcCohesionMPa))
      ..lineTo(toX(maxSigma), toY(mcCohesionMPa + maxSigma * mcTan));
    canvas.drawPath(
      mcPath,
      Paint()
        ..color = const Color(0xFFA9774D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Draw Hoek-Brown Shear Curve
    canvas.drawPath(
      shearPath,
      Paint()
        ..color = LithicaColors.logoLime
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Top Legend
    final legRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padL + 6, padT + 4, 240, 28),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      legRect,
      Paint()
        ..color = isDarkMode
            ? const Color(0xEE0B2238)
            : const Color(0xEEFFFFFF),
    );
    canvas.drawRRect(
      legRect,
      Paint()
        ..color = const Color(0x66407080)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final legText = TextPainter(
      text: TextSpan(
        text: "🟢 Círculos Mohr & Envolvente Cizalle τ(σ)",
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    legText.paint(canvas, Offset(padL + 12, padT + 12));
  }

  void _paintPrincipalPlane(Canvas canvas, Size size) {
    const padL = 50.0;
    const padR = 20.0;
    const padT = 25.0;
    const padB = 40.0;
    final plotW = size.width - padL - padR;
    final plotH = size.height - padT - padB;

    final maxSig3 = math.max(10.0, sigCi * 0.5);
    const points = 50;

    double maxSig1 = 0;
    final massPoints = <Offset>[];
    final intactPoints = <Offset>[];
    final mcPoints = <Offset>[];

    final mcCohesionMPa = cohesionKPa / 1000;
    final kMC =
        (1 + math.sin(frictionDeg * math.pi / 180)) /
        (1 - math.sin(frictionDeg * math.pi / 180));
    final sigCmMC = 2 * mcCohesionMPa * math.sqrt(kMC);

    for (var i = 0; i <= points; i++) {
      final s3 = (i / points) * maxSig3;
      final s1Mass = s3 + sigCi * math.pow(mb * (s3 / sigCi) + s, a);
      final s1Intact = s3 + sigCi * math.pow(mi * (s3 / sigCi) + 1.0, 0.5);
      final s1MC = sigCmMC + s3 * kMC;

      if (s1Intact > maxSig1) maxSig1 = s1Intact.toDouble();
      if (s1Mass > maxSig1) maxSig1 = s1Mass.toDouble();

      massPoints.add(Offset(s3, s1Mass.toDouble()));
      intactPoints.add(Offset(s3, s1Intact.toDouble()));
      mcPoints.add(Offset(s3, s1MC.toDouble()));
    }

    double toX(double s3) => padL + (s3 / maxSig3) * plotW;
    double toY(double s1) => size.height - padB - (s1 / maxSig1) * plotH;

    // Grid & Axis Ticks
    final gridPaint = Paint()
      ..color = isDarkMode ? const Color(0x33407080) : const Color(0x33475569)
      ..strokeWidth = 1;
    final textStyle = TextStyle(
      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF475569),
      fontSize: 9,
    );

    for (var i = 0; i <= 5; i++) {
      final s3 = (i / 5) * maxSig3;
      final x = toX(s3);
      canvas.drawLine(
        Offset(x, padT),
        Offset(x, size.height - padB),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: "${s3.toInt()}", style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - padB + 4));
    }

    for (var i = 0; i <= 4; i++) {
      final s1 = (i / 4) * maxSig1;
      final y = toY(s1);
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: "${s1.toInt()}", style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padL - tp.width - 4, y - 5));
    }

    // Draw Intact Curve (Dashed Teal)
    final intactPath = Path();
    for (var i = 0; i < intactPoints.length; i++) {
      final x = toX(intactPoints[i].dx);
      final y = toY(intactPoints[i].dy);
      if (i == 0)
        intactPath.moveTo(x, y);
      else
        intactPath.lineTo(x, y);
    }
    canvas.drawPath(
      intactPath,
      Paint()
        ..color = LithicaColors.rockCyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Draw Mohr-Coulomb Linear Line (Ochre)
    final mcPath = Path();
    for (var i = 0; i < mcPoints.length; i++) {
      final x = toX(mcPoints[i].dx);
      final y = toY(mcPoints[i].dy);
      if (i == 0)
        mcPath.moveTo(x, y);
      else
        mcPath.lineTo(x, y);
    }
    canvas.drawPath(
      mcPath,
      Paint()
        ..color = const Color(0xFFA9774D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Draw Rock Mass Curve (Lime)
    final massPath = Path();
    for (var i = 0; i < massPoints.length; i++) {
      final x = toX(massPoints[i].dx);
      final y = toY(massPoints[i].dy);
      if (i == 0)
        massPath.moveTo(x, y);
      else
        massPath.lineTo(x, y);
    }
    canvas.drawPath(
      massPath,
      Paint()
        ..color = LithicaColors.logoLime
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Legend
    final legRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padL + 6, padT + 4, 250, 28),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      legRect,
      Paint()
        ..color = isDarkMode
            ? const Color(0xEE0B2238)
            : const Color(0xEEFFFFFF),
    );
    canvas.drawRRect(
      legRect,
      Paint()
        ..color = const Color(0x66407080)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final legText = TextPainter(
      text: TextSpan(
        text: "🟢 Macizo (H-B) | 🟠 Mohr-Coulomb | 🔵 Roca Intacta",
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    legText.paint(canvas, Offset(padL + 10, padT + 12));
  }

  @override
  bool shouldRepaint(covariant HoekEnvelopePainter oldDelegate) =>
      oldDelegate.sigCi != sigCi ||
      oldDelegate.mb != mb ||
      oldDelegate.s != s ||
      oldDelegate.a != a ||
      oldDelegate.mi != mi ||
      oldDelegate.sigT != sigT ||
      oldDelegate.cohesionKPa != cohesionKPa ||
      oldDelegate.frictionDeg != frictionDeg ||
      oldDelegate.plotMode != plotMode ||
      oldDelegate.isDarkMode != isDarkMode;
}

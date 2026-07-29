import 'dart:math' as math;

enum HoekBrownApplication { tunnel, slope }

class HoekBrownResult {
  final double mb;
  final double s;
  final double a;
  final double rockMassStrengthMPa;
  final double deformationModulusMPa;
  final double tensileStrengthMPa;
  final double sigma3MaxMPa;
  final double cohesionMPa;
  final double frictionDeg;

  const HoekBrownResult({
    required this.mb,
    required this.s,
    required this.a,
    required this.rockMassStrengthMPa,
    required this.deformationModulusMPa,
    required this.tensileStrengthMPa,
    required this.sigma3MaxMPa,
    required this.cohesionMPa,
    required this.frictionDeg,
  });
}

class HoekBrownShearPoint {
  final double normalStressMPa;
  final double shearStressMPa;

  const HoekBrownShearPoint({
    required this.normalStressMPa,
    required this.shearStressMPa,
  });
}

class Rmr14Result {
  final double basicRmr;
  final double orientationAdjustedRmr;
  final double excavationFactor;
  final double stressFactor;
  final double totalRmr;

  const Rmr14Result({
    required this.basicRmr,
    required this.orientationAdjustedRmr,
    required this.excavationFactor,
    required this.stressFactor,
    required this.totalRmr,
  });
}

double calculateRmr14JointFrequencyRating(double jointsPerMeter) {
  if (!jointsPerMeter.isFinite || jointsPerMeter < 0) {
    throw ArgumentError(
      'La frecuencia de juntas debe ser finita y no negativa.',
    );
  }

  if (jointsPerMeter <= 20) {
    return 34.442 * math.exp(-0.046 * jointsPerMeter);
  }
  return math.max(0, 22.8 - 0.457 * jointsPerMeter);
}

int calculateRmr14AlterabilityRating(double id2Percent) {
  if (!id2Percent.isFinite || id2Percent < 0 || id2Percent > 100) {
    throw ArgumentError('Id2 debe estar entre 0 y 100 %.');
  }
  if (id2Percent > 85) return 10;
  if (id2Percent >= 60) return 8;
  if (id2Percent >= 30) return 4;
  return 0;
}

double calculateRmr14ExcavationFactor({
  required double rmr89Equivalent,
  required bool mechanicalExcavation,
}) {
  if (!rmr89Equivalent.isFinite ||
      rmr89Equivalent < 0 ||
      rmr89Equivalent > 100) {
    throw ArgumentError('El RMR equivalente debe estar entre 0 y 100.');
  }
  if (!mechanicalExcavation) return 1;

  if (rmr89Equivalent <= 40) {
    return (1 + 2 * math.pow(rmr89Equivalent / 100, 2)).toDouble();
  }
  return 1.32 - math.sqrt(rmr89Equivalent - 40) / 25;
}

double calculateRmr14StressFactor(double ice) {
  if (!ice.isFinite || ice < 0) {
    throw ArgumentError('ICE debe ser finito y no negativo.');
  }
  if (ice < 15) return 1.3;
  if (ice <= 70) {
    final root = math.sqrt(100 - ice);
    return 2.3 * root / (7.1 + root);
  }
  return 1;
}

Rmr14Result calculateRmr14({
  required int intactStrengthRating,
  required double jointsPerMeter,
  required int discontinuityConditionRating,
  required int groundwaterRating,
  required double id2Percent,
  required int orientationAdjustment,
  required bool mechanicalExcavation,
  required double ice,
}) {
  final jointFrequencyRating = calculateRmr14JointFrequencyRating(
    jointsPerMeter,
  );
  final alterabilityRating = calculateRmr14AlterabilityRating(id2Percent);
  final basicRmr =
      intactStrengthRating +
      jointFrequencyRating +
      discontinuityConditionRating +
      groundwaterRating +
      alterabilityRating;
  final orientationAdjusted = (basicRmr + orientationAdjustment).clamp(
    0.0,
    100.0,
  );

  // Celada et al. define Fe from the equivalent RMR89 value.
  final rmr89Equivalent = ((orientationAdjusted - 2) / 1.1).clamp(0.0, 100.0);
  final excavationFactor = calculateRmr14ExcavationFactor(
    rmr89Equivalent: rmr89Equivalent,
    mechanicalExcavation: mechanicalExcavation,
  );
  final stressFactor = calculateRmr14StressFactor(ice);
  final total = (orientationAdjusted * excavationFactor * stressFactor).clamp(
    0.0,
    100.0,
  );

  return Rmr14Result(
    basicRmr: basicRmr,
    orientationAdjustedRmr: orientationAdjusted,
    excavationFactor: excavationFactor,
    stressFactor: stressFactor,
    totalRmr: total,
  );
}

double calculateQ({
  required double rqd,
  required double jn,
  required double jr,
  required double ja,
  required double jw,
  required double srf,
}) {
  final values = [rqd, jn, jr, ja, jw, srf];
  if (values.any((value) => !value.isFinite || value <= 0)) {
    throw ArgumentError(
      'Todos los parametros Q deben ser finitos y mayores que cero.',
    );
  }

  final effectiveRqd = rqd.clamp(10.0, 100.0);
  return (effectiveRqd / jn) * (jr / ja) * (jw / srf);
}

double calculateQc(double q, double intactUcsMPa) {
  if (!q.isFinite || q <= 0 || !intactUcsMPa.isFinite || intactUcsMPa <= 0) {
    throw ArgumentError('Q y sigma ci deben ser finitos y mayores que cero.');
  }
  return q * intactUcsMPa / 100.0;
}

bool requiresConservativeEsr({
  required double q,
  required String excavationType,
}) {
  const ngiTypesBToD = {
    'shaft_circular',
    'shaft_rectangular',
    'perm_mine',
    'minor_tunnel',
  };
  return q <= 0.1 && ngiTypesBToD.contains(excavationType);
}

double calculateDesignEsr({
  required double q,
  required String excavationType,
  required double selectedEsr,
}) {
  if (!q.isFinite || q <= 0 || !selectedEsr.isFinite || selectedEsr <= 0) {
    throw ArgumentError('Q y ESR deben ser finitos y mayores que cero.');
  }
  return requiresConservativeEsr(q: q, excavationType: excavationType)
      ? 1.0
      : selectedEsr;
}

HoekBrownResult calculateHoekBrown({
  required double intactUcsMPa,
  required double mi,
  required double gsi,
  required double disturbance,
  required HoekBrownApplication application,
  required double depthOrHeightM,
  required double unitWeightMNPerM3,
}) {
  if (!intactUcsMPa.isFinite || intactUcsMPa <= 0) {
    throw ArgumentError('sigma ci debe ser mayor que cero.');
  }
  if (!mi.isFinite || mi <= 0) {
    throw ArgumentError('mi debe ser mayor que cero.');
  }
  if (!gsi.isFinite || gsi < 0 || gsi > 100) {
    throw ArgumentError('GSI debe estar entre 0 y 100.');
  }
  if (!disturbance.isFinite || disturbance < 0 || disturbance > 1) {
    throw ArgumentError('D debe estar entre 0 y 1.');
  }
  if (!depthOrHeightM.isFinite || depthOrHeightM <= 0) {
    throw ArgumentError('La profundidad o altura debe ser mayor que cero.');
  }
  if (!unitWeightMNPerM3.isFinite || unitWeightMNPerM3 <= 0) {
    throw ArgumentError('El peso unitario debe ser mayor que cero.');
  }

  final mb = mi * math.exp((gsi - 100) / (28 - 14 * disturbance));
  final s = math.exp((gsi - 100) / (9 - 3 * disturbance));
  final a = 0.5 + (math.exp(-gsi / 15) - math.exp(-20 / 3)) / 6;

  final strengthTerm =
      (mb + 4 * s - a * (mb - 8 * s)) * math.pow(mb / 4 + s, a - 1);
  final rockMassStrength =
      intactUcsMPa * strengthTerm / (2 * (1 + a) * (2 + a));

  final deformationModulusGPa = intactUcsMPa <= 100
      ? (1 - disturbance / 2) *
            math.sqrt(intactUcsMPa / 100) *
            math.pow(10, (gsi - 10) / 40)
      : (1 - disturbance / 2) * math.pow(10, (gsi - 10) / 40);

  final overburdenStress = unitWeightMNPerM3 * depthOrHeightM;
  final strengthStressRatio = rockMassStrength / overburdenStress;
  final sigma3Max = application == HoekBrownApplication.tunnel
      ? rockMassStrength * 0.47 * math.pow(strengthStressRatio, -0.94)
      : rockMassStrength * 0.72 * math.pow(strengthStressRatio, -0.91);

  final sigma3n = sigma3Max / intactUcsMPa;
  final term = s + mb * sigma3n;
  final termPow = math.pow(term, a - 1);
  final common = 6 * a * mb * termPow;
  final denominatorBase = (1 + a) * (2 + a);
  final sinPhi = common / (2 * denominatorBase + common);
  final frictionDeg = math.asin(sinPhi.clamp(-1.0, 1.0)) * 180 / math.pi;
  final cohesion =
      intactUcsMPa *
      ((1 + 2 * a) * s + (1 - a) * mb * sigma3n) *
      termPow /
      (denominatorBase * math.sqrt(1 + common / denominatorBase));

  return HoekBrownResult(
    mb: mb,
    s: s,
    a: a,
    rockMassStrengthMPa: rockMassStrength,
    deformationModulusMPa: deformationModulusGPa * 1000,
    tensileStrengthMPa: -(s * intactUcsMPa) / mb,
    sigma3MaxMPa: sigma3Max,
    cohesionMPa: cohesion,
    frictionDeg: frictionDeg,
  );
}

HoekBrownShearPoint calculateHoekBrownShearPoint({
  required double sigma3MPa,
  required double intactUcsMPa,
  required double mb,
  required double s,
  required double a,
}) {
  final base = mb * sigma3MPa / intactUcsMPa + s;
  if (base < 0) {
    throw ArgumentError('sigma 3 esta fuera del dominio Hoek-Brown.');
  }
  if (base == 0) {
    return HoekBrownShearPoint(normalStressMPa: sigma3MPa, shearStressMPa: 0);
  }

  final sigma1 = sigma3MPa + intactUcsMPa * math.pow(base, a);
  final derivative = 1 + a * mb * math.pow(base, a - 1);
  final delta = sigma1 - sigma3MPa;

  return HoekBrownShearPoint(
    normalStressMPa: sigma3MPa + delta / (1 + derivative),
    shearStressMPa: delta * math.sqrt(derivative) / (1 + derivative),
  );
}

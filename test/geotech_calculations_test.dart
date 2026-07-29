import 'package:flutter_test/flutter_test.dart';
import 'package:lithica_geotech/src/domain/geotech_calculations.dart';
import 'package:lithica_geotech/src/domain/q_version_data.dart';
import 'package:lithica_geotech/src/domain/rmr_version_data.dart';

void main() {
  group('Q-system', () {
    test('calcula el ejemplo base sin alterar Q por Qc', () {
      final q = calculateQ(rqd: 80, jn: 9, jr: 3, ja: 1, jw: 1, srf: 1);
      expect(q, closeTo(26.6666667, 1e-6));
      expect(calculateQc(q, 50), closeTo(13.3333333, 1e-6));
    });

    test('usa RQD 10 cuando el valor observado es menor', () {
      final q = calculateQ(rqd: 2, jn: 2, jr: 1, ja: 1, jw: 1, srf: 1);
      expect(q, 5);
    });

    test('incluye la tabla ESR NGI completa hasta 0.5', () {
      final permanent = Q_ESR_PRESETS.firstWhere(
        (preset) => preset.key == 'perm_mine',
      );
      final veryImportant = Q_ESR_PRESETS.firstWhere(
        (preset) => preset.key == 'very_important',
      );

      expect(permanent.defaultEsr, 1.6);
      expect(permanent.minEsr, 1.6);
      expect(permanent.maxEsr, 1.6);
      expect(veryImportant.defaultEsr, 0.5);
    });

    test('aplica ESR 1.0 para Q bajo en tipos NGI B a D', () {
      expect(
        calculateDesignEsr(
          q: 0.05,
          excavationType: 'perm_mine',
          selectedEsr: 1.6,
        ),
        1.0,
      );
      expect(
        calculateDesignEsr(
          q: 0.05,
          excavationType: 'very_important',
          selectedEsr: 0.5,
        ),
        0.5,
      );
    });
  });

  group('RMR', () {
    test('RMR76 conserva un maximo basico de 100', () {
      final definition = RMR_VERSION_DEFINITIONS['rmr76']!;
      final maximum =
          definition.p1UcsOptions.first.score +
          20 +
          definition.p3SpacingOptions.first.score +
          definition.p4ConditionOptions.first.score +
          definition.p5WaterOptions.first.score;
      expect(maximum, 100);
    });

    test('RMR14 usa frecuencia de juntas y alterabilidad propias', () {
      expect(calculateRmr14JointFrequencyRating(0), closeTo(34.442, 1e-6));
      expect(calculateRmr14JointFrequencyRating(10), closeTo(21.7426713, 1e-6));
      expect(calculateRmr14AlterabilityRating(90), 10);
      expect(calculateRmr14AlterabilityRating(50), 4);
    });

    test('RMR14 aplica F0, Fe y Fs sin sustituirlo por RMR89', () {
      final result = calculateRmr14(
        intactStrengthRating: 15,
        jointsPerMeter: 0,
        discontinuityConditionRating: 20,
        groundwaterRating: 15,
        id2Percent: 90,
        orientationAdjustment: 0,
        mechanicalExcavation: false,
        ice: 80,
      );
      expect(result.basicRmr, closeTo(94.442, 1e-6));
      expect(result.excavationFactor, 1);
      expect(result.stressFactor, 1);
      expect(result.totalRmr, closeTo(94.442, 1e-6));
    });
  });

  group('Hoek-Brown 2002', () {
    final result = calculateHoekBrown(
      intactUcsMPa: 80,
      mi: 15,
      gsi: 55,
      disturbance: 0.6,
      application: HoekBrownApplication.tunnel,
      depthOrHeightM: 100,
      unitWeightMNPerM3: 0.027,
    );

    test('calcula parametros de macizo y confinamiento para tunel', () {
      expect(result.mb, closeTo(1.5100335, 1e-6));
      expect(result.s, closeTo(0.00193045, 1e-8));
      expect(result.a, closeTo(0.50404815, 1e-8));
      expect(result.rockMassStrengthMPa, closeTo(13.1282666, 1e-5));
      expect(result.sigma3MaxMPa, closeTo(1.3953149, 1e-5));
      expect(result.cohesionMPa, closeTo(0.7407477, 1e-5));
      expect(result.frictionDeg, closeTo(51.2999826, 1e-5));
    });

    test('transforma correctamente a esfuerzos normal y cortante', () {
      final point = calculateHoekBrownShearPoint(
        sigma3MPa: 0,
        intactUcsMPa: 80,
        mb: result.mb,
        s: result.s,
        a: result.a,
      );
      expect(point.normalStressMPa, closeTo(0.1814219, 1e-6));
      expect(point.shearStressMPa, closeTo(0.7673618, 1e-6));
    });

    test('rechaza parametros no fisicos', () {
      expect(
        () => calculateHoekBrown(
          intactUcsMPa: 0,
          mi: 15,
          gsi: 55,
          disturbance: 0.6,
          application: HoekBrownApplication.tunnel,
          depthOrHeightM: 100,
          unitWeightMNPerM3: 0.027,
        ),
        throwsArgumentError,
      );
    });
  });
}

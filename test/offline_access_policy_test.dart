import 'package:flutter_test/flutter_test.dart';
import 'package:lithica_geotech/src/application/auth_access_controller.dart';

void main() {
  final now = DateTime.utc(2026, 7, 26, 12);

  test('permite al mismo usuario durante los siete días offline', () {
    expect(
      OfflineAccessPolicy.allows(
        currentEmail: 'usuario@ejemplo.com',
        savedEmail: 'USUARIO@ejemplo.com',
        lastVerifiedAt: now.subtract(const Duration(days: 6, hours: 23)),
        now: now,
      ),
      isTrue,
    );
  });

  test('bloquea cuando han transcurrido más de siete días', () {
    expect(
      OfflineAccessPolicy.allows(
        currentEmail: 'usuario@ejemplo.com',
        savedEmail: 'usuario@ejemplo.com',
        lastVerifiedAt: now.subtract(
          const Duration(days: 7, seconds: 1),
        ),
        now: now,
      ),
      isFalse,
    );
  });

  test('bloquea si la identidad local no coincide', () {
    expect(
      OfflineAccessPolicy.allows(
        currentEmail: 'otro@ejemplo.com',
        savedEmail: 'usuario@ejemplo.com',
        lastVerifiedAt: now.subtract(const Duration(days: 1)),
        now: now,
      ),
      isFalse,
    );
  });

  test('bloquea una fecha futura incompatible con el reloj', () {
    expect(
      OfflineAccessPolicy.allows(
        currentEmail: 'usuario@ejemplo.com',
        savedEmail: 'usuario@ejemplo.com',
        lastVerifiedAt: now.add(const Duration(minutes: 6)),
        now: now,
      ),
      isFalse,
    );
  });
}

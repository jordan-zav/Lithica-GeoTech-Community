import 'package:flutter_test/flutter_test.dart';
import 'package:lithica_geotech/src/config/legal_resources.dart';

void main() {
  test('la solicitud de eliminación identifica la cuenta', () {
    final uri = accountDeletionRequestUri('USUARIO@Ejemplo.com');

    expect(uri.scheme, 'mailto');
    expect(uri.path, lithicaPrivacyContactEmail);
    expect(uri.queryParameters['subject'], contains('eliminación de cuenta'));
    expect(uri.queryParameters['body'], contains('usuario@ejemplo.com'));
  });

  test('las páginas legales usan recursos web públicos', () {
    expect(Uri.parse(lithicaPrivacyPolicyUrl).scheme, 'https');
    expect(Uri.parse(lithicaAccountDeletionUrl).scheme, 'https');
  });
}

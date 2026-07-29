const lithicaPrivacyPolicyUrl =
    'https://gisgeo.dev/lithica-geotech-privacy.html';
const lithicaAccountDeletionUrl =
    'https://gisgeo.dev/lithica-geotech-account-deletion.html';
const lithicaPrivacyContactEmail = 'jordanzav@gisgeo.dev';

Uri accountDeletionRequestUri(String? accountEmail) {
  final normalizedEmail = accountEmail?.trim().toLowerCase();
  final identifiedAccount = normalizedEmail == null || normalizedEmail.isEmpty
      ? 'No identificada; indicar el correo usado en Lithica GeoTech'
      : normalizedEmail;

  return Uri(
    scheme: 'mailto',
    path: lithicaPrivacyContactEmail,
    queryParameters: {
      'subject': 'Solicitud de eliminación de cuenta - Lithica GeoTech',
      'body':
          'Solicito la eliminación permanente de mi cuenta de Lithica '
          'GeoTech y de los datos asociados.\n\n'
          'Cuenta: $identifiedAccount\n\n'
          'Entiendo que GisGeo Dev puede responder a este correo para '
          'verificar mi identidad antes de completar la eliminación.',
    },
  );
}

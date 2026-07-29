import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../application/auth_access_controller.dart';
import '../application/geotech_controller.dart';
import '../config/build_info.dart';
import '../config/legal_resources.dart';
import '../data/geotech_kb.dart';
import '../theme/lithica_theme.dart';

final _koFiUri = Uri.parse('https://ko-fi.com/O8I721TAM6');
final _websiteUri = Uri.parse('https://gisgeo.dev');
final _privacyPolicyUri = Uri.parse(lithicaPrivacyPolicyUrl);
final _emailUri = Uri(
  scheme: 'mailto',
  path: 'jordanzav@gisgeo.dev',
  queryParameters: {'subject': 'Lithica GeoTech'},
);

class GeotechSettingsDialog extends StatelessWidget {
  const GeotechSettingsDialog({
    super.key,
    required this.controller,
    this.authController,
  });

  final GeotechController controller;
  final AuthAccessController? authController;

  @override
  Widget build(BuildContext context) {
    final materialCount = EXPANDED_GEOTECH_MATERIALS.length;
    final isrmCount = EXPANDED_ISRM_STANDARDS.length;
    final blueCount = EXPANDED_ISRM_STANDARDS
        .where((standard) => standard.book == 'blue')
        .length;
    final orangeCount = isrmCount - blueCount;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF102A43) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: 720,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              children: [
                // Modal Header Banner (Lithica Atlas style)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LithicaColors.logoNavyDeep,
                        LithicaColors.logoTeal,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Configuraciones",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Personaliza la interfaz, escala y preferencias globales de Lithica GeoTech",
                              style: TextStyle(
                                color: Color(0xFFDCE9EA),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        tooltip: "Cerrar",
                      ),
                    ],
                  ),
                ),

                // Settings Body Scrollable Cards
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (authController != null) ...[
                        _AuthSettingsCard(controller: authController!),
                        const SizedBox(height: 16),
                      ],
                      // 1. Language Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.language_rounded,
                        title: "Idioma de la Interfaz",
                        subtitle:
                            "Selecciona el idioma de visualización de la plataforma",
                        child: SegmentedButton<String>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: 'es',
                              icon: Icon(Icons.language_rounded, size: 18),
                              label: Text('Español'),
                            ),
                            ButtonSegment(
                              value: 'en',
                              icon: Icon(Icons.translate_rounded, size: 18),
                              label: Text('English'),
                            ),
                          ],
                          selected: {controller.languageCode},
                          onSelectionChanged: (val) =>
                              controller.setLanguage(val.first),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Theme Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.palette_outlined,
                        title: "Tema Visual",
                        subtitle:
                            "Elige la apariencia visual o sincroniza con el sistema operativo",
                        child: SegmentedButton<ThemeMode>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: Icon(
                                Icons.brightness_auto_rounded,
                                size: 18,
                              ),
                              label: Text('Sistema (Auto)'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: Icon(Icons.light_mode_rounded, size: 18),
                              label: Text('Modo Claro'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: Icon(Icons.dark_mode_rounded, size: 18),
                              label: Text('Modo Oscuro'),
                            ),
                          ],
                          selected: {controller.themeMode},
                          onSelectionChanged: (val) =>
                              controller.setThemeMode(val.first),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. GUI Scale Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.text_fields_rounded,
                        title: "Escala de la Interfaz (GUI)",
                        subtitle:
                            "Ajusta el tamaño global de los elementos y tipografías",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${(controller.guiScale * 100).round()}%",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? LithicaColors.logoLime
                                        : LithicaColors.logoNavyDeep,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: controller.guiScale == 1.0
                                      ? null
                                      : () => controller.setGuiScale(1.0),
                                  icon: const Icon(
                                    Icons.restart_alt_rounded,
                                    size: 18,
                                  ),
                                  label: const Text("Restablecer Escala"),
                                ),
                              ],
                            ),
                            Slider(
                              min: 0.8,
                              max: 1.4,
                              divisions: 6,
                              value: controller.guiScale,
                              label: "${(controller.guiScale * 100).round()}%",
                              activeColor: LithicaColors.logoGreen,
                              onChanged: controller.setGuiScale,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Knowledge Base Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.storage_rounded,
                        title: "Base de Conocimiento",
                        subtitle:
                            "Cobertura real de materiales y métodos bibliográficos disponibles",
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            const Chip(
                              avatar: Icon(
                                Icons.check_circle_outline,
                                color: LithicaColors.logoGreen,
                                size: 18,
                              ),
                              label: Text(
                                "Base local operativa ($lithicaVersionLabel)",
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.landscape_outlined,
                                color: LithicaColors.rockCyan,
                                size: 18,
                              ),
                              label: Text(
                                "$materialCount materiales geotécnicos",
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.menu_book_outlined,
                                color: LithicaColors.diagramBlue,
                                size: 18,
                              ),
                              label: Text(
                                "$isrmCount métodos ISRM "
                                "($blueCount Blue · $orangeCount Orange)",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 5. Support Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.local_cafe_outlined,
                        title: "Apoya el Desarrollo",
                        subtitle:
                            "Lithica GeoTech es parte de la suite abierta de herramientas geocientíficas",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: isDark
                                    ? LithicaColors.logoGreen
                                    : const Color(0xFF0A4CBF),
                                foregroundColor: isDark
                                    ? LithicaColors.logoNavyDeep
                                    : Colors.white,
                                padding: const EdgeInsets.all(14),
                              ),
                              onPressed: () => _openExternal(context, _koFiUri),
                              icon: const Icon(Icons.favorite_border_rounded),
                              label: const Text(
                                "Invítanos un Café en Ko-Fi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tu contribución ayuda a financiar la investigación geotécnica y el desarrollo continuado.",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 6. Contact & About Card
                      _buildSettingsCard(
                        context: context,
                        icon: Icons.info_outline_rounded,
                        title: "Acerca de Lithica GeoTech & Licencias",
                        subtitle:
                            "Información del sistema, desarrollador y créditos científicos",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Versión de Plataforma:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  lithicaVersionLabel,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Desarrollador:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Jordan Zavaleta · GisGeo Dev",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _showAttributionsDialog(context),
                                  icon: const Icon(
                                    Icons.verified_outlined,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Atribuciones Científicas e ISRM",
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _openExternal(context, _emailUri),
                                  icon: const Icon(
                                    Icons.mail_outline_rounded,
                                    size: 18,
                                  ),
                                  label: const Text("Enviar Correo"),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _openExternal(context, _websiteUri),
                                  icon: const Icon(
                                    Icons.public_rounded,
                                    size: 18,
                                  ),
                                  label: const Text("Visitar Sitio Web"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF2F4F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LithicaColors.logoTeal.withValues(alpha: isDark ? 0.3 : 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: LithicaColors.logoGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: LithicaColors.logoGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  static Future<void> _openExternal(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $uri')),
      );
    }
  }

  void _showAttributionsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF102A43) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: LithicaColors.logoLime),
            SizedBox(width: 10),
            Text(
              "Atribuciones & Créditos Científicos",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lithica GeoTech integra las metodologías geotécnicas y ecuaciones empíricas estándar de las siguientes fuentes científicas de referencia:",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 14),
                _AttributionItem(
                  author:
                      "ISRM (International Society for Rock Mechanics and Rock Engineering)",
                  year: "1981, 2007, 2014",
                  title:
                      "Suggested Methods for Rock Characterization, Testing and Monitoring (Blue, Orange & Gold Books)",
                ),
                _AttributionItem(
                  author: "Bieniawski, Z. T.",
                  year: "1989",
                  title:
                      "Engineering Rock Mass Classifications: Rock Mass Rating (RMR) System & Design Rules",
                ),
                _AttributionItem(
                  author: "Barton, N., Lien, R. & Lunde, J. / Barton, N.",
                  year: "1974, 2002, 2015",
                  title:
                      "NGI Rock Mass Quality Q-System & Underground Excavation Support Charts",
                ),
                _AttributionItem(
                  author:
                      "Hoek, E., Carranza-Torres, C. & Corkum, B. / Hoek, E. & Brown, E. T.",
                  year: "2002, 2018",
                  title:
                      "Hoek-Brown Failure Criterion & RocScience Mohr-Coulomb Equivalent Formulations",
                ),
                _AttributionItem(
                  author: "Marinos, P. & Hoek, E.",
                  year: "2000",
                  title:
                      "Geological Strength Index (GSI) Charts for Jointed & Weak Rock Masses",
                ),
                _AttributionItem(
                  author: "Deere, D. U.",
                  year: "1964",
                  title:
                      "Rock Quality Designation (RQD) Index for Core Recovery Logging",
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Entendido",
              style: TextStyle(
                color: LithicaColors.logoLime,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthSettingsCard extends StatelessWidget {
  const _AuthSettingsCard({required this.controller});

  final AuthAccessController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final online = controller.status == AuthAccessStatus.authorizedOnline;
        final remaining = controller.offlineRemaining;
        final verified = controller.lastVerifiedAt?.toLocal();

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF2F4F1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: LithicaColors.logoTeal.withValues(
                alpha: isDark ? 0.3 : 0.15,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: LithicaColors.logoGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      online ? Icons.verified_user : Icons.offline_bolt,
                      color: LithicaColors.logoGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Identificación y acceso',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          online
                              ? 'Autorización verificada en línea'
                              : 'Autorización offline temporal',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SelectableText(
                controller.email ?? 'Sin correo identificado',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (verified != null) ...[
                const SizedBox(height: 5),
                Text(
                  'Última validación: ${_dateTimeLabel(verified)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
              if (!online && remaining != null) ...[
                const SizedBox(height: 5),
                Text(
                  'Acceso offline restante: ${_durationLabel(remaining)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    key: const ValueKey('privacy_policy_button'),
                    onPressed: () => _showPrivacyPolicy(context),
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: const Text('Política de privacidad'),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('account_deletion_button'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => _confirmAccountDeletionRequest(context),
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Solicitar eliminación de cuenta'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await controller.signOut();
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Cerrar sesión'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Las solicitudes de eliminación se verifican por correo y se '
                'atienden manualmente en un plazo máximo de 30 días.',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPrivacyPolicy(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Política de privacidad'),
        content: const SizedBox(
          width: 620,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lithica GeoTech · GisGeo Dev\n'
                  'Última actualización: 28 de julio de 2026',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 14),
                Text(
                  'Datos tratados',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'La aplicación utiliza Google y Firebase Authentication. '
                  'Puede tratar el correo, el identificador de usuario, el '
                  'estado y rol de acceso, fechas de creación y último uso, '
                  'versión, compilación, plataforma, contador de sesiones y '
                  'día de actividad. En el dispositivo conserva preferencias '
                  'y la última verificación para el acceso sin conexión.',
                ),
                SizedBox(height: 12),
                Text(
                  'Finalidad y proveedores',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Los datos se usan para autenticar, controlar y proteger el '
                  'acceso, permitir el uso temporal sin conexión y mantener '
                  'la compatibilidad operativa. Google y Firebase prestan la '
                  'infraestructura. Los datos no se venden ni se usan para '
                  'publicidad.',
                ),
                SizedBox(height: 12),
                Text(
                  'Seguridad, conservación y eliminación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Las comunicaciones se realizan mediante conexiones '
                  'cifradas. Los datos se conservan mientras la cuenta esté '
                  'activa o sean necesarios para estas finalidades. Puedes '
                  'solicitar su eliminación desde esta pantalla. GisGeo Dev '
                  'verificará la identidad por correo y eliminará Firebase '
                  'Authentication y los datos asociados en un plazo máximo '
                  'de 30 días, salvo una obligación legal o de seguridad.',
                ),
                SizedBox(height: 12),
                Text(
                  'Contacto: jordanzav@gisgeo.dev',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => GeotechSettingsDialog._openExternal(
              dialogContext,
              _privacyPolicyUri,
            ),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Ver política completa en la web'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAccountDeletionRequest(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Solicitar eliminación de cuenta'),
        content: Text(
          'Se abrirá tu aplicación de correo para enviar una solicitud a '
          '$lithicaPrivacyContactEmail.\n\n'
          'Tras verificar que escribes desde la cuenta '
          '${controller.email ?? 'usada en Lithica GeoTech'}, GisGeo Dev '
          'eliminará la cuenta de autenticación y los datos asociados. '
          'El proceso puede tardar hasta 30 días.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('Preparar correo'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await GeotechSettingsDialog._openExternal(
        context,
        accountDeletionRequestUri(controller.email),
      );
    }
  }

  static String _dateTimeLabel(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} '
        '${two(value.hour)}:${two(value.minute)}';
  }

  static String _durationLabel(Duration value) {
    final days = value.inDays;
    final hours = value.inHours.remainder(24);
    return '$days d ${hours.toString().padLeft(2, '0')} h';
  }
}

class _AttributionItem extends StatelessWidget {
  final String author;
  final String year;
  final String title;

  const _AttributionItem({
    required this.author,
    required this.year,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF2F4F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: LithicaColors.logoTeal.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: LithicaColors.logoLime,
                    ),
                  ),
                ),
                Text(
                  year,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: LithicaColors.rockCyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? const Color(0xFFDCE9EA)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

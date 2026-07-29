import 'package:flutter/material.dart';
import '../domain/geotech_calculations.dart';
import '../domain/q_version_data.dart';
import '../theme/lithica_theme.dart';
import '../widgets/q_support_painter.dart';
import '../widgets/responsive_page_scroll.dart';

class QSystemPage extends StatefulWidget {
  const QSystemPage({super.key, required this.isExpertMode});

  final bool isExpertMode;

  @override
  State<QSystemPage> createState() => _QSystemPageState();
}

class _QSystemPageState extends State<QSystemPage> {
  // Q parameters
  double _rqd = 80;
  double _jn = 9.0;
  double _jr = 3.0;
  double _ja = 1.0;
  double _jw = 1.0;
  double _srf = 1.0;
  double _sigCi = 100.0; // For Qc calculation in Barton 2002

  // Version and Excavation parameters
  String _versionKey = 'grimstad1993';
  String _esrPresetKey = 'perm_mine';
  double _esr = 1.6;
  double _span = 10.0;
  late final TextEditingController _esrController;

  @override
  void initState() {
    super.initState();
    _esrController = TextEditingController(text: _esr.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _esrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final currentVersion =
        Q_VERSION_DEFINITIONS[_versionKey] ??
        Q_VERSION_DEFINITIONS['grimstad1993']!;
    final currentEsrPreset = Q_ESR_PRESETS.firstWhere(
      (preset) => preset.key == _esrPresetKey,
      orElse: () =>
          Q_ESR_PRESETS.firstWhere((preset) => preset.key == 'perm_mine'),
    );

    final rawQ = calculateQ(
      rqd: _rqd,
      jn: _jn,
      jr: _jr,
      ja: _ja,
      jw: _jw,
      srf: _srf,
    ).clamp(0.001, 1000.0).toDouble();
    final qc = calculateQc(rawQ, _sigCi);
    final effectiveQ = rawQ;

    final conservativeEsrRequired = requiresConservativeEsr(
      q: rawQ,
      excavationType: _esrPresetKey,
    );
    final designEsr = calculateDesignEsr(
      q: rawQ,
      excavationType: _esrPresetKey,
      selectedEsr: _esr,
    );
    final de = (_span / designEsr);
    final qStr = rawQ.toStringAsFixed(3);
    final qcStr = qc.toStringAsFixed(3);
    final deStr = de.toStringAsFixed(2);
    final estimatedBoltLength = (2.0 + 0.15 * _span) / designEsr;

    final blockSize = (_rqd / _jn);
    final jointFriction = (_jr / _ja);
    final activeStress = (_jw / _srf);

    final activeZone = getBartonZone(effectiveQ, de);

    final page = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isPortrait
                      ? MediaQuery.sizeOf(context).width - 40
                      : 600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Clasificación Q-System de Barton et al.",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : LithicaColors.logoNavyDeep,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Motor geotécnico versionado: Trazabilidad bibliográfica, carta $qStr vs De=${deStr}m y recomendación de soporte.",
                      style: TextStyle(
                        color: isDark
                            ? LithicaColors.rockCyan
                            : const Color(0xFF1B7A7A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  widget.isExpertMode
                      ? "Modo Experto Activo"
                      : "Modo Ingeniero",
                ),
                backgroundColor: widget.isExpertMode
                    ? LithicaColors.alterationPurple.withValues(alpha: 0.25)
                    : LithicaColors.logoGreen.withValues(alpha: 0.2),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ResponsiveFlexChild(
            expand: !isPortrait,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // The result belongs beside the inputs whenever there is enough
                // real content width. Window orientation is not a reliable proxy
                // on desktop because the navigation rail reduces the page width.
                final showResultAtRight = constraints.maxWidth >= 760;

                final formCard = Card(
                  key: const ValueKey('q_form_card'),
                  child: OptionalVerticalScroll(
                    enabled: !isPortrait,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. Versión del Método Q-System",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? LithicaColors.logoLime
                                : const Color(0xFF255C0E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          key: const ValueKey('q_version_selector'),
                          initialValue: _versionKey,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: Q_VERSION_DEFINITIONS.values.map((ver) {
                            return DropdownMenuItem<String>(
                              value: ver.key,
                              child: Text(
                                ver.name,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _versionKey = val);
                          },
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B2238)
                                : const Color(0xFFF2F6F0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: LithicaColors.logoTeal.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.menu_book,
                                size: 16,
                                color: LithicaColors.logoTeal,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${currentVersion.author} (${currentVersion.year}) — ${currentVersion.publication}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? const Color(0xFF9CA3AF)
                                        : const Color(0xFF64748B),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          "2. Geometría y Criterio de Excavación (ESR)",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? LithicaColors.logoLime
                                : const Color(0xFF255C0E),
                          ),
                        ),
                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          key: const ValueKey("q_esr_preset"),
                          initialValue: _esrPresetKey,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          decoration: const InputDecoration(
                            labelText: "Tipo de Excavación",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: Q_ESR_PRESETS.map((preset) {
                            return DropdownMenuItem<String>(
                              value: preset.key,
                              child: Text(
                                preset.minEsr == preset.maxEsr
                                    ? "${preset.label} (ESR ${_formatEsr(preset.defaultEsr)})"
                                    : "${preset.label} (ESR ${_formatEsr(preset.minEsr)}-${_formatEsr(preset.maxEsr)})",
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              final sel = Q_ESR_PRESETS.firstWhere(
                                (p) => p.key == val,
                              );
                              setState(() {
                                _esrPresetKey = val;
                                _esr = sel.defaultEsr;
                                _esrController.text = _formatEsr(_esr);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            const Text(
                              "Ancho / Span de la excavación (m)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${_span.toStringAsFixed(1)} m",
                              style: TextStyle(
                                color: isDark
                                    ? LithicaColors.logoLime
                                    : const Color(0xFF255C0E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _span,
                          min: 2.0,
                          max: 40.0,
                          divisions: 76,
                          onChanged: (val) => setState(() => _span = val),
                        ),
                        Text(
                          "Dimensión geométrica real de la abertura.",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Factor ESR (adimensional)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: TextFormField(
                                key: const ValueKey("q_esr_field"),
                                controller: _esrController,
                                decoration: const InputDecoration(
                                  labelText: "ESR",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                onChanged: (val) {
                                  final parsed = double.tryParse(
                                    val.replaceAll(',', '.'),
                                  );
                                  if (parsed != null && parsed > 0) {
                                    setState(() => _esr = parsed);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${currentEsrPreset.description}. El ESR representa el uso y nivel de seguridad; no es una dimensión.",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        if (currentEsrPreset.minEsr < currentEsrPreset.maxEsr)
                          Slider(
                            value: _esr.clamp(
                              currentEsrPreset.minEsr,
                              currentEsrPreset.maxEsr,
                            ),
                            min: currentEsrPreset.minEsr,
                            max: currentEsrPreset.maxEsr,
                            divisions:
                                ((currentEsrPreset.maxEsr -
                                            currentEsrPreset.minEsr) *
                                        10)
                                    .round(),
                            onChanged: (val) {
                              setState(() {
                                _esr = val;
                                _esrController.text = _formatEsr(val);
                              });
                            },
                          ),
                        if (conservativeEsrRequired) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: LithicaColors.textureOchre.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: LithicaColors.textureOchre.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Criterio NGI: para Q ≤ 0.1 en excavaciones B, C y D se adopta ESR = 1.0 en el diseño por la severidad potencial de la inestabilidad.",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        Text(
                          "3. Parámetros Geotécnicos del Macizo",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? LithicaColors.logoLime
                                : const Color(0xFF255C0E),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // RQD Slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "RQD (%)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${_rqd.toInt()}%",
                              style: TextStyle(
                                color: isDark
                                    ? LithicaColors.logoLime
                                    : const Color(0xFF255C0E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _rqd,
                          min: 10,
                          max: 100,
                          onChanged: (val) => setState(() => _rqd = val),
                        ),
                        const SizedBox(height: 8),

                        // Jn Dropdown
                        const Text(
                          "Jn - Familias de Juntas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        DropdownButtonFormField<double>(
                          initialValue: _jn,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 0.5,
                              child: Text(
                                "Masivo, sin juntas (Jn = 0.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 1.0,
                              child: Text(
                                "Masivo, pocas juntas (Jn = 1.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2.0,
                              child: Text(
                                "1 familia de juntas (Jn = 2.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3.0,
                              child: Text(
                                "1 familia + juntas aleatorias (Jn = 3.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 4.0,
                              child: Text(
                                "2 familias de juntas (Jn = 4.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 6.0,
                              child: Text(
                                "2 familias + juntas ocasionales (Jn = 6.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 9.0,
                              child: Text(
                                "3 familias de juntas (Jn = 9.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 12.0,
                              child: Text(
                                "3 familias + juntas ocasionales (Jn = 12.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 15.0,
                              child: Text(
                                "4 familias o más / Muy fracturada (Jn = 15.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 20.0,
                              child: Text(
                                "Roca totalmente desintegrada (Jn = 20.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _jn = val!),
                        ),
                        const SizedBox(height: 10),

                        // Jr Dropdown
                        const Text(
                          "Jr - Rugosidad de Juntas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        DropdownButtonFormField<double>(
                          initialValue: _jr,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 4.0,
                              child: Text(
                                "Juntas discontinuas (Jr = 4.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3.0,
                              child: Text(
                                "Rugosa u ondulada (Jr = 3.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2.0,
                              child: Text(
                                "Lisa u ondulada (Jr = 2.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 1.5,
                              child: Text(
                                "Plana rugosa (Jr = 1.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 1.0,
                              child: Text(
                                "Lisa y plana (Jr = 1.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.5,
                              child: Text(
                                "Plana pulida con lineación favorable al deslizamiento (Jr = 0.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _jr = val!),
                        ),
                        const SizedBox(height: 10),

                        // Ja Dropdown
                        const Text(
                          "Ja - Alteración de Juntas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        DropdownButtonFormField<double>(
                          initialValue: _ja,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 0.75,
                              child: Text(
                                "Sana / Contacto roca-roca (Ja = 0.75)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 1.0,
                              child: Text(
                                "Pátinas alteradas / Inalterada (Ja = 1.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2.0,
                              child: Text(
                                "Ligeramente alterada / Minerales suaves (Ja = 2.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3.0,
                              child: Text(
                                "Pátinas arcillosas (Ja = 3.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 4.0,
                              child: Text(
                                "Relleno de limo/arena < 5mm (Ja = 4.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 6.0,
                              child: Text(
                                "Relleno arcilla continua < 5mm (Ja = 6.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 8.0,
                              child: Text(
                                "Relleno arcilloso con contacto después de corte (Ja = 8.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 10.0,
                              child: Text(
                                "Relleno grueso de arcilla sobreconsolidada (Ja = 10.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 13.0,
                              child: Text(
                                "Relleno grueso de arcilla blanda (Ja = 13.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 20.0,
                              child: Text(
                                "Relleno grueso expansivo, sin contacto (Ja = 20.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _ja = val!),
                        ),
                        const SizedBox(height: 10),

                        // Jw Dropdown
                        const Text(
                          "Jw - Factor de Agua en Juntas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        DropdownButtonFormField<double>(
                          initialValue: _jw,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 1.0,
                              child: Text(
                                "Excavación seca / Flujo menor < 5 L/min (Jw = 1.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.66,
                              child: Text(
                                "Afluencia media / Presión moderada (Jw = 0.66)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.5,
                              child: Text(
                                "Afluencia grande / Lavado de juntas (Jw = 0.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.33,
                              child: Text(
                                "Afluencia excepcional sin voladura (Jw = 0.33)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.2,
                              child: Text(
                                "Afluencia excepcional que decae (Jw = 0.2)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.1,
                              child: Text(
                                "Afluencia excepcional continua (Jw = 0.1)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 0.05,
                              child: Text(
                                "Presión/afluencia extrema continua (Jw = 0.05)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _jw = val!),
                        ),
                        const SizedBox(height: 10),

                        // SRF Dropdown
                        const Text(
                          "SRF - Factor de Reducción por Tensiones",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        DropdownButtonFormField<double>(
                          initialValue: _srf,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 0.5,
                              child: Text(
                                "Alta tensión favorable, estructura muy cerrada (SRF = 0.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 1.0,
                              child: Text(
                                "Tensiones normales / Campo estable (SRF = 1.0)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2.5,
                              child: Text(
                                "Baja tensión o zona débil profunda (SRF = 2.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 5.0,
                              child: Text(
                                "Zona débil / spalling moderado / squeezing leve (SRF = 5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 7.5,
                              child: Text(
                                "Múltiples zonas de cizalla (SRF = 7.5)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 10.0,
                              child: Text(
                                "Zonas débiles múltiples o squeezing (SRF = 10)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 15.0,
                              child: Text(
                                "Squeezing fuerte o expansión moderada (SRF = 15)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 20.0,
                              child: Text(
                                "Squeezing/expansión severa (SRF = 20)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 50.0,
                              child: Text(
                                "Spalling rápido / rockburst incipiente (SRF = 50)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 100.0,
                              child: Text(
                                "Rockburst importante (SRF = 100)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 200.0,
                              child: Text(
                                "Rockburst severo (SRF = 200)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 400.0,
                              child: Text(
                                "Rockburst extremo inmediato (SRF = 400)",
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _srf = val!),
                        ),

                        if (currentVersion.supportsQc ||
                            widget.isExpertMode) ...[
                          const SizedBox(height: 14),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Resistencia Intacta σci (MPa) para Qc:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: LithicaColors.alterationPurple,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  initialValue: _sigCi.toInt().toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    final p = double.tryParse(val);
                                    if (p != null && p > 0) {
                                      setState(() => _sigCi = p);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );

                final resultsCard = Card(
                  key: const ValueKey('q_results_card'),
                  child: OptionalVerticalScroll(
                    enabled: !isPortrait,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resultado Índice Q & Sostenimiento",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Large Score Banner
                        Flex(
                          direction: isPortrait
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0B2238)
                                    : const Color(0xFFE8F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: LithicaColors.logoTeal.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Índice Q",
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFF52606D),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    effectiveQ.toStringAsFixed(3),
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? LithicaColors.rockCyan
                                          : const Color(0xFF1B7A7A),
                                    ),
                                  ),
                                  Text(
                                    _getQQualityCategory(effectiveQ),
                                    style: TextStyle(
                                      color: isDark
                                          ? LithicaColors.logoLime
                                          : const Color(0xFF255C0E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: isPortrait ? 0 : 16,
                              height: isPortrait ? 12 : 0,
                            ),
                            ResponsiveFlexChild(
                              expand: !isPortrait,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dimensión Equivalente (De): ${deStr}m",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "Perno estimado (L): ${estimatedBoltLength.toStringAsFixed(2)}m",
                                    style: const TextStyle(
                                      color: LithicaColors.logoTeal,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "• Bloques (RQD/Jn): ${blockSize.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    "• Fricción (Jr/Ja): ${jointFriction.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    "• Estrés (Jw/SRF): ${activeStress.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  if (currentVersion.supportsQc)
                                    Text(
                                      "• Q Original: $qStr | Qc (σci=$_sigCi MPa): $qcStr",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: LithicaColors.alterationPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Lithica GeoTech Traceability & Recommendation Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFEEF6EE),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: LithicaColors.logoGreen.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 6,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: isDark
                                            ? LithicaColors.logoLime
                                            : const Color(0xFF255C0E),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          "Zona Barton ${activeZone.id}: ${activeZone.name}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? LithicaColors.logoLime
                                                : const Color(0xFF255C0E),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Chip(
                                    label: const Text(
                                      "Trazable",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: isDark
                                        ? LithicaColors.darkSurface
                                        : const Color(0xFFDCEFD9),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildTraceRow(
                                "Método Base:",
                                currentVersion.name,
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Cita Bibliográfica:",
                                "${currentVersion.author} (${currentVersion.year})",
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Carta Aplicada:",
                                "Carta de Soporte Q vs De (${currentVersion.year})",
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Excavación & ESR:",
                                "${currentEsrPreset.label} (ESR diseño = $designEsr)",
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Sostenimiento Sugerido:",
                                activeZone.shotcrete,
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Longitud Perno (L):",
                                "~${estimatedBoltLength.toStringAsFixed(1)} m [L = (2 + 0.15×Span)/ESR]",
                                isDark: isDark,
                              ),
                              _buildTraceRow(
                                "Nivel de Confianza:",
                                "Diseño Empírico / Preliminar (Se recomienda modelado numérico)",
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          "Carta de Soporte Geotécnico de Barton (${currentVersion.year}):",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 270,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: QSupportPainter(
                                qValue: effectiveQ,
                                deValue: de,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                final proposedSupportCard = _buildProposedSupportCard(
                  context,
                  activeZone,
                  _span,
                  designEsr,
                  isDark,
                );

                if (showResultAtRight) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: formCard),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              resultsCard,
                              const SizedBox(height: 18),
                              proposedSupportCard,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  final stackedCards = Column(
                    children: [
                      formCard,
                      const SizedBox(height: 18),
                      resultsCard,
                      const SizedBox(height: 18),
                      proposedSupportCard,
                    ],
                  );
                  return isPortrait
                      ? stackedCards
                      : SingleChildScrollView(child: stackedCards);
                }
              },
            ),
          ),
        ],
      ),
    );

    return scrollWholePageInPortrait(isPortrait: isPortrait, child: page);
  }

  Widget _buildTraceRow(String label, String val, {required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF52606D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white : LithicaColors.logoNavyDeep,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEsr(double value) {
    final hundredths = (value * 100).round();
    return hundredths % 10 == 0
        ? value.toStringAsFixed(1)
        : value.toStringAsFixed(2);
  }

  String _getQQualityCategory(double q) {
    if (q >= 400) return "Excepcionalmente Buena";
    if (q >= 100) return "Extremadamente Buena";
    if (q >= 40) return "Muy Buena";
    if (q >= 10) return "Roca Buena";
    if (q >= 4) return "Roca Regular";
    if (q >= 1) return "Roca Mala";
    if (q >= 0.1) return "Roca Muy Mala";
    if (q >= 0.01) return "Extremadamente Mala";
    return "Excepcionalmente Mala";
  }

  Widget _buildProposedSupportCard(
    BuildContext context,
    QSupportZone activeZone,
    double span,
    double esr,
    bool isDark,
  ) {
    final calcL = (2.0 + 0.15 * span) / esr;
    double roundL(double l) {
      if (l <= 2.0) return 2.0;
      if (l <= 2.5) return 2.5;
      if (l <= 3.0) return 3.0;
      if (l <= 3.5) return 3.5;
      if (l <= 4.0) return 4.0;
      if (l <= 4.5) return 4.5;
      if (l <= 5.0) return 5.0;
      if (l <= 5.5) return 5.5;
      if (l <= 6.0) return 6.0;
      if (l <= 7.0) return 7.0;
      if (l <= 8.0) return 8.0;
      return (l * 2).ceil() / 2;
    }

    final adoptedL = roundL(calcL);

    String constructiveMeaning;
    switch (activeZone.id) {
      case 1:
        constructiveMeaning =
            "Macizo rocoso extremadamente competente y masivo. La excavación se autosoporta a sección completa sin necesidad de instalar elementos estructurales activos ni pasivos. Únicamente se realiza desatado riguroso (scaling) de bloques sueltos post-voladura.";
        break;
      case 2:
        constructiveMeaning =
            "El macizo es mayoritariamente estable pero presenta cuñas de roca identificables por discontinuidades. Se instalan pernos puntuales dirigidos a estabilizar bloques potencialmente inestables inmediatamente después de la ventilación y desatado.";
        break;
      case 3:
        constructiveMeaning =
            "Roca de calidad regular a buena con familias de juntas bien definidas. Se requiere un patrón regular de pernos para generar un arco de roca auto-portante alrededor de la bóveda del túnel mediante confinamiento activo o pasivo.";
        break;
      case 4:
        constructiveMeaning =
            "Combina el confinamiento de la masa rocosa mediante pernado sistemático con un sello continuo de shotcrete de 4 a 5 cm para prevenir desprendimientos menores de bloques (spalling) y detener la descompresión temprana.";
        break;
      case 5:
        constructiveMeaning =
            "La adición de fibra de acero o macro-sintética proporciona alta tenacidad y ductilidad al shotcrete, distribuyendo la carga de deformación del macizo. Elimina la necesidad de instalar malla metálica manual en la clave, reduciendo riesgos operativos.";
        break;
      case 6:
        constructiveMeaning =
            "Sostenimiento estructural pesado para roca mala. El sostenimiento se ejecuta en 2 pasadas de shotcrete: sello de protección de 4-5 cm en el frente, perforación e instalación de pernos sistemáticos, y colocación de la capa final de shotcrete con fibra para completar de 9 a 12 cm.";
        break;
      case 7:
        constructiveMeaning =
            "Roca muy mala susceptible a convergencias rápidas y alta plastificación. Requiere excavación por etapas (avance de bóveda y posterior destrozo). La aplicación de shotcrete de fraguado ultrarrápido en el frente es crítica antes de permitir que el macizo se desajuste.";
        break;
      case 8:
        constructiveMeaning =
            "Roca extremadamente mala con presencia de esfuerzos destructivos o descomposiciones severas. Exige la instalación de cerchas metálicas pesadas (TH o HEB) integradas dentro de la capa de shotcrete de 15 a 20 cm, y cierre rápido de solera (invert) para formar un anillo estructural cerrado.";
        break;
      case 9:
      default:
        constructiveMeaning =
            "Condiciones extremas de expansividad, fluencia plástica severa (squeezing) o zonas de falla de gran potencia. Requiere pre-sostenimiento mediante paraguas de tubos cementados (forepoling), excavación a sección reducida, cerchas pesadas en retícula y cierre inmediato de la solera con bóveda invertida.";
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.layers,
                      color: LithicaColors.logoLime,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Módulo de Sostenimiento Propuesto",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : LithicaColors.logoNavyDeep,
                        ),
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: const Text(
                    "DISEÑO PRELIMINAR",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: LithicaColors.logoGreen.withValues(
                    alpha: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Executive Blueprint Summary Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF071827)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: LithicaColors.rockCyan.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      const Text(
                        "SOSTENIMIENTO RECOMENDADO PRELIMINAR",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: LithicaColors.rockCyan,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: LithicaColors.logoGreen.withValues(
                            alpha: 0.25,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Zona Z${activeZone.id}: ${activeZone.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: LithicaColors.logoLime,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildBlueprintRow(
                    "Shotcrete / Concreto Lanzado:",
                    activeZone.shotcrete,
                    isDark: isDark,
                  ),
                  _buildBlueprintRow(
                    "Pernos de Roca:",
                    "L = ${adoptedL.toStringAsFixed(1)} m (Calc: ${calcL.toStringAsFixed(2)} m) | Pernos en malla según Zona Z${activeZone.id}",
                    isDark: isDark,
                  ),
                  _buildBlueprintRow(
                    "Malla Metálica:",
                    activeZone.id >= 7
                        ? "Sí (Electrosoldada 6x6 W2.9/W2.9)"
                        : "Opcional / No requerida",
                    isDark: isDark,
                  ),
                  _buildBlueprintRow(
                    "Cerchas / Costillas:",
                    activeZone.id >= 8
                        ? "Requerido (Cerchas TH / HEB)"
                        : "No requerido",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Fuente: Grimstad & Barton (1993) / NGI Q-Support Chart",
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Design Level Warning Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? LithicaColors.textureOchre.withValues(alpha: 0.12)
                    : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: LithicaColors.textureOchre.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: LithicaColors.textureOchre,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Nivel de Diseño Geotécnico: Recomendación Empírica vs Diseño Definitivo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isDark
                                ? LithicaColors.textureOchre
                                : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• Recomendación Empírica (Q-System): Válida para perfil, prefactibilidad y diseño preliminar.\n"
                    "• Requerimientos para Diseño Definitivo: Requiere medición de esfuerzos in-situ (σ1, σ3, K0), modelamiento numérico 2D/3D (FEM/3DEC/FLAC), análisis de cuñas (UNWEDGE) e instrumentación en tiempo real.",
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Constructive Meaning Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: LithicaColors.logoTeal.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: LithicaColors.rockCyan,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "¿Qué significa constructivamente la Zona Barton Z${activeZone.id} (${activeZone.name})?",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: LithicaColors.rockCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    constructiveMeaning,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? Colors.white : LithicaColors.logoNavyDeep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueprintRow(String label, String val, {required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF475569),
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

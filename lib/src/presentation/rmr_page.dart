import 'package:flutter/material.dart';
import '../domain/geotech_calculations.dart';
import '../domain/rmr_version_data.dart';
import '../theme/lithica_theme.dart';
import '../widgets/responsive_page_scroll.dart';

class RMRPage extends StatefulWidget {
  const RMRPage({super.key, required this.isExpertMode});

  final bool isExpertMode;

  @override
  State<RMRPage> createState() => _RMRPageState();
}

class _RMRPageState extends State<RMRPage> {
  String _selectedVersionKey = "rmr89";

  int _s1 = 12;
  double _rqd = 75;
  int _s3 = 15;
  int _s4 = 25;
  int _s5 = 10;
  int _s6 = 0;
  double _rmr14JointFrequency = 10;
  int _rmr14Persistence = 5;
  int _rmr14Roughness = 5;
  int _rmr14Infilling = 5;
  int _rmr14Weathering = 5;
  double _rmr14Id2 = 90;
  bool _rmr14MechanicalExcavation = false;
  double _rmr14Ice = 70;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final verDef =
        RMR_VERSION_DEFINITIONS[_selectedVersionKey] ??
        RMR_VERSION_DEFINITIONS["rmr89"]!;

    // Validate selected scores against active version options
    final validS1 = _ensureValidScore(_s1, verDef.p1UcsOptions);
    final validS3 = _ensureValidScore(_s3, verDef.p3SpacingOptions);
    final validS4 = _ensureValidScore(_s4, verDef.p4ConditionOptions);
    final validS5 = _ensureValidScore(_s5, verDef.p5WaterOptions);
    final validS6 = _ensureValidScore(_s6, verDef.p6OrientationOptions);

    final isRmr14 = _selectedVersionKey == "rmr14";
    final s2 = _calculateRQDScore(_rqd);
    final rmr14Result = isRmr14
        ? calculateRmr14(
            intactStrengthRating: validS1,
            jointsPerMeter: _rmr14JointFrequency,
            discontinuityConditionRating:
                _rmr14Persistence +
                _rmr14Roughness +
                _rmr14Infilling +
                _rmr14Weathering,
            groundwaterRating: validS5,
            id2Percent: _rmr14Id2,
            orientationAdjustment: validS6,
            mechanicalExcavation: _rmr14MechanicalExcavation,
            ice: _rmr14Ice,
          )
        : null;
    final basicRmr = isRmr14
        ? rmr14Result!.basicRmr
        : (validS1 + s2 + validS3 + validS4 + validS5).toDouble();
    final totalRmr = isRmr14
        ? rmr14Result!.totalRmr
        : (basicRmr + validS6).clamp(0.0, 100.0);
    final rmrInfo = _getRMRClass(totalRmr.round());
    final scoreDecimals = isRmr14 ? 1 : 0;

    final page = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Version Picker
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calculadora RMR (Rock Mass Rating)",
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
                      "Edición activa: ${verDef.name} — ${verDef.publication}",
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
              SizedBox(
                width: isPortrait
                    ? MediaQuery.sizeOf(context).width - 40
                    : null,
                child: DropdownButton<String>(
                  value: _selectedVersionKey,
                  isExpanded: isPortrait,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: const [
                    DropdownMenuItem(
                      value: "rmr89",
                      child: Text("Bieniawski 1989 (RMR89 - Estándar)"),
                    ),
                    DropdownMenuItem(
                      value: "rmr76",
                      child: Text("Bieniawski 1976 (RMR76)"),
                    ),
                    DropdownMenuItem(
                      value: "rmr73",
                      child: Text("Bieniawski 1973 (RMR73)"),
                    ),
                    DropdownMenuItem(
                      value: "rmr14",
                      child: Text("Celada et al. 2014 (RMR14)"),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedVersionKey = val;
                        final newDef = RMR_VERSION_DEFINITIONS[val]!;
                        _s1 = newDef.p1UcsOptions.first.score;
                        _s3 = newDef.p3SpacingOptions.first.score;
                        _s4 = newDef.p4ConditionOptions.first.score;
                        _s5 = newDef.p5WaterOptions.first.score;
                        _s6 = newDef.p6OrientationOptions.first.score;
                      });
                    }
                  },
                ),
              ),
              if (widget.isExpertMode)
                Chip(
                  avatar: const Icon(Icons.science_outlined, size: 16),
                  label: const Text("Auditoría experta activa"),
                  backgroundColor: LithicaColors.alterationPurple.withValues(
                    alpha: 0.2,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Layout Grid
          ResponsiveFlexChild(
            expand: !isPortrait,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = !isPortrait && constraints.maxWidth > 850;

                final formCard = Card(
                  child: OptionalVerticalScroll(
                    enabled: !isPortrait,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            const Text(
                              "Parámetros de Entrada",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(verDef.name),
                              backgroundColor: LithicaColors.logoGreen
                                  .withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 1. UCS
                        const Text(
                          "1. Resistencia Roca Intacta (UCS / Carga Puntual)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          key: ValueKey("p1_$_selectedVersionKey"),
                          initialValue: validS1,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: verDef.p1UcsOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt.score,
                                  child: Text(
                                    opt.text,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _s1 = val!),
                        ),
                        const SizedBox(height: 14),

                        // 2. RQD
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text(
                              isRmr14
                                  ? "2. Frecuencia de juntas (juntas/m)"
                                  : "2. Calidad de Roca RQD (%)",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isRmr14
                                  ? "${_rmr14JointFrequency.toStringAsFixed(0)} juntas/m (+${calculateRmr14JointFrequencyRating(_rmr14JointFrequency).toStringAsFixed(1)} pts)"
                                  : "${_rqd.toInt()}% (+$s2 pts)",
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
                          value: isRmr14 ? _rmr14JointFrequency : _rqd,
                          min: 0,
                          max: isRmr14 ? 50 : 100,
                          divisions: isRmr14 ? 50 : 100,
                          activeColor: LithicaColors.logoGreen,
                          onChanged: (val) => setState(() {
                            if (isRmr14) {
                              _rmr14JointFrequency = val;
                            } else {
                              _rqd = val;
                            }
                          }),
                        ),
                        const SizedBox(height: 14),

                        // 3. Spacing
                        Text(
                          isRmr14
                              ? "3. Alterabilidad de la roca intacta Id2 (%)"
                              : "3. Espaciamiento de Discontinuidades",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (isRmr14) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _rmr14Id2,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  activeColor: LithicaColors.logoGreen,
                                  onChanged: (val) =>
                                      setState(() => _rmr14Id2 = val),
                                ),
                              ),
                              Text(
                                "${_rmr14Id2.toStringAsFixed(0)}% (+${calculateRmr14AlterabilityRating(_rmr14Id2)} pts)",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ] else
                          DropdownButtonFormField<int>(
                            key: ValueKey("p3_$_selectedVersionKey"),
                            initialValue: validS3,
                            isExpanded: true,
                            dropdownColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            items: verDef.p3SpacingOptions
                                .map(
                                  (opt) => DropdownMenuItem(
                                    value: opt.score,
                                    child: Text(
                                      opt.text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(() => _s3 = val!),
                          ),
                        const SizedBox(height: 14),

                        // 4. Condition
                        Text(
                          isRmr14
                              ? "4. Condición de discontinuidades RMR14"
                              : "4. Condición de Discontinuidades",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (isRmr14)
                          ..._buildRmr14ConditionInputs()
                        else
                          DropdownButtonFormField<int>(
                            key: ValueKey("p4_$_selectedVersionKey"),
                            initialValue: validS4,
                            isExpanded: true,
                            dropdownColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            items: verDef.p4ConditionOptions
                                .map(
                                  (opt) => DropdownMenuItem(
                                    value: opt.score,
                                    child: Text(
                                      opt.text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(() => _s4 = val!),
                          ),
                        const SizedBox(height: 14),

                        // 5. Groundwater
                        const Text(
                          "5. Agua Subterránea",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          key: ValueKey("p5_$_selectedVersionKey"),
                          initialValue: validS5,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: verDef.p5WaterOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt.score,
                                  child: Text(
                                    opt.text,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _s5 = val!),
                        ),
                        const SizedBox(height: 14),

                        // 6. Orientation
                        const Text(
                          "6. Corrección por Orientación (túneles y minas)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          key: ValueKey("p6_$_selectedVersionKey"),
                          initialValue: validS6,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: verDef.p6OrientationOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt.score,
                                  child: Text(
                                    opt.text,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _s6 = val!),
                        ),
                        if (isRmr14) ...[
                          const SizedBox(height: 14),
                          const Text(
                            "7. Método de excavación",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<bool>(
                            initialValue: _rmr14MechanicalExcavation,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  "Perforación y voladura (Fe = 1.000)",
                                ),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text("Excavación mecánica / TBM"),
                              ),
                            ],
                            onChanged: (val) => setState(
                              () => _rmr14MechanicalExcavation = val!,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "8. Índice de Comportamiento Elástico (ICE)",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${_rmr14Ice.toStringAsFixed(0)} (Fs ${calculateRmr14StressFactor(_rmr14Ice).toStringAsFixed(3)})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _rmr14Ice,
                            min: 0,
                            max: 130,
                            divisions: 130,
                            activeColor: LithicaColors.logoGreen,
                            onChanged: (val) => setState(() => _rmr14Ice = val),
                          ),
                        ],
                      ],
                    ),
                  ),
                );

                final resultsCard = Card(
                  child: OptionalVerticalScroll(
                    enabled: !isPortrait,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            const Text(
                              "Resultado RMR & Clasificación",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Versión: ${verDef.name}",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? LithicaColors.rockCyan
                                    : const Color(0xFF1B7A7A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B2238)
                                : const Color(0xFFE8F2EC),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: LithicaColors.logoTeal.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            runSpacing: 12,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "RMR Total (${verDef.key.toUpperCase()})",
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFF52606D),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${totalRmr.toStringAsFixed(scoreDecimals)} / 100",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? LithicaColors.logoLime
                                          : const Color(0xFF255C0E),
                                    ),
                                  ),
                                  Text(
                                    "RMRb (Básico sin ajuste): ${basicRmr.toStringAsFixed(scoreDecimals)}",
                                    style: TextStyle(
                                      color: isDark
                                          ? LithicaColors.diagramBlue
                                          : const Color(0xFF255CA8),
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (rmr14Result != null)
                                    Text(
                                      "F0: $validS6 | Fe: ${rmr14Result.excavationFactor.toStringAsFixed(3)} | Fs: ${rmr14Result.stressFactor.toStringAsFixed(3)}",
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF52606D),
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: LithicaColors.logoGreen.withValues(
                                    alpha: isDark ? 0.2 : 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: LithicaColors.logoGreen,
                                  ),
                                ),
                                child: Text(
                                  "Clase ${rmrInfo['classNum']}: ${rmrInfo['desc']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? LithicaColors.logoLime
                                        : const Color(0xFF255C0E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (widget.isExpertMode) ...[
                          _buildExpertAudit(
                            isDark: isDark,
                            isRmr14: isRmr14,
                            validS1: validS1,
                            s2: s2,
                            validS3: validS3,
                            validS4: validS4,
                            validS5: validS5,
                            validS6: validS6,
                            basicRmr: basicRmr,
                            totalRmr: totalRmr,
                            rmr14Result: rmr14Result,
                          ),
                          const SizedBox(height: 20),
                        ],

                        const Text(
                          "Estimaciones Geomecánicas Derivadas:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          "Cohesión (c):",
                          rmrInfo['cohesion']!,
                          isDark: isDark,
                        ),
                        _buildDetailRow(
                          "Ángulo Fricción (phi):",
                          rmrInfo['friction']!,
                          isDark: isDark,
                        ),
                        _buildDetailRow(
                          "Tiempo Autosoporte:",
                          rmrInfo['standUp']!,
                          isDark: isDark,
                        ),

                        const Divider(height: 24),
                        Text(
                          "Recomendación de Soporte en Túneles (${verDef.author}):",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0x33123149)
                                : const Color(0xFFF2F6F0),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            rmrInfo['support']!,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: formCard),
                      const SizedBox(width: 18),
                      Expanded(child: resultsCard),
                    ],
                  );
                } else {
                  final stackedCards = Column(
                    children: [
                      formCard,
                      const SizedBox(height: 18),
                      resultsCard,
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

  int _ensureValidScore(int val, List<RMRParamOption> options) {
    final exists = options.any((o) => o.score == val);
    return exists ? val : options.first.score;
  }

  Widget _buildExpertAudit({
    required bool isDark,
    required bool isRmr14,
    required int validS1,
    required int s2,
    required int validS3,
    required int validS4,
    required int validS5,
    required int validS6,
    required double basicRmr,
    required double totalRmr,
    required Rmr14Result? rmr14Result,
  }) {
    final rows = isRmr14
        ? <MapEntry<String, String>>[
            MapEntry("R1 — Resistencia intacta", "$validS1"),
            MapEntry(
              "R2-3 — Frecuencia de juntas λ",
              "${calculateRmr14JointFrequencyRating(_rmr14JointFrequency).toStringAsFixed(3)}",
            ),
            MapEntry(
              "R4 — Condición de discontinuidades",
              "${_rmr14Persistence + _rmr14Roughness + _rmr14Infilling + _rmr14Weathering}",
            ),
            MapEntry("R5 — Agua subterránea", "$validS5"),
            MapEntry(
              "RI — Alterabilidad Id2",
              "${calculateRmr14AlterabilityRating(_rmr14Id2)}",
            ),
            MapEntry("RMRb", basicRmr.toStringAsFixed(3)),
            MapEntry("F0 — Orientación", "$validS6"),
            MapEntry(
              "RMR antes de Fe y Fs",
              rmr14Result!.orientationAdjustedRmr.toStringAsFixed(3),
            ),
            MapEntry(
              "Fe — Método de excavación",
              rmr14Result.excavationFactor.toStringAsFixed(4),
            ),
            MapEntry(
              "Fs — Comportamiento tensional",
              rmr14Result.stressFactor.toStringAsFixed(4),
            ),
          ]
        : <MapEntry<String, String>>[
            MapEntry("R1 — Resistencia intacta", "$validS1"),
            MapEntry("R2 — RQD", "$s2"),
            MapEntry("R3 — Espaciamiento", "$validS3"),
            MapEntry("R4 — Condición", "$validS4"),
            MapEntry("R5 — Agua", "$validS5"),
            MapEntry("RMRb", basicRmr.toStringAsFixed(0)),
            MapEntry("R6 / F0 — Orientación", "$validS6"),
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF2F4F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: LithicaColors.alterationPurple.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Descomposición y trazabilidad del cálculo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: LithicaColors.alterationPurple,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ...rows.map(
            (row) => _buildDetailRow("${row.key}:", row.value, isDark: isDark),
          ),
          const Divider(),
          _buildDetailRow(
            isRmr14 ? "RMR14 final:" : "RMR ajustado:",
            totalRmr.toStringAsFixed(isRmr14 ? 3 : 0),
            isDark: isDark,
          ),
          if (_selectedVersionKey == "rmr89")
            _buildDetailRow(
              "Correlación orientativa GSI ≈ RMR89 − 5:",
              "${(totalRmr - 5).clamp(0, 95).toStringAsFixed(0)}",
              isDark: isDark,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRmr14ConditionInputs() {
    return [
      _buildRmr14ConditionDropdown(
        label: "Persistencia",
        value: _rmr14Persistence,
        options: const {
          5: "< 1 m (+5)",
          4: "1 - 3 m (+4)",
          2: "3 - 10 m (+2)",
          1: "10 - 20 m (+1)",
          0: "> 20 m (0)",
        },
        onChanged: (value) => _rmr14Persistence = value,
      ),
      const SizedBox(height: 8),
      _buildRmr14ConditionDropdown(
        label: "Rugosidad",
        value: _rmr14Roughness,
        options: const {
          5: "Muy rugosa (+5)",
          3: "Rugosa o ligeramente rugosa (+3)",
          1: "Lisa (+1)",
          0: "Espejo de falla / slickensided (0)",
        },
        onChanged: (value) => _rmr14Roughness = value,
      ),
      const SizedBox(height: 8),
      _buildRmr14ConditionDropdown(
        label: "Relleno",
        value: _rmr14Infilling,
        options: const {
          5: "Sin relleno o duro < 5 mm (+5)",
          2: "Duro > 5 mm o blando < 5 mm (+2)",
          0: "Blando > 5 mm (0)",
        },
        onChanged: (value) => _rmr14Infilling = value,
      ),
      const SizedBox(height: 8),
      _buildRmr14ConditionDropdown(
        label: "Meteorización",
        value: _rmr14Weathering,
        options: const {
          5: "No meteorizada (+5)",
          3: "Ligera o moderadamente meteorizada (+3)",
          1: "Altamente meteorizada (+1)",
          0: "Descompuesta (0)",
        },
        onChanged: (value) => _rmr14Weathering = value,
      ),
      const SizedBox(height: 6),
      Text(
        "Condición total: ${_rmr14Persistence + _rmr14Roughness + _rmr14Infilling + _rmr14Weathering} / 20",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    ];
  }

  Widget _buildRmr14ConditionDropdown({
    required String label,
    required int value,
    required Map<int, String> options,
    required ValueChanged<int> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: options.entries
          .map(
            (entry) => DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (newValue) => setState(() => onChanged(newValue!)),
    );
  }

  Widget _buildDetailRow(String label, String val, {required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 4,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF52606D),
              fontSize: 13,
            ),
          ),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  int _calculateRQDScore(double rqd) {
    if (rqd >= 90) return 20;
    if (rqd >= 75) return 17;
    if (rqd >= 50) return 13;
    if (rqd >= 25) return 8;
    return 3;
  }

  Map<String, String> _getRMRClass(int score) {
    if (score >= 81) {
      return {
        "classNum": "I",
        "desc": "Roca Muy Buena",
        "cohesion": "> 400 kPa",
        "friction": "> 45°",
        "standUp": "20 años para 15 m luz",
        "support":
            "Generalmente no requiere soporte excepto pernos ocasionales.",
      };
    } else if (score >= 61) {
      return {
        "classNum": "II",
        "desc": "Roca Buena",
        "cohesion": "300 - 400 kPa",
        "friction": "35° - 45°",
        "standUp": "1 año para 10 m luz",
        "support":
            "Pernos localizados L=3m espaciados 2.5m en bóveda con malla ocasional.",
      };
    } else if (score >= 41) {
      return {
        "classNum": "III",
        "desc": "Roca Regular",
        "cohesion": "200 - 300 kPa",
        "friction": "25° - 35°",
        "standUp": "1 semana para 5 m luz",
        "support":
            "Pernos sistemáticos L=3-4m espaciados 1.5-2m en bóveda y hastiales con 50-100mm shotcrete.",
      };
    } else if (score >= 21) {
      return {
        "classNum": "IV",
        "desc": "Roca Mala",
        "cohesion": "100 - 200 kPa",
        "friction": "15° - 25°",
        "standUp": "10 horas para 2.5 m luz",
        "support":
            "Pernos sistemáticos L=4-5m espaciados 1-1.5m con 100-150mm shotcrete reforzado y cerchas ligeras.",
      };
    } else {
      return {
        "classNum": "V",
        "desc": "Roca Muy Mala",
        "cohesion": "< 100 kPa",
        "friction": "< 15°",
        "standUp": "30 minutos para 1 m luz",
        "support":
            "Shotcrete 150-200mm en bóveda y hastiales, cerchas pesadas espaciadas 0.75m y avance con contrabóveda.",
      };
    }
  }
}

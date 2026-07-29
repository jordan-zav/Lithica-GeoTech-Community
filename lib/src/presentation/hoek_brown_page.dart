import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/geotech_calculations.dart';
import '../theme/lithica_theme.dart';
import '../widgets/hoek_envelope_painter.dart';

class HoekBrownPage extends StatefulWidget {
  const HoekBrownPage({super.key, required this.isExpertMode});

  final bool isExpertMode;

  @override
  State<HoekBrownPage> createState() => _HoekBrownPageState();
}

class _HoekBrownPageState extends State<HoekBrownPage> {
  double _sigCi = 80;
  double _mi = 15;
  double _gsi = 55;
  double _d = 0.6;
  double _depthOrHeight = 100;
  double _unitWeight = 0.027;
  HoekBrownApplication _application = HoekBrownApplication.tunnel;

  String _sourceSigCi = 'ucs'; // 'ucs', 'lab', 'field'
  String _refMi = 'hoek'; // 'hoek', 'marinos', 'triaxial'
  String _sourceGsi = 'field'; // 'field', 'mapping', 'matrix'
  String _sourceD = 'blast'; // 'tbm', 'blast', 'contour'

  String _plotMode = 'mohr'; // 'mohr' or 'principal'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompactLayout =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final hb = calculateHoekBrown(
      intactUcsMPa: _sigCi,
      mi: _mi,
      gsi: _gsi,
      disturbance: _d,
      application: _application,
      depthOrHeightM: _depthOrHeight,
      unitWeightMNPerM3: _unitWeight,
    );
    final mb2002 = hb.mb;
    final s2002 = hb.s;
    final a2002 = hb.a;
    final sigCm = hb.rockMassStrengthMPa;
    final em = hb.deformationModulusMPa;
    final sigT = hb.tensileStrengthMPa;
    final sig3max = hb.sigma3MaxMPa;
    final cCohesion = hb.cohesionMPa;
    final phiFriction = hb.frictionDeg;
    final cohesionKPa = (cCohesion * 1000).round();

    // Historical Comparisons
    final mb1980 = _mi * math.exp((_gsi - 100) / 28);
    final s1980 = math.exp((_gsi - 100) / 9);

    final mb1995 = _mi * math.exp((_gsi - 100) / 28);
    final s1995 = math.exp((_gsi - 100) / 9);

    final page = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Criterio Cero-Linear Hoek-Brown & Matriz GSI",
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
                      widget.isExpertMode
                          ? "Modo Experto: Evolución Histórica + Conversión Equivalente Mohr-Coulomb (c', φ')"
                          : "Evolución de parámetros no lineales (mb, s, a), envolvente de rotura y estimación interactiva de GSI.",
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
          const SizedBox(height: 20),

          _ResponsiveFlexChild(
            expand: !isCompactLayout,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = !isCompactLayout && constraints.maxWidth > 850;

                final formCard = Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _OptionalVerticalScroll(
                      enabled: isWide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Parámetros Entrada Hoek-Brown",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 1. sig_ci Input & Source Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "1. Resistencia Roca Intacta σci (MPa):",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue: _sigCi.toInt().toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    final p = double.tryParse(val);
                                    if (p != null && p > 0)
                                      setState(() => _sigCi = p);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildChoiceChip(
                                "Ensayo UCS",
                                _sourceSigCi == 'ucs',
                                () => setState(() => _sourceSigCi = 'ucs'),
                              ),
                              _buildChoiceChip(
                                "Laboratorio",
                                _sourceSigCi == 'lab',
                                () => setState(() => _sourceSigCi = 'lab'),
                              ),
                              _buildChoiceChip(
                                "Estimación de campo",
                                _sourceSigCi == 'field',
                                () => setState(() => _sourceSigCi = 'field'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 2. mi Input & Reference Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "2. Constante mi:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue: _mi.toInt().toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    final p = double.tryParse(val);
                                    if (p != null && p > 0)
                                      setState(() => _mi = p);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildChoiceChip(
                                "Hoek et al.",
                                _refMi == 'hoek',
                                () => setState(() => _refMi = 'hoek'),
                              ),
                              _buildChoiceChip(
                                "Marinos & Hoek",
                                _refMi == 'marinos',
                                () => setState(() => _refMi = 'marinos'),
                              ),
                              _buildChoiceChip(
                                "Ensayos triaxiales",
                                _refMi == 'triaxial',
                                () => setState(() => _refMi = 'triaxial'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 3. GSI Slider & Source Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "3. Índice Fuerza Geológica GSI:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "GSI = ${_gsi.toInt()}",
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
                            value: _gsi,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (val) => setState(() => _gsi = val),
                          ),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildChoiceChip(
                                "Evaluación de campo",
                                _sourceGsi == 'field',
                                () => setState(() => _sourceGsi = 'field'),
                              ),
                              _buildChoiceChip(
                                "Mapeo geomecánico",
                                _sourceGsi == 'mapping',
                                () => setState(() => _sourceGsi = 'mapping'),
                              ),
                              _buildChoiceChip(
                                "Tabla GSI",
                                _sourceGsi == 'matrix',
                                () => setState(() => _sourceGsi = 'matrix'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 4. Factor D Slider & Origin Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "4. Factor Perturbación (D):",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "D = ${_d.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: LithicaColors.textureOchre,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _d,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            onChanged: (val) => setState(() => _d = val),
                          ),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildChoiceChip(
                                "Excavación mecánica",
                                _sourceD == 'tbm',
                                () => setState(() => _sourceD = 'tbm'),
                              ),
                              _buildChoiceChip(
                                "Voladura",
                                _sourceD == 'blast',
                                () => setState(() => _sourceD = 'blast'),
                              ),
                              _buildChoiceChip(
                                "Calidad del contorno",
                                _sourceD == 'contour',
                                () => setState(() => _sourceD = 'contour'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "5. Rango de confinamiento para Mohr-Coulomb:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<HoekBrownApplication>(
                            initialValue: _application,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "Aplicación",
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: HoekBrownApplication.tunnel,
                                child: Text("Túnel / excavación subterránea"),
                              ),
                              DropdownMenuItem(
                                value: HoekBrownApplication.slope,
                                child: Text("Talud"),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _application = value);
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _depthOrHeight.toStringAsFixed(
                                    0,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText:
                                        _application ==
                                            HoekBrownApplication.tunnel
                                        ? "Profundidad H (m)"
                                        : "Altura H (m)",
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    final parsed = double.tryParse(value);
                                    if (parsed != null && parsed > 0) {
                                      setState(() => _depthOrHeight = parsed);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: _unitWeight.toStringAsFixed(3),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Peso unitario (MN/m³)",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    final parsed = double.tryParse(value);
                                    if (parsed != null && parsed > 0) {
                                      setState(() => _unitWeight = parsed);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                final resultsCard = Card(
                  child: _OptionalVerticalScroll(
                    enabled: isWide,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Parámetros Calculados del Macizo",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildParamTile(
                              "Constante mb",
                              mb2002.toStringAsFixed(2),
                              isDark: isDark,
                            ),
                            _buildParamTile(
                              "Constante s",
                              s2002.toStringAsFixed(4),
                              isDark: isDark,
                            ),
                            _buildParamTile(
                              "Exponente a",
                              a2002.toStringAsFixed(3),
                              isDark: isDark,
                            ),
                            _buildParamTile(
                              "Resistencia σcm",
                              "${sigCm.toStringAsFixed(1)} MPa",
                              isHighlight: true,
                              isDark: isDark,
                            ),
                            _buildParamTile(
                              "Módulo Young Em",
                              "${em.toInt()} MPa",
                              isHighlight: true,
                              isDark: isDark,
                            ),
                            _buildParamTile(
                              "σ3 máx. equivalente",
                              "${sig3max.toStringAsFixed(2)} MPa",
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Conversión Equivalente Mohr-Coulomb Card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0x1AD48245),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0x66A9774D)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.show_chart,
                                    color: Color(0xFFA9774D),
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "Conversión Equivalente Mohr-Coulomb",
                                      style: TextStyle(
                                        color: Color(0xFFA9774D),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 20,
                                runSpacing: 8,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Cohesión equivalente (c):",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "${cCohesion.toStringAsFixed(2)} MPa ($cohesionKPa kPa)",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Ángulo de fricción (φ):",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "${phiFriction.toStringAsFixed(1)}°",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // MODO EXPERTO: Comparativa Histórica
                        if (widget.isExpertMode) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0B2238)
                                  : const Color(0xFFF2F4F1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: LithicaColors.alterationPurple
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Evolución de Ecuaciones Hoek-Brown (Modo Experto)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: LithicaColors.alterationPurple,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildEvoRow(
                                  "Hoek-Brown 2002 (GSI + D)",
                                  "mb = ${mb2002.toStringAsFixed(2)}",
                                  "s = ${s2002.toStringAsFixed(4)}",
                                  "a = ${a2002.toStringAsFixed(3)}",
                                  true,
                                  isDark,
                                ),
                                _buildEvoRow(
                                  "Hoek-Brown 1995 (GSI Original)",
                                  "mb = ${mb1995.toStringAsFixed(2)}",
                                  "s = ${s1995.toStringAsFixed(4)}",
                                  "a = 0.500",
                                  false,
                                  isDark,
                                ),
                                _buildEvoRow(
                                  "Hoek-Brown 1980 (RMR Basado)",
                                  "mb = ${mb1980.toStringAsFixed(2)}",
                                  "s = ${s1980.toStringAsFixed(4)}",
                                  "a = 0.500",
                                  false,
                                  isDark,
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            const Text(
                              "Visualización Gráfica:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'mohr',
                                  label: Text(
                                    'Plano Mohr',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                ButtonSegment(
                                  value: 'principal',
                                  label: Text(
                                    'Plano Principal',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                              selected: {_plotMode},
                              onSelectionChanged: (set) =>
                                  setState(() => _plotMode = set.first),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 260,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: HoekEnvelopePainter(
                                sigCi: _sigCi,
                                mb: mb2002,
                                s: s2002,
                                a: a2002,
                                mi: _mi,
                                sigT: sigT,
                                cohesionKPa: cohesionKPa.toDouble(),
                                frictionDeg: phiFriction,
                                isDarkMode: isDark,
                                plotMode: _plotMode,
                              ),
                            ),
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
                  return Column(
                    children: [
                      formCard,
                      const SizedBox(height: 18),
                      resultsCard,
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    if (!isCompactLayout) return page;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: page,
    );
  }

  Widget _buildChoiceChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: selected ? LithicaColors.logoLime : Colors.grey,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: LithicaColors.logoGreen.withValues(alpha: 0.25),
      backgroundColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEvoRow(
    String label,
    String mb,
    String s,
    String a,
    bool isCurrent,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? (isDark
                  ? LithicaColors.logoGreen.withValues(alpha: 0.15)
                  : const Color(0xFFDCEFD9))
            : (isDark ? const Color(0x33123149) : const Color(0xFFEFE8F5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent
                  ? (isDark ? Colors.white : LithicaColors.logoNavyDeep)
                  : (isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF64748B)),
            ),
          ),
          Text(
            "$mb | $s | $a",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isCurrent
                  ? (isDark ? LithicaColors.logoLime : const Color(0xFF255C0E))
                  : (isDark ? LithicaColors.rockCyan : const Color(0xFF1B7A7A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamTile(
    String title,
    String val, {
    bool isHighlight = false,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight
            ? (isDark
                  ? LithicaColors.logoGreen.withValues(alpha: 0.15)
                  : const Color(0xFFE5F4E0))
            : (isDark ? const Color(0x33123149) : const Color(0xFFF2F6F0)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? (isDark ? LithicaColors.logoLime : LithicaColors.logoGreen)
              : LithicaColors.logoTeal.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF52606D),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isHighlight
                  ? (isDark ? LithicaColors.logoLime : const Color(0xFF255C0E))
                  : (isDark ? Colors.white : LithicaColors.logoNavyDeep),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveFlexChild extends StatelessWidget {
  const _ResponsiveFlexChild({required this.expand, required this.child});

  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return expand ? Expanded(child: child) : child;
  }
}

class _OptionalVerticalScroll extends StatelessWidget {
  const _OptionalVerticalScroll({
    required this.enabled,
    required this.child,
    this.padding,
  });

  final bool enabled;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return SingleChildScrollView(padding: padding, child: child);
    }
    return padding == null ? child : Padding(padding: padding!, child: child);
  }
}

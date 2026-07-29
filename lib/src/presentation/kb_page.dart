import 'package:flutter/material.dart';
import '../data/geotech_kb.dart';
import '../domain/geotech_models.dart';
import '../theme/lithica_theme.dart';
import '../widgets/responsive_page_scroll.dart';
import '../widgets/rock_range_bar.dart';

class KBPage extends StatefulWidget {
  const KBPage({super.key, required this.isExpertMode});

  final bool isExpertMode;

  @override
  State<KBPage> createState() => _KBPageState();
}

class _KBPageState extends State<KBPage> {
  String _searchQuery = "";
  String _selectedCategory = "all";
  late GeotechMaterial _selectedMaterial;

  @override
  void initState() {
    super.initState();
    _selectedMaterial = EXPANDED_GEOTECH_MATERIALS.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final filtered = EXPANDED_GEOTECH_MATERIALS.where((m) {
      final matchesSearch =
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat =
          _selectedCategory == "all" || m.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    final page = Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = !isPortrait && constraints.maxWidth > 850;

          final headerWidget = isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Biblioteca Geotécnica de Materiales",
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
                            "Propiedades versionadas de rocas y suelos con trazabilidad bibliográfica.",
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 220,
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Buscar litología...",
                              prefixIcon: Icon(
                                Icons.search,
                                size: 18,
                                color: LithicaColors.logoTeal,
                              ),
                              isDense: true,
                            ),
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: "all",
                              child: Text("Todas las Litologías"),
                            ),
                            DropdownMenuItem(
                              value: "igneous",
                              child: Text("Ígneas"),
                            ),
                            DropdownMenuItem(
                              value: "sedimentary",
                              child: Text("Sedimentarias"),
                            ),
                            DropdownMenuItem(
                              value: "metamorphic",
                              child: Text("Metamórficas"),
                            ),
                            DropdownMenuItem(
                              value: "soil",
                              child: Text("Suelos"),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val!),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biblioteca Geotécnica de Materiales",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : LithicaColors.logoNavyDeep,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Buscar litología...",
                              prefixIcon: Icon(
                                Icons.search,
                                size: 18,
                                color: LithicaColors.logoTeal,
                              ),
                              isDense: true,
                            ),
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: "all",
                              child: Text("Todas"),
                            ),
                            DropdownMenuItem(
                              value: "igneous",
                              child: Text("Ígneas"),
                            ),
                            DropdownMenuItem(
                              value: "sedimentary",
                              child: Text("Sedimentarias"),
                            ),
                            DropdownMenuItem(
                              value: "metamorphic",
                              child: Text("Metamórficas"),
                            ),
                            DropdownMenuItem(
                              value: "soil",
                              child: Text("Suelos"),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val!),
                        ),
                      ],
                    ),
                  ],
                );

          final materialListSidebar = Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, idx) {
                  final mat = filtered[idx];
                  final isSel = mat.id == _selectedMaterial.id;
                  return InkWell(
                    onTap: () => setState(() => _selectedMaterial = mat),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSel
                            ? LithicaColors.logoGreen.withValues(
                                alpha: isDark ? 0.2 : 0.15,
                              )
                            : (isDark
                                  ? const Color(0x33123149)
                                  : const Color(0xFFF2F6F0)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? LithicaColors.logoGreen
                              : LithicaColors.logoTeal.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mat.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "UCS Rec: ${mat.recommended.ucs.toInt()} MPa | Vp: ${mat.recommended.pWaveVelocity.toInt()} m/s",
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFF9CA3AF)
                                        : const Color(0xFF64748B),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              mat.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget,
              const SizedBox(height: 16),
              if (!isWide) ...[
                DropdownButtonFormField<String>(
                  initialValue:
                      filtered.any((m) => m.id == _selectedMaterial.id)
                      ? _selectedMaterial.id
                      : (filtered.isNotEmpty ? filtered.first.id : null),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Seleccionar Material / Litología",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: filtered
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            "${m.name} (${m.category.toUpperCase()})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(
                        () => _selectedMaterial = filtered.firstWhere(
                          (m) => m.id == val,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
              ResponsiveFlexChild(
                expand: !isPortrait,
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 310, child: materialListSidebar),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _buildDetailCard(
                              context,
                              isDark,
                              scrollInternally: true,
                            ),
                          ),
                        ],
                      )
                    : _buildDetailCard(
                        context,
                        isDark,
                        scrollInternally: !isPortrait,
                      ),
              ),
            ],
          );
        },
      ),
    );

    return scrollWholePageInPortrait(isPortrait: isPortrait, child: page);
  }

  Widget _buildDetailCard(
    BuildContext context,
    bool isDark, {
    required bool scrollInternally,
  }) {
    return Card(
      child: OptionalVerticalScroll(
        enabled: scrollInternally,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMaterial.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedMaterial.description,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Chip(label: Text(_selectedMaterial.region)),
                    Chip(
                      label: Text(
                        "Confianza: ${_selectedMaterial.confidence.toUpperCase()}",
                      ),
                      backgroundColor: LithicaColors.logoGreen.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    Chip(
                      label: Text(
                        "Variabilidad: ${_selectedMaterial.variability}",
                      ),
                      backgroundColor: LithicaColors.alterationPurple
                          .withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),

            // MODO INGENIERO: Recomendación Directa
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? LithicaColors.logoGreen.withValues(alpha: 0.12)
                    : const Color(0xFFEEF6EA),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: LithicaColors.logoGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "VALORES DE DISEÑO RECOMENDADOS (MODO INGENIERO)",
                    style: TextStyle(
                      color: isDark
                          ? LithicaColors.logoLime
                          : const Color(0xFF2B6615),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _buildValueTile(
                        "UCS Recomendado",
                        "${_selectedMaterial.recommended.ucs.toInt()} MPa",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Resistencia Tracción",
                        "${_selectedMaterial.recommended.tensile} MPa",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Densidad Seca",
                        "${_selectedMaterial.recommended.density} g/cm³",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Porosidad",
                        "${_selectedMaterial.recommended.porosity}%",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Módulo Young (Ei)",
                        "${_selectedMaterial.recommended.young.toInt()} GPa",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Coeficiente Poisson",
                        "${_selectedMaterial.recommended.poisson}",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Constante mi Intacta",
                        "${_selectedMaterial.recommended.mi.toInt()}",
                        isAccent: true,
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Durabilidad Slake (SDI)",
                        "${_selectedMaterial.recommended.slakeDurability}%",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Velocidad Onda P (Vp)",
                        "${_selectedMaterial.recommended.pWaveVelocity.toInt()} m/s",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Rugosidad Barton (JRC)",
                        "${_selectedMaterial.recommended.jrc.toInt()}",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Resistencia Pared (JCS)",
                        "${_selectedMaterial.recommended.jcs.toInt()} MPa",
                        isDark: isDark,
                      ),
                      _buildValueTile(
                        "Ángulo Fricción (phib)",
                        "${_selectedMaterial.recommended.frictionAngle.toInt()}°",
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // MODO EXPERTO: Contradicciones y Fuentes
            if (widget.isExpertMode) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B2238)
                      : const Color(0xFFF2F4F1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: LithicaColors.alterationPurple.withValues(
                      alpha: 0.3,
                    ),
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
                            "Análisis Bibliográfico & Trazabilidad (Modo Experto)",
                            style: const TextStyle(
                              color: LithicaColors.alterationPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            "Fuentes: ${_selectedMaterial.sources.length}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RockRangeBar(sources: _selectedMaterial.sources),
                    const SizedBox(height: 20),
                    const Text(
                      "Desglose de Fuentes y Autores:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._selectedMaterial.sources.map(
                      (src) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0x33123149)
                              : const Color(0xFFEFE8F5),
                          borderRadius: BorderRadius.circular(12),
                          border: const Border(
                            left: BorderSide(
                              color: LithicaColors.rockCyan,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${src.author} (${src.year})",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? LithicaColors.logoLime
                                    : const Color(0xFF2B6615),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Rango UCS: ${src.ucsRange[0].toInt()} - ${src.ucsRange[1].toInt()} MPa | Factor mi: ${src.mi ?? _selectedMaterial.recommended.mi} ${src.nSamples != null ? ' | Muestras (n): ${src.nSamples}' : ''}",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? const Color(0xFFE5E7EB)
                                    : LithicaColors.logoNavyDeep,
                              ),
                            ),
                            if (src.notes != null)
                              Text(
                                src.notes!,
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
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueTile(
    String label,
    String val, {
    bool isAccent = false,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isAccent
                ? (isDark ? LithicaColors.rockCyan : const Color(0xFF1B7A7A))
                : (isDark ? Colors.white : LithicaColors.logoNavyDeep),
          ),
        ),
      ],
    );
  }
}

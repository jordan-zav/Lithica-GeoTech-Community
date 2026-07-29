import 'package:flutter/material.dart';
import '../data/geotech_kb.dart';
import '../domain/geotech_models.dart';
import '../theme/lithica_theme.dart';
import '../widgets/responsive_page_scroll.dart';

class ISRMPage extends StatefulWidget {
  const ISRMPage({super.key, required this.isExpertMode});

  final bool isExpertMode;

  @override
  State<ISRMPage> createState() => _ISRMPageState();
}

class _ISRMPageState extends State<ISRMPage> {
  String _selectedBookFilter = "all";
  String _selectedCategoryFilter = "all";
  ISRMStandard? _selectedStandard;

  @override
  void initState() {
    super.initState();
    _selectedStandard = EXPANDED_ISRM_STANDARDS.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final filtered = EXPANDED_ISRM_STANDARDS.where((s) {
      final matchesBook =
          _selectedBookFilter == "all" || s.book == _selectedBookFilter;
      final matchesCat =
          _selectedCategoryFilter == "all" ||
          s.category == _selectedCategoryFilter;
      return matchesBook && matchesCat;
    }).toList();

    final page = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Filters
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 850;
              final titleColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Compendio Oficial de Métodos Sugeridos ISRM (1974 - 2024)",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : LithicaColors.logoNavyDeep,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isExpertMode
                        ? "Modo Experto: Especificaciones de Equipamiento, Procedimiento de Laboratorio y Formulación Matemática"
                        : "Normativa oficial de la Sociedad Internacional de Mecánica de Rocas para ensayos, caracterización y monitoreo.",
                    style: TextStyle(
                      color: isDark
                          ? LithicaColors.rockCyan
                          : const Color(0xFF1B7A7A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );

              final filtersRow = Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: isPortrait
                        ? MediaQuery.sizeOf(context).width - 40
                        : null,
                    child: DropdownButton<String>(
                      value: _selectedBookFilter,
                      isExpanded: isPortrait,
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      items: const [
                        DropdownMenuItem(
                          value: "all",
                          child: Text("Todos los Libros"),
                        ),
                        DropdownMenuItem(
                          value: "blue",
                          child: Text("Blue Book (1974-2006)"),
                        ),
                        DropdownMenuItem(
                          value: "orange",
                          child: Text("Orange Book (2007-2014+)"),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedBookFilter = val!),
                    ),
                  ),
                  SizedBox(
                    width: isPortrait
                        ? MediaQuery.sizeOf(context).width - 40
                        : null,
                    child: DropdownButton<String>(
                      value: _selectedCategoryFilter,
                      isExpanded: isPortrait,
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      items: const [
                        DropdownMenuItem(
                          value: "all",
                          child: Text("Todas las Categorías"),
                        ),
                        DropdownMenuItem(
                          value: "Discontinuidades y Macizo Rocoso",
                          child: Text("Macizo & Discontinuidades"),
                        ),
                        DropdownMenuItem(
                          value: "Laboratorio - Propiedades Físicas",
                          child: Text("Propiedades Físicas"),
                        ),
                        DropdownMenuItem(
                          value: "Laboratorio - Compresión",
                          child: Text("Compresión & Triaxial"),
                        ),
                        DropdownMenuItem(
                          value: "Laboratorio - Tracción",
                          child: Text("Tracción (Brasileño)"),
                        ),
                        DropdownMenuItem(
                          value: "Laboratorio - Corte en Juntas",
                          child: Text("Corte en Juntas"),
                        ),
                        DropdownMenuItem(
                          value: "Campo / In-Situ",
                          child: Text("Ensayos In-Situ"),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedCategoryFilter = val!),
                    ),
                  ),
                ],
              );

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleColumn),
                    const SizedBox(width: 16),
                    filtersRow,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleColumn,
                    const SizedBox(height: 12),
                    filtersRow,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Body List + Detail View
          ResponsiveFlexChild(
            expand: !isPortrait,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = !isPortrait && constraints.maxWidth > 850;

                final listWidget = ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 12),
                  itemBuilder: (context, index) {
                    final std = filtered[index];
                    final isSel = _selectedStandard?.id == std.id;
                    final isBlue = std.book == "blue";

                    final bookBackground = isBlue
                        ? (isDark
                              ? const Color(0xFF17354F)
                              : const Color(0xFFE8F0F5))
                        : (isDark
                              ? const Color(0xFF35291F)
                              : const Color(0xFFF4ECE3));
                    final bookBorder = isBlue
                        ? const Color(0xFF5C86A0)
                        : const Color(0xFFA9774D);
                    final bookText = isBlue
                        ? (isDark
                              ? const Color(0xFF8FB4D0)
                              : const Color(0xFF315F7D))
                        : (isDark
                              ? const Color(0xFFD0AA80)
                              : const Color(0xFF80552F));

                    return Container(
                      decoration: BoxDecoration(
                        color: isSel
                            ? (isDark
                                  ? const Color(0xFF163247)
                                  : const Color(0xFFEEF3EA))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSel
                            ? Border(
                                left: BorderSide(
                                  color: isDark
                                      ? LithicaColors.logoLime
                                      : LithicaColors.logoGreen,
                                  width: 3,
                                ),
                              )
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          selected: isSel,
                          selectedColor: isDark
                              ? LithicaColors.logoLime
                              : const Color(0xFF2B6615),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: bookBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: bookBorder),
                            ),
                            child: Text(
                              std.book.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: bookText,
                              ),
                            ),
                          ),
                          title: Text(
                            std.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            "${std.category} (${std.year})",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          onTap: () => setState(() => _selectedStandard = std),
                        ),
                      ),
                    );
                  },
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 380, child: Card(child: listWidget)),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Card(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: _buildDetailView(context, isDark),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue:
                            filtered.any((s) => s.id == _selectedStandard?.id)
                            ? _selectedStandard?.id
                            : (filtered.isNotEmpty ? filtered.first.id : null),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Seleccionar Método Sugerido ISRM",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: filtered.map((std) {
                          return DropdownMenuItem<String>(
                            value: std.id,
                            child: Text(
                              "[${std.book.toUpperCase()} ${std.year}] ${std.title}",
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStandard = filtered.firstWhere(
                                (s) => s.id == val,
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      ResponsiveFlexChild(
                        expand: !isPortrait,
                        child: Card(
                          child: OptionalVerticalScroll(
                            enabled: !isPortrait,
                            padding: const EdgeInsets.all(20),
                            child: _buildDetailView(context, isDark),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    return scrollWholePageInPortrait(isPortrait: isPortrait, child: page);
  }

  Widget _buildDetailView(BuildContext context, bool isDark) {
    if (_selectedStandard == null) {
      return const Center(
        child: Text("Seleccione un método sugerido de la lista."),
      );
    }
    final selectedIsBlue = _selectedStandard!.book == "blue";
    final selectedBookBackground = selectedIsBlue
        ? (isDark ? const Color(0xFF17354F) : const Color(0xFFE8F0F5))
        : (isDark ? const Color(0xFF35291F) : const Color(0xFFF4ECE3));
    final selectedBookBorder = selectedIsBlue
        ? const Color(0xFF5C86A0)
        : const Color(0xFFA9774D);
    final selectedBookText = selectedIsBlue
        ? (isDark ? const Color(0xFF8FB4D0) : const Color(0xFF315F7D))
        : (isDark ? const Color(0xFFD0AA80) : const Color(0xFF80552F));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? LithicaColors.logoNavyDeep
                    : const Color(0xFFE5F4E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: LithicaColors.logoGreen),
              ),
              child: Text(
                _selectedStandard!.code,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? LithicaColors.logoLime
                      : const Color(0xFF255C0E),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: selectedBookBackground,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: selectedBookBorder),
              ),
              child: Text(
                "ISRM ${_selectedStandard!.book.toUpperCase()} BOOK (${_selectedStandard!.year})",
                style: TextStyle(
                  color: selectedBookText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Text(
          _selectedStandard!.title,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          "Comisión: ${_selectedStandard!.commissionName} | Cita: ${_selectedStandard!.publicationInfo}",
          style: TextStyle(
            fontSize: 12,
            color: isDark ? LithicaColors.rockCyan : const Color(0xFF1B7A7A),
          ),
        ),
        const Divider(height: 28),

        const Text(
          "Resumen y Objeto del Método:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          _selectedStandard!.summary,
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 18),

        const Text(
          "Requerimientos y Criterios Clave:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ..._selectedStandard!.keyRequirements.map(
          (req) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: LithicaColors.logoGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(req, style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ),

        if (widget.isExpertMode) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF2F4F1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: LithicaColors.alterationPurple.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Especificación Técnica de Equipamiento (Modo Experto)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LithicaColors.alterationPurple,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ..._selectedStandard!.testEquipment.map(
                  (eq) => Text(
                    "• $eq",
                    style: const TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Procedimiento Paso a Paso:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LithicaColors.alterationPurple,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ..._selectedStandard!.testProcedure.map(
                  (proc) => Text(
                    "-> $proc",
                    style: const TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
        const Text(
          "Resultados y Salidas Calculadas:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x33123149) : const Color(0xFFEEF6EA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: LithicaColors.logoTeal.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            _selectedStandard!.calculatedOutputs,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? LithicaColors.logoLime : const Color(0xFF255C0E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

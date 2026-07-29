class GeotechSource {
  final String author;
  final int year;
  final List<double> ucsRange; // [min, max]
  final double? mi;
  final String confidence; // "alta", "media", "baja"
  final int? nSamples;
  final String? notes;

  const GeotechSource({
    required this.author,
    required this.year,
    required this.ucsRange,
    this.mi,
    required this.confidence,
    this.nSamples,
    this.notes,
  });
}

class RecommendedProperties {
  final double ucs; // MPa
  final double tensile; // MPa
  final double density; // g/cm3
  final double porosity; // %
  final double young; // GPa
  final double poisson;
  final double mi;
  final double slakeDurability; // % (SDI)
  final double pWaveVelocity; // m/s (Vp)
  final double jrc; // Barton Joint Roughness (0-20)
  final double jcs; // Joint Wall Compressive Strength (MPa)
  final double frictionAngle; // degrees (phi_b)

  const RecommendedProperties({
    required this.ucs,
    required this.tensile,
    required this.density,
    this.porosity = 1.5,
    required this.young,
    required this.poisson,
    required this.mi,
    this.slakeDurability = 95.0,
    this.pWaveVelocity = 4500.0,
    this.jrc = 10.0,
    this.jcs = 100.0,
    this.frictionAngle = 35.0,
  });
}

class GeotechMaterial {
  final String id;
  final String name;
  final String category; // "igneous", "sedimentary", "metamorphic", "soil"
  final String description;
  final String region;
  final String confidence;
  final String variability;
  final RecommendedProperties recommended;
  final List<GeotechSource> sources;

  const GeotechMaterial({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.region,
    required this.confidence,
    required this.variability,
    required this.recommended,
    required this.sources,
  });
}

class ISRMStandard {
  final String id;
  final String code; // e.g. "ISRM-SM-01"
  final String book; // "blue", "orange", "updates"
  final String title;
  final int year;
  final String category; // "Laboratorio - Física", "Laboratorio - Resistencia", "Campo / In-Situ", "Discontinuidades", "Geofísica"
  final String commissionName;
  final String publicationInfo;
  final String summary;
  final List<String> keyRequirements;
  final List<String> testEquipment;
  final List<String> testProcedure;
  final String calculatedOutputs;

  const ISRMStandard({
    required this.id,
    required this.code,
    required this.book,
    required this.title,
    required this.year,
    required this.category,
    required this.commissionName,
    required this.publicationInfo,
    required this.summary,
    required this.keyRequirements,
    required this.testEquipment,
    required this.testProcedure,
    required this.calculatedOutputs,
  });
}

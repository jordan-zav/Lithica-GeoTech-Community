import 'dart:convert';

class ESRPreset {
  final String key;
  final String label;
  final String description;
  final double defaultEsr;
  final double minEsr;
  final double maxEsr;

  const ESRPreset({
    required this.key,
    required this.label,
    required this.description,
    required this.defaultEsr,
    required this.minEsr,
    required this.maxEsr,
  });
}

class QSupportRule {
  final int zoneId;
  final String zoneName;
  final double qMin;
  final double qMax;
  final double deMin;
  final double deMax;
  final String supportSummary;
  final String shotcreteDetail;
  final String boltDetail;

  const QSupportRule({
    required this.zoneId,
    required this.zoneName,
    required this.qMin,
    required this.qMax,
    required this.deMin,
    required this.deMax,
    required this.supportSummary,
    required this.shotcreteDetail,
    required this.boltDetail,
  });

  Map<String, dynamic> toJson() {
    return {
      'zone_id': zoneId,
      'zone_name': zoneName,
      'Q_min': qMin,
      'Q_max': qMax,
      'De_min': deMin,
      'De_max': deMax,
      'support': supportSummary,
      'shotcrete': shotcreteDetail,
      'bolts': boltDetail,
    };
  }
}

class QVersionDefinition {
  final String key;
  final String name;
  final String author;
  final int year;
  final String publication;
  final String summary;
  final bool supportsQc;
  final List<QSupportRule> supportRules;

  const QVersionDefinition({
    required this.key,
    required this.name,
    required this.author,
    required this.year,
    required this.publication,
    required this.summary,
    required this.supportsQc,
    required this.supportRules,
  });

  Map<String, dynamic> toJsonDatabaseExport() {
    return {
      'method': 'Q-System',
      'version': key,
      'name': name,
      'author': author,
      'year': year,
      'publication': publication,
      'supports_Qc_normalization': supportsQc,
      'support_rules': supportRules.map((r) => r.toJson()).toList(),
    };
  }

  String toPrettyJsonString() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJsonDatabaseExport());
  }
}

const List<ESRPreset> Q_ESR_PRESETS = [
  ESRPreset(
    key: 'temp_mine',
    label: 'A — Labores mineras temporales',
    description: 'Labores mineras temporales y excavaciones de vida corta',
    defaultEsr: 3.0,
    minEsr: 3.0,
    maxEsr: 5.0,
  ),
  ESRPreset(
    key: 'shaft_circular',
    label: 'B1 — Pique vertical circular',
    description:
        'Piques verticales de sección circular; el valor depende de su finalidad',
    defaultEsr: 2.5,
    minEsr: 2.5,
    maxEsr: 2.5,
  ),
  ESRPreset(
    key: 'shaft_rectangular',
    label: 'B2 — Pique vertical rectangular',
    description:
        'Piques verticales de sección rectangular o cuadrada; puede requerir un valor menor según su finalidad',
    defaultEsr: 2.0,
    minEsr: 2.0,
    maxEsr: 2.0,
  ),
  ESRPreset(
    key: 'perm_mine',
    label: 'C — Labores mineras permanentes',
    description:
        'Labores mineras permanentes, túneles de agua, abastecimiento, pilotos y galerías para grandes excavaciones',
    defaultEsr: 1.6,
    minEsr: 1.6,
    maxEsr: 1.6,
  ),
  ESRPreset(
    key: 'minor_tunnel',
    label: 'D — Túneles menores y accesos',
    description:
        'Túneles menores viales o ferroviarios, cámaras de oscilación, accesos y alcantarillado',
    defaultEsr: 1.3,
    minEsr: 1.3,
    maxEsr: 1.3,
  ),
  ESRPreset(
    key: 'major_civil',
    label: 'E — Infraestructura civil principal',
    description:
        'Casas de máquinas, almacenes, plantas de tratamiento, túneles principales, portales e intersecciones',
    defaultEsr: 1.0,
    minEsr: 1.0,
    maxEsr: 1.0,
  ),
  ESRPreset(
    key: 'critical_public',
    label: 'F — Instalaciones públicas críticas',
    description:
        'Centrales nucleares subterráneas, estaciones ferroviarias, instalaciones deportivas, públicas y fábricas',
    defaultEsr: 0.8,
    minEsr: 0.8,
    maxEsr: 0.8,
  ),
  ESRPreset(
    key: 'very_important',
    label: 'G — Cavernas de muy alta importancia',
    description:
        'Excavaciones con vida útil cercana a 100 años o sin acceso para mantenimiento',
    defaultEsr: 0.5,
    minEsr: 0.5,
    maxEsr: 0.5,
  ),
];

const Map<String, QVersionDefinition> Q_VERSION_DEFINITIONS = {
  'barton1974': QVersionDefinition(
    key: 'barton1974',
    name: 'Barton, Lien & Lunde (1974) - Original',
    author: 'Barton, N., Lien, R. & Lunde, J.',
    year: 1974,
    publication:
        'Engineering Classification of Rock Masses for Design of Tunnel Support. Rock Mechanics',
    summary:
        'Primera formulación del índice Q y carta de diseño empírico inicial para túneles.',
    supportsQc: false,
    supportRules: [
      QSupportRule(
        zoneId: 1,
        zoneName: 'Sin Soporte',
        qMin: 10.0,
        qMax: 1000.0,
        deMin: 0.5,
        deMax: 3.0,
        supportSummary: 'Sin soporte o sostenimiento mínimo',
        shotcreteDetail: '0 cm',
        boltDetail: 'Sin pernos',
      ),
      QSupportRule(
        zoneId: 2,
        zoneName: 'Pernado Ocasional',
        qMin: 1.0,
        qMax: 100.0,
        deMin: 1.0,
        deMax: 6.0,
        supportSummary: 'Pernos puntuales aislados en bloques sueltos',
        shotcreteDetail: 'Sin shotcrete',
        boltDetail: 'Pernos puntuales segun discontinuidades',
      ),
      QSupportRule(
        zoneId: 3,
        zoneName: 'Pernado Sistemático',
        qMin: 0.1,
        qMax: 40.0,
        deMin: 2.0,
        deMax: 10.0,
        supportSummary: 'Pernos en malla sistemática',
        shotcreteDetail: 'Sin shotcrete o sellado local',
        boltDetail: 'Pernos espaciados 1.5 - 2.5 m',
      ),
      QSupportRule(
        zoneId: 4,
        zoneName: 'Pernado + Shotcrete Delgado',
        qMin: 0.04,
        qMax: 10.0,
        deMin: 3.0,
        deMax: 15.0,
        supportSummary: 'Pernos sistemáticos con malla y hormigón proyectado',
        shotcreteDetail: 'Shotcrete 4 - 5 cm',
        boltDetail: 'Pernos espaciados 1.0 - 2.0 m',
      ),
      QSupportRule(
        zoneId: 5,
        zoneName: 'Pernado + Shotcrete Reforzado (5-9 cm)',
        qMin: 0.01,
        qMax: 4.0,
        deMin: 4.0,
        deMax: 20.0,
        supportSummary: 'Hormigón proyectado reforzado y pernos en malla',
        shotcreteDetail: 'Shotcrete 5 - 9 cm',
        boltDetail: 'Pernos espaciados 1.0 - 1.5 m',
      ),
      QSupportRule(
        zoneId: 6,
        zoneName: 'Pernado + Shotcrete Reforzado (9-12 cm)',
        qMin: 0.004,
        qMax: 1.0,
        deMin: 5.0,
        deMax: 25.0,
        supportSummary: 'Shotcrete grueso reforzado y pernos intensivos',
        shotcreteDetail: 'Shotcrete 9 - 12 cm',
        boltDetail: 'Pernos espaciados 1.0 m',
      ),
      QSupportRule(
        zoneId: 7,
        zoneName: 'Pernado + Shotcrete Reforzado (12-15 cm)',
        qMin: 0.001,
        qMax: 0.4,
        deMin: 6.0,
        deMax: 30.0,
        supportSummary: 'Shotcrete pesado reforzado con malla y pernos pesados',
        shotcreteDetail: 'Shotcrete 12 - 15 cm con malla',
        boltDetail: 'Pernos espaciados 0.8 - 1.0 m',
      ),
      QSupportRule(
        zoneId: 8,
        zoneName: 'Revestimiento de Hormigón Armado',
        qMin: 0.001,
        qMax: 0.1,
        deMin: 10.0,
        deMax: 40.0,
        supportSummary: 'Revestimiento continuo de concreto pesado',
        shotcreteDetail: 'Hormigón fundido > 15 cm',
        boltDetail: 'Pernos pesados de anclaje profundo',
      ),
      QSupportRule(
        zoneId: 9,
        zoneName: 'Cerchas Acero + Revestimiento Especial',
        qMin: 0.001,
        qMax: 0.01,
        deMin: 15.0,
        deMax: 50.0,
        supportSummary: 'Arcos/cerchas de acero pesados y vaciado completo',
        shotcreteDetail: 'Revestimiento especial reforzado',
        boltDetail: 'Cerchas TH / H de acero in-situ',
      ),
    ],
  ),

  'grimstad1993': QVersionDefinition(
    key: 'grimstad1993',
    name: 'Grimstad & Barton (1993) - S(fr)',
    author: 'Grimstad, E. & Barton, N.',
    year: 1993,
    publication:
        'Updating of the Q-System for NMT. Proceedings of the International Symposium on Sprayed Concrete',
    summary:
        'Actualización importante que introduce el hormigón proyectado reforzado con fibras de acero S(fr) y nuevas curvas límite.',
    supportsQc: false,
    supportRules: [
      QSupportRule(
        zoneId: 1,
        zoneName: 'Sin Soporte',
        qMin: 5.0,
        qMax: 1000.0,
        deMin: 0.5,
        deMax: 3.5,
        supportSummary: 'Sin sostenimiento requerido',
        shotcreteDetail: '0 cm',
        boltDetail: 'Sin pernos',
      ),
      QSupportRule(
        zoneId: 2,
        zoneName: 'Pernado Puntual sb',
        qMin: 1.0,
        qMax: 100.0,
        deMin: 1.0,
        deMax: 6.5,
        supportSummary: 'Pernos aislados (spot bolting sb)',
        shotcreteDetail: 'Sin proyectado',
        boltDetail: 'Pernos puntuales según bloques',
      ),
      QSupportRule(
        zoneId: 3,
        zoneName: 'Pernado Sistemático B',
        qMin: 0.1,
        qMax: 40.0,
        deMin: 2.0,
        deMax: 11.0,
        supportSummary: 'Pernos en malla sistemática (systematic bolting B)',
        shotcreteDetail: 'Proyectado opcional',
        boltDetail: 'Pernos espaciados 1.3 - 2.0 m',
      ),
      QSupportRule(
        zoneId: 4,
        zoneName: 'Shotcrete con Fibra S(fr) 4-5 cm + Pernos',
        qMin: 0.04,
        qMax: 10.0,
        deMin: 3.0,
        deMax: 16.0,
        supportSummary:
            'Hormigón proyectado con fibras de acero S(fr) 4-5 cm y pernos',
        shotcreteDetail: 'S(fr) 4 - 5 cm',
        boltDetail: 'Pernos espaciados 1.2 - 1.8 m',
      ),
      QSupportRule(
        zoneId: 5,
        zoneName: 'Shotcrete con Fibra S(fr) 5-9 cm + Pernos',
        qMin: 0.01,
        qMax: 4.0,
        deMin: 4.0,
        deMax: 22.0,
        supportSummary: 'Shotcrete con fibras 5-9 cm y pernos sistemáticos',
        shotcreteDetail: 'S(fr) 5 - 9 cm',
        boltDetail: 'Pernos espaciados 1.0 - 1.5 m',
      ),
      QSupportRule(
        zoneId: 6,
        zoneName: 'Shotcrete con Fibra S(fr) 9-12 cm + Pernos',
        qMin: 0.004,
        qMax: 1.0,
        deMin: 5.0,
        deMax: 27.0,
        supportSummary: 'Shotcrete con fibras 9-12 cm y pernos sistemáticos',
        shotcreteDetail: 'S(fr) 9 - 12 cm',
        boltDetail: 'Pernos espaciados 1.0 m',
      ),
      QSupportRule(
        zoneId: 7,
        zoneName: 'Shotcrete con Fibra S(fr) 12-15 cm + Pernos',
        qMin: 0.001,
        qMax: 0.4,
        deMin: 6.0,
        deMax: 32.0,
        supportSummary: 'Shotcrete con fibras 12-15 cm y pernos intensivos',
        shotcreteDetail: 'S(fr) 12 - 15 cm',
        boltDetail: 'Pernos espaciados 0.8 - 1.0 m',
      ),
      QSupportRule(
        zoneId: 8,
        zoneName: 'Arco de Hormigón Armado CCA / RRS',
        qMin: 0.001,
        qMax: 0.1,
        deMin: 10.0,
        deMax: 42.0,
        supportSummary:
            'Arcos de hormigón proyectado reforzado (Cast Concrete Arches CCA)',
        shotcreteDetail: 'S(fr) > 15 cm / CCA',
        boltDetail: 'Pernos de anclaje profundo',
      ),
      QSupportRule(
        zoneId: 9,
        zoneName: 'Revestimiento de Hormigón Armado Completo',
        qMin: 0.001,
        qMax: 0.01,
        deMin: 15.0,
        deMax: 50.0,
        supportSummary:
            'Revestimiento completo de hormigón vaciado con cerchas',
        shotcreteDetail: 'Revestimiento fundido pesado',
        boltDetail: 'Cerchas y pernos intensivos',
      ),
    ],
  ),

  'barton2002': QVersionDefinition(
    key: 'barton2002',
    name: 'Barton (2002) - Qc Normalizado',
    author: 'Barton, N.',
    year: 2002,
    publication:
        'Some new dimension in Q-system application. Tunnelling and Underground Space Technology',
    summary:
        'Actualización moderna con normalización Qc según resistencia intacta (σci / 100) y cuantificación de absorción de energía.',
    supportsQc: true,
    supportRules: [
      QSupportRule(
        zoneId: 1,
        zoneName: 'Sin Soporte',
        qMin: 4.0,
        qMax: 1000.0,
        deMin: 0.5,
        deMax: 4.0,
        supportSummary: 'Sin sostenimiento en rocas de alta calidad',
        shotcreteDetail: '0 cm',
        boltDetail: 'Sin pernos',
      ),
      QSupportRule(
        zoneId: 2,
        zoneName: 'Pernado Puntual sb',
        qMin: 0.8,
        qMax: 100.0,
        deMin: 1.0,
        deMax: 7.0,
        supportSummary: 'Pernos puntuales aislados en bloques',
        shotcreteDetail: 'Sin shotcrete',
        boltDetail: 'Pernos puntuales sb',
      ),
      QSupportRule(
        zoneId: 3,
        zoneName: 'Pernado Sistemático B',
        qMin: 0.1,
        qMax: 40.0,
        deMin: 2.0,
        deMax: 12.0,
        supportSummary: 'Pernos en malla regular',
        shotcreteDetail: 'Shotcrete puntual opcional',
        boltDetail: 'Pernos sistemáticos B',
      ),
      QSupportRule(
        zoneId: 4,
        zoneName: 'Shotcrete con Fibra S(fr) 4-5 cm + Pernos',
        qMin: 0.04,
        qMax: 10.0,
        deMin: 3.0,
        deMax: 18.0,
        supportSummary:
            'Shotcrete reforzado con fibras de acero 4-5 cm + pernos',
        shotcreteDetail: 'S(fr) 4 - 5 cm (E500)',
        boltDetail: 'Pernos espaciados 1.2 - 1.8 m',
      ),
      QSupportRule(
        zoneId: 5,
        zoneName: 'Shotcrete con Fibra S(fr) 5-9 cm + Pernos',
        qMin: 0.01,
        qMax: 4.0,
        deMin: 4.0,
        deMax: 24.0,
        supportSummary: 'Shotcrete con fibras 5-9 cm + pernos sistemáticos',
        shotcreteDetail: 'S(fr) 5 - 9 cm (E700)',
        boltDetail: 'Pernos espaciados 1.0 - 1.5 m',
      ),
      QSupportRule(
        zoneId: 6,
        zoneName: 'Shotcrete con Fibra S(fr) 9-12 cm + Pernos',
        qMin: 0.004,
        qMax: 1.0,
        deMin: 5.0,
        deMax: 28.0,
        supportSummary: 'Shotcrete con fibras 9-12 cm + pernos sistemáticos',
        shotcreteDetail: 'S(fr) 9 - 12 cm (E700/E1000)',
        boltDetail: 'Pernos espaciados 1.0 m',
      ),
      QSupportRule(
        zoneId: 7,
        zoneName: 'Shotcrete con Fibra S(fr) 12-15 cm + Pernos',
        qMin: 0.001,
        qMax: 0.4,
        deMin: 6.0,
        deMax: 34.0,
        supportSummary: 'Shotcrete con fibras 12-15 cm + pernos intensivos',
        shotcreteDetail: 'S(fr) 12 - 15 cm (E1000)',
        boltDetail: 'Pernos espaciados 0.8 - 1.0 m',
      ),
      QSupportRule(
        zoneId: 8,
        zoneName: 'Arcos de Shotcrete Reforzado RRS / CCA',
        qMin: 0.001,
        qMax: 0.1,
        deMin: 10.0,
        deMax: 45.0,
        supportSummary:
            'Reinforced Ribs of Shotcrete (RRS) o arcos de hormigón',
        shotcreteDetail: 'S(fr) > 15 cm + RRS',
        boltDetail: 'Pernos profundos alta capacidad',
      ),
      QSupportRule(
        zoneId: 9,
        zoneName: 'Revestimiento Fundido CCA Pesado',
        qMin: 0.001,
        qMax: 0.01,
        deMin: 15.0,
        deMax: 50.0,
        supportSummary: 'Cast Concrete Arches (CCA) vaciado continuo',
        shotcreteDetail: 'Revestimiento estructural CCA',
        boltDetail: 'Cerchas TH/H + Pernos pesados',
      ),
    ],
  ),
};

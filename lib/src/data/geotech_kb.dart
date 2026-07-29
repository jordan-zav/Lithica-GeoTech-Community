import '../domain/geotech_models.dart';

const List<GeotechMaterial> EXPANDED_GEOTECH_MATERIALS = [
  // =========================================================================
  // 1. ROCAS ÍGNEAS PLUTÓNICAS (FÉLSICAS, INTERMEDIAS, MÁFICAS, ULTRAMÁFICAS)
  // =========================================================================
  GeotechMaterial(
    id: "rock_granite_san_cristobal",
    name: "Granito (Sano / Intacto)",
    category: "igneous",
    description: "Roca ígnea plutónica félsica de grano medio a grueso (cuarzo, K-feldespato, plagioclasa). Alta resistencia y comportamiento frágil.",
    region: "Andes Centrales / Batolito de Lima",
    confidence: "alta",
    variability: "Alta (±25%)",
    recommended: RecommendedProperties(ucs: 180, tensile: 12, density: 2.68, porosity: 0.8, young: 65, poisson: 0.22, mi: 32, slakeDurability: 99.2, pWaveVelocity: 5200, jrc: 12, jcs: 160, frictionAngle: 38),
    sources: [
      GeotechSource(author: "Hoek & Brown", year: 2002, ucsRange: [100, 250], mi: 32, confidence: "alta"),
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [50, 200], mi: 28, confidence: "media"),
      GeotechSource(author: "ISRM Suggested Methods Database", year: 2014, ucsRange: [120, 240], nSamples: 245, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_granodiorite",
    name: "Granodiorita",
    category: "igneous",
    description: "Roca plutónica félsica-intermedia domintante en arcos magmáticos continentales. Mayor contenido de plagioclasa que el granito.",
    region: "Batolito de la Costa / Andes",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 170, tensile: 11.2, density: 2.70, porosity: 0.9, young: 62, poisson: 0.23, mi: 29, slakeDurability: 99.0, pWaveVelocity: 5100, jrc: 11, jcs: 150, frictionAngle: 37),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [110, 230], nSamples: 190, confidence: "alta"),
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [100, 220], mi: 29, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_tonalite",
    name: "Tonalita",
    category: "igneous",
    description: "Roca plutónica intermedia rica en plagioclasa y cuarzo con anfíbol/biotita.",
    region: "Batolito Andino",
    confidence: "alta",
    variability: "Media (±14%)",
    recommended: RecommendedProperties(ucs: 165, tensile: 10.8, density: 2.72, porosity: 1.0, young: 60, poisson: 0.23, mi: 27, slakeDurability: 98.9, pWaveVelocity: 5000, jrc: 11, jcs: 145, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Bieniawski", year: 1989, ucsRange: [100, 210], mi: 27, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_diorite",
    name: "Diorita (Hornbléndica)",
    category: "igneous",
    description: "Roca plutónica intermedia holocristalina sin cuarzo libre. Alta tenacidad.",
    region: "Batolito de la Costa",
    confidence: "alta",
    variability: "Media (±12%)",
    recommended: RecommendedProperties(ucs: 175, tensile: 11.5, density: 2.75, porosity: 0.9, young: 68, poisson: 0.22, mi: 25, slakeDurability: 99.1, pWaveVelocity: 5100, jrc: 11, jcs: 155, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Bieniawski", year: 1989, ucsRange: [120, 230], mi: 25, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_syenite",
    name: "Sienita",
    category: "igneous",
    description: "Roca plutónica alcalina compuesta principalmente por feldespato potásico.",
    region: "Plutones Alcalinos",
    confidence: "media",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 155, tensile: 10.0, density: 2.65, porosity: 1.1, young: 56, poisson: 0.24, mi: 24, slakeDurability: 98.5, pWaveVelocity: 4800, jrc: 10, jcs: 135, frictionAngle: 35),
    sources: [
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [90, 200], mi: 24, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_monzonite",
    name: "Monzonita",
    category: "igneous",
    description: "Roca plutónica con cantidades aproximadas iguales de feldespato K y plagioclasa.",
    region: "Stock Porfídico",
    confidence: "media",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 145, tensile: 9.2, density: 2.68, porosity: 1.3, young: 54, poisson: 0.24, mi: 25, slakeDurability: 98.2, pWaveVelocity: 4700, jrc: 10, jcs: 130, frictionAngle: 35),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [80, 190], mi: 25, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_gabbro",
    name: "Gabro (Máfico Plutónico)",
    category: "igneous",
    description: "Roca plutónica máfica de grano grueso (plagioclasa cálcica, piroxeno). Elevadísima densidad y resistencia.",
    region: "Complejo Ofiolítico",
    confidence: "alta",
    variability: "Baja (±10%)",
    recommended: RecommendedProperties(ucs: 230, tensile: 16, density: 2.95, porosity: 0.5, young: 85, poisson: 0.20, mi: 27, slakeDurability: 99.5, pWaveVelocity: 6000, jrc: 14, jcs: 210, frictionAngle: 40),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [180, 290], nSamples: 110, confidence: "alta"),
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [160, 280], mi: 27, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_anorthosite",
    name: "Anortosita",
    category: "igneous",
    description: "Roca plutónica monominerálica compuesta casi exclusivamente por plagioclasa.",
    region: "Complejos Anortosíticos",
    confidence: "media",
    variability: "Media (±14%)",
    recommended: RecommendedProperties(ucs: 190, tensile: 13, density: 2.72, porosity: 0.6, young: 72, poisson: 0.25, mi: 26, slakeDurability: 99.1, pWaveVelocity: 5400, jrc: 12, jcs: 170, frictionAngle: 37),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [130, 240], confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_peridotite",
    name: "Peridotita / Dunita (Ultramáfica)",
    category: "igneous",
    description: "Roca ultramáfica del manto rica en olivino y piroxeno. Sensible a serpentinización.",
    region: "Manto Superior / Ofiolitas",
    confidence: "alta",
    variability: "Alta (±22%)",
    recommended: RecommendedProperties(ucs: 160, tensile: 11, density: 3.20, porosity: 0.8, young: 80, poisson: 0.24, mi: 25, slakeDurability: 97.5, pWaveVelocity: 5800, jrc: 11, jcs: 140, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Hoek & Brown", year: 1997, ucsRange: [90, 220], mi: 25, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_pyroxenite",
    name: "Piroxenita",
    category: "igneous",
    description: "Roca ultramáfica plutónica compuesta casi por entero de piroxeno.",
    region: "Intrusiones Estratificadas",
    confidence: "media",
    variability: "Baja (±12%)",
    recommended: RecommendedProperties(ucs: 200, tensile: 14.5, density: 3.25, porosity: 0.5, young: 82, poisson: 0.22, mi: 26, slakeDurability: 99.3, pWaveVelocity: 5900, jrc: 13, jcs: 185, frictionAngle: 38),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [150, 260], confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_pegmatite",
    name: "Pegmatita Granítica",
    category: "igneous",
    description: "Roca plutónica de cristales gigantes (> 2.5 cm). Comportamiento mecánico anisótropo por tamaño de cristal.",
    region: "Venas Pegmatíticas",
    confidence: "media",
    variability: "Alta (±30%)",
    recommended: RecommendedProperties(ucs: 130, tensile: 8.0, density: 2.62, porosity: 1.2, young: 45, poisson: 0.25, mi: 28, slakeDurability: 98.0, pWaveVelocity: 4500, jrc: 9, jcs: 110, frictionAngle: 33),
    sources: [
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [60, 190], mi: 28, confidence: "media"),
    ],
  ),

  // =========================================================================
  // 2. ROCAS ÍGNEAS VOLCÁNICAS Y PIROCLÁSTICAS
  // =========================================================================
  GeotechMaterial(
    id: "rock_rhyolite",
    name: "Riolita (Félsica / Sanidínica)",
    category: "igneous",
    description: "Equivalente volcánico del granito. Composición rica en cuarzo y feldespato potásico.",
    region: "Andes del Sur",
    confidence: "alta",
    variability: "Alta (±20%)",
    recommended: RecommendedProperties(ucs: 160, tensile: 10.2, density: 2.52, porosity: 2.8, young: 58, poisson: 0.23, mi: 25, slakeDurability: 97.8, pWaveVelocity: 4600, jrc: 9, jcs: 140, frictionAngle: 34),
    sources: [
      GeotechSource(author: "Hoek & Brown", year: 1997, ucsRange: [90, 220], mi: 25, confidence: "alta"),
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [70, 180], mi: 22, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_dacite",
    name: "Dacita (Volcánica Subplutónica)",
    category: "igneous",
    description: "Roca volcánica subplutónica con fenocristales de cuarzo y plagioclasa.",
    region: "Complejo Volcánico Andino",
    confidence: "media",
    variability: "Media (±16%)",
    recommended: RecommendedProperties(ucs: 135, tensile: 8.8, density: 2.58, porosity: 3.2, young: 48, poisson: 0.25, mi: 25, slakeDurability: 96.5, pWaveVelocity: 4300, jrc: 8, jcs: 120, frictionAngle: 33),
    sources: [
      GeotechSource(author: "Wyllie & Mah", year: 2004, ucsRange: [85, 175], mi: 25, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_andesite",
    name: "Andesita (Porfídica)",
    category: "igneous",
    description: "Roca volcánica extrusiva de composición intermedia. Abundante en franjas metalogenéticas andinas.",
    region: "Cordillera Occidental de los Andes",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 140, tensile: 9.5, density: 2.62, porosity: 1.5, young: 52, poisson: 0.24, mi: 25, slakeDurability: 98.5, pWaveVelocity: 4800, jrc: 10, jcs: 130, frictionAngle: 35),
    sources: [
      GeotechSource(author: "Marinos & Hoek", year: 2000, ucsRange: [100, 200], mi: 25, confidence: "alta"),
      GeotechSource(author: "Wyllie & Mah", year: 2004, ucsRange: [80, 180], mi: 24, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_basalt",
    name: "Basalto (Denso / Levemente Vesicular)",
    category: "igneous",
    description: "Roca volcánica máfica de grano fino. Matriz muy dura con vesículas de desgasificación ocasionales.",
    region: "Global",
    confidence: "alta",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 210, tensile: 14, density: 2.85, porosity: 2.1, young: 78, poisson: 0.21, mi: 25, slakeDurability: 99.0, pWaveVelocity: 5600, jrc: 11, jcs: 180, frictionAngle: 37),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [150, 300], mi: 25, confidence: "alta"),
      GeotechSource(author: "Brady & Brown", year: 2006, ucsRange: [100, 260], mi: 25, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_obsidian",
    name: "Obsidiana (Vidrio Volcánico)",
    category: "igneous",
    description: "Vidrio volcánico amorfo de alta pureza. Fractura concoidal cortante y fragilidad extrema.",
    region: "Domos Riolíticos",
    confidence: "media",
    variability: "Baja (±10%)",
    recommended: RecommendedProperties(ucs: 190, tensile: 13.5, density: 2.38, porosity: 0.1, young: 68, poisson: 0.18, mi: 30, slakeDurability: 99.8, pWaveVelocity: 5200, jrc: 15, jcs: 180, frictionAngle: 42),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [140, 230], confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_pumice_tuff",
    name: "Toba Volcánica / Pómez",
    category: "igneous",
    description: "Roca piroclástica porosa no soldada formada por ceniza y lapilli.",
    region: "Campos Volcánicos",
    confidence: "media",
    variability: "Muy Alta (±40%)",
    recommended: RecommendedProperties(ucs: 25, tensile: 1.8, density: 1.45, porosity: 32.0, young: 8, poisson: 0.32, mi: 13, slakeDurability: 70.0, pWaveVelocity: 1800, jrc: 5, jcs: 20, frictionAngle: 25),
    sources: [
      GeotechSource(author: "Marinos et al.", year: 2005, ucsRange: [8, 55], mi: 13, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_ignimbrite",
    name: "Ignimbrita Soldada",
    category: "igneous",
    description: "Flujo piroclástico colapsado y soldado por calor extremo.",
    region: "Arequipa / Andes del Sur",
    confidence: "alta",
    variability: "Alta (±25%)",
    recommended: RecommendedProperties(ucs: 65, tensile: 4.5, density: 2.15, porosity: 12.0, young: 24, poisson: 0.28, mi: 17, slakeDurability: 92.0, pWaveVelocity: 3400, jrc: 8, jcs: 58, frictionAngle: 30),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [30, 110], nSamples: 85, confidence: "alta"),
    ],
  ),

  // =========================================================================
  // 3. ROCAS SEDIMENTARIAS CLÁSTICAS Y CARBONATADAS / EVAPORITAS
  // =========================================================================
  GeotechMaterial(
    id: "rock_quartz_sandstone",
    name: "Arenisca Cuarcítica (Grano Medio)",
    category: "sedimentary",
    description: "Arenisca detrítica con cemento silíceo masivo. Alta abrasividad y dureza.",
    region: "Grupo Goyllarisquizga",
    confidence: "alta",
    variability: "Alta (±22%)",
    recommended: RecommendedProperties(ucs: 130, tensile: 8.2, density: 2.48, porosity: 6.5, young: 48, poisson: 0.20, mi: 17, slakeDurability: 97.0, pWaveVelocity: 4400, jrc: 10, jcs: 115, frictionAngle: 35),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [70, 200], mi: 17, confidence: "alta"),
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [50, 160], mi: 15, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_arkose",
    name: "Arcosa (Arenisca Feldespática)",
    category: "sedimentary",
    description: "Arenisca rica en feldespatos (>25%) de origen granítico inmaduro.",
    region: "Cuencas Continentales",
    confidence: "media",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 95, tensile: 6.2, density: 2.45, porosity: 9.0, young: 36, poisson: 0.23, mi: 15, slakeDurability: 93.0, pWaveVelocity: 3800, jrc: 8, jcs: 82, frictionAngle: 32),
    sources: [
      GeotechSource(author: "Bieniawski", year: 1989, ucsRange: [50, 140], mi: 15, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_graywacke",
    name: "Grauvaca (Arenisca Lítica)",
    category: "sedimentary",
    description: "Arenisca inmadura recristalizada con matriz arcillosa chlorítica compacta.",
    region: "Complejo Accresionario",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 145, tensile: 9.8, density: 2.65, porosity: 3.5, young: 52, poisson: 0.21, mi: 18, slakeDurability: 98.2, pWaveVelocity: 4700, jrc: 11, jcs: 130, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [90, 200], mi: 18, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_siltstone",
    name: "Limonita / Limoarenisca",
    category: "sedimentary",
    description: "Roca clástica fina intermedia entre arenisca y lutita.",
    region: "Secuencia Flysch",
    confidence: "media",
    variability: "Alta (±25%)",
    recommended: RecommendedProperties(ucs: 60, tensile: 4.2, density: 2.40, porosity: 10.0, young: 25, poisson: 0.27, mi: 9, slakeDurability: 85.0, pWaveVelocity: 3200, jrc: 6, jcs: 52, frictionAngle: 28),
    sources: [
      GeotechSource(author: "Wyllie & Mah", year: 2004, ucsRange: [30, 95], mi: 9, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_shale",
    name: "Lutita / Argilita (Laminada)",
    category: "sedimentary",
    description: "Roca sedimentaria fina fissil. Sensible a humedad y degradación rápida por ciclos de humedecimiento/secado.",
    region: "Formación Chicama",
    confidence: "media",
    variability: "Muy Alta (±30%)",
    recommended: RecommendedProperties(ucs: 35, tensile: 2.5, density: 2.35, porosity: 12.0, young: 16, poisson: 0.32, mi: 7, slakeDurability: 65.0, pWaveVelocity: 2600, jrc: 4, jcs: 28, frictionAngle: 24),
    sources: [
      GeotechSource(author: "Hoek & Brown", year: 1997, ucsRange: [10, 60], mi: 7, confidence: "alta"),
      GeotechSource(author: "Barton", year: 2002, ucsRange: [15, 55], mi: 6, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_conglomerate",
    name: "Conglomerado (Silíceo)",
    category: "sedimentary",
    description: "Roca detrítica con clastos redondeados mayoritariamente cuarcíticos en matriz arenosa.",
    region: "Formación Casapalca",
    confidence: "media",
    variability: "Alta (±25%)",
    recommended: RecommendedProperties(ucs: 75, tensile: 5.0, density: 2.42, porosity: 8.0, young: 30, poisson: 0.26, mi: 19, slakeDurability: 92.0, pWaveVelocity: 3600, jrc: 7, jcs: 65, frictionAngle: 30),
    sources: [
      GeotechSource(author: "Wyllie & Mah", year: 2004, ucsRange: [40, 110], mi: 19, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_micritic_limestone",
    name: "Caliza Micrítica (Densa)",
    category: "sedimentary",
    description: "Caliza de grano ultrafino (lodo carbonatado). Textura homogénea y fractura concoidal.",
    region: "Formación Pucará",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 110, tensile: 7.8, density: 2.62, porosity: 2.5, young: 52, poisson: 0.26, mi: 12, slakeDurability: 97.0, pWaveVelocity: 4600, jrc: 10, jcs: 100, frictionAngle: 34),
    sources: [
      GeotechSource(author: "Hoek & Marinos", year: 2005, ucsRange: [70, 160], mi: 12, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_chalk",
    name: "Creta / Caliza Blanda Porosa",
    category: "sedimentary",
    description: "Caliza biogénica microporosa constituida por cocolitofóridos.",
    region: "Cuencas Marinas Someras",
    confidence: "media",
    variability: "Alta (±30%)",
    recommended: RecommendedProperties(ucs: 18, tensile: 1.2, density: 1.85, porosity: 35.0, young: 6, poisson: 0.33, mi: 7, slakeDurability: 55.0, pWaveVelocity: 2100, jrc: 3, jcs: 15, frictionAngle: 22),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [5, 35], confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_dolomite",
    name: "Dolomía (Cristalina)",
    category: "sedimentary",
    description: "Roca carbonatada rica en magnesio. Mayor dureza y resistencia que la caliza común.",
    region: "Cuenca Cretácica",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 120, tensile: 8.5, density: 2.68, porosity: 3.0, young: 55, poisson: 0.25, mi: 9, slakeDurability: 98.0, pWaveVelocity: 4800, jrc: 10, jcs: 110, frictionAngle: 34),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [80, 170], mi: 9, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_gypsum",
    name: "Yeso (Evaporítico)",
    category: "sedimentary",
    description: "Roca evaporítica blanda de sulfato de calcio hidratado.",
    region: "Depósitos Evaporíticos",
    confidence: "alta",
    variability: "Media (±20%)",
    recommended: RecommendedProperties(ucs: 22, tensile: 1.6, density: 2.30, porosity: 5.0, young: 12, poisson: 0.30, mi: 8, slakeDurability: 45.0, pWaveVelocity: 2800, jrc: 4, jcs: 18, frictionAngle: 25),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [10, 40], confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_anhydrite",
    name: "Anhidrita (Sulfato Anhidro)",
    category: "sedimentary",
    description: "Roca evaporítica de sulfato de calcio anhidro. Expansión masiva al hidratarse a yeso.",
    region: "Secuencias Evaporíticas Profundas",
    confidence: "alta",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 75, tensile: 5.2, density: 2.90, porosity: 1.5, young: 38, poisson: 0.26, mi: 12, slakeDurability: 90.0, pWaveVelocity: 4200, jrc: 8, jcs: 65, frictionAngle: 30),
    sources: [
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [40, 110], mi: 12, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_halite",
    name: "Halita / Sal de Roca",
    category: "sedimentary",
    description: "Evaporita monominerálica de NaCl. Comportamiento visco-plástico (fluencia lenta en túneles).",
    region: "Domos Salinos",
    confidence: "alta",
    variability: "Baja (±12%)",
    recommended: RecommendedProperties(ucs: 30, tensile: 2.0, density: 2.16, porosity: 0.2, young: 20, poisson: 0.35, mi: 15, slakeDurability: 0.0, pWaveVelocity: 4400, jrc: 5, jcs: 25, frictionAngle: 32),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [15, 45], nSamples: 130, confidence: "alta"),
    ],
  ),

  // =========================================================================
  // 4. ROCAS METAMÓRFICAS FOLIADAS Y NO FOLIADAS
  // =========================================================================
  GeotechMaterial(
    id: "rock_slate",
    name: "Pizarra (Arcillosa / Físil)",
    category: "metamorphic",
    description: "Roca de bajo grado metamórfico con pizarrosidad perfecta. Altamente anisótropa.",
    region: "Formación Excelsior",
    confidence: "media",
    variability: "Alta (±28%)",
    recommended: RecommendedProperties(ucs: 55, tensile: 3.8, density: 2.62, porosity: 4.5, young: 28, poisson: 0.29, mi: 7, slakeDurability: 85.0, pWaveVelocity: 3400, jrc: 5, jcs: 48, frictionAngle: 25),
    sources: [
      GeotechSource(author: "Bieniawski", year: 1989, ucsRange: [25, 90], mi: 7, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_phyllite",
    name: "Filita (Sedosa)",
    category: "metamorphic",
    description: "Roca metamórfica de grado intermedio con lustre sedoso por alineación de micas finas.",
    region: "Complejo Metamórfico",
    confidence: "media",
    variability: "Alta (±25%)",
    recommended: RecommendedProperties(ucs: 48, tensile: 3.4, density: 2.65, porosity: 3.8, young: 24, poisson: 0.30, mi: 7, slakeDurability: 82.0, pWaveVelocity: 3200, jrc: 5, jcs: 42, frictionAngle: 24),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [20, 80], mi: 7, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_schist",
    name: "Esquisto (Biotítico / Foliado)",
    category: "metamorphic",
    description: "Roca metamórfica foliada con marcada anisotropía mecánica según el plano de esquistosidad.",
    region: "Complejo Marañón",
    confidence: "media",
    variability: "Alta (±30%)",
    recommended: RecommendedProperties(ucs: 65, tensile: 4.2, density: 2.70, porosity: 2.5, young: 32, poisson: 0.28, mi: 10, slakeDurability: 88.0, pWaveVelocity: 3800, jrc: 6, jcs: 55, frictionAngle: 26),
    sources: [
      GeotechSource(author: "Hoek & Brown", year: 1997, ucsRange: [30, 110], mi: 10, confidence: "alta"),
      GeotechSource(author: "Barton", year: 2002, ucsRange: [25, 90], mi: 8, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_gneiss",
    name: "Gneis (Granítico Bandeado)",
    category: "metamorphic",
    description: "Roca metamórfica de alto grado con alternancia de bandas claras félsicas y oscuras máficas.",
    region: "Macizo del Amazonas",
    confidence: "alta",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 150, tensile: 10.5, density: 2.72, porosity: 1.0, young: 58, poisson: 0.22, mi: 28, slakeDurability: 98.8, pWaveVelocity: 4900, jrc: 11, jcs: 135, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [90, 210], mi: 28, confidence: "alta"),
      GeotechSource(author: "Goodman", year: 1989, ucsRange: [80, 190], mi: 26, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_quartzite",
    name: "Cuarcita (Metamórfica Recristalizada)",
    category: "metamorphic",
    description: "Roca metamórfica extremadamente dura y abrasiva. Fractura concoidal a través de granos.",
    region: "Grupo Chimú",
    confidence: "alta",
    variability: "Baja (±12%)",
    recommended: RecommendedProperties(ucs: 220, tensile: 15, density: 2.65, porosity: 0.4, young: 75, poisson: 0.18, mi: 20, slakeDurability: 99.6, pWaveVelocity: 5800, jrc: 13, jcs: 200, frictionAngle: 39),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [160, 280], nSamples: 180, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_marble",
    name: "Mármol (Calcítico / Recristalizado)",
    category: "metamorphic",
    description: "Roca metamórfica derivada de la recristalización de calizas.",
    region: "Cordillera Blanca",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 110, tensile: 7.5, density: 2.68, porosity: 1.2, young: 52, poisson: 0.25, mi: 9, slakeDurability: 97.5, pWaveVelocity: 4500, jrc: 8, jcs: 100, frictionAngle: 33),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [70, 150], mi: 9, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_amphibolite",
    name: "Anfibolita",
    category: "metamorphic",
    description: "Roca metamórfica recristalizada compuesta por hornblenda y plagioclasa.",
    region: "Escudo Precámbrico",
    confidence: "alta",
    variability: "Media (±14%)",
    recommended: RecommendedProperties(ucs: 175, tensile: 12.0, density: 2.95, porosity: 0.6, young: 70, poisson: 0.23, mi: 26, slakeDurability: 99.2, pWaveVelocity: 5400, jrc: 12, jcs: 160, frictionAngle: 37),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [120, 230], nSamples: 95, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_hornfels",
    name: "Cornubianita / Hornfels",
    category: "metamorphic",
    description: "Roca de metamorfismo de contacto ultra-dura y tenaz de grano fino.",
    region: "Aureola de Contacto",
    confidence: "alta",
    variability: "Baja (±10%)",
    recommended: RecommendedProperties(ucs: 210, tensile: 14.5, density: 2.78, porosity: 0.3, young: 76, poisson: 0.21, mi: 19, slakeDurability: 99.7, pWaveVelocity: 5700, jrc: 13, jcs: 190, frictionAngle: 38),
    sources: [
      GeotechSource(author: "Hoek", year: 2002, ucsRange: [150, 270], mi: 19, confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "rock_serpentinite",
    name: "Serpentinita",
    category: "metamorphic",
    description: "Roca metamórfica derivada de peridotitas alteradas. Caras de fricción extremadamente resbaladizas.",
    region: "Zonas de Cizalla Ofiolíticas",
    confidence: "media",
    variability: "Muy Alta (±35%)",
    recommended: RecommendedProperties(ucs: 50, tensile: 3.5, density: 2.55, porosity: 3.0, young: 22, poisson: 0.31, mi: 13, slakeDurability: 80.0, pWaveVelocity: 3600, jrc: 4, jcs: 40, frictionAngle: 22),
    sources: [
      GeotechSource(author: "Barton", year: 2002, ucsRange: [20, 90], mi: 13, confidence: "media"),
    ],
  ),
  GeotechMaterial(
    id: "rock_skarn",
    name: "Skarn (Calcicosilicatado)",
    category: "metamorphic",
    description: "Roca de metasomatismo de contacto rica en granate, piroxeno y sulfuros.",
    region: "Yacimientos tipo Skarn (Antamina / Bambas)",
    confidence: "alta",
    variability: "Media (±18%)",
    recommended: RecommendedProperties(ucs: 165, tensile: 11.0, density: 3.10, porosity: 0.8, young: 65, poisson: 0.24, mi: 22, slakeDurability: 99.0, pWaveVelocity: 5200, jrc: 11, jcs: 150, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Minera Antamina Geotech", year: 2018, ucsRange: [110, 220], confidence: "alta"),
    ],
  ),

  // =========================================================================
  // 5. SUELOS, DEPÓSITOS CUATERNARIOS Y ROCAS MUY BLANDAS
  // =========================================================================
  GeotechMaterial(
    id: "soil_grava_aluvial",
    name: "Grava Aluvial Densa (Conglomerada)",
    category: "soil",
    description: "Depósito cuaternario potente con bolones y gravas subredondeadas en matriz arenosa.",
    region: "Abanico Aluvial de Lima",
    confidence: "alta",
    variability: "Media (±20%)",
    recommended: RecommendedProperties(ucs: 2.5, tensile: 0.1, density: 2.15, porosity: 22.0, young: 0.35, poisson: 0.30, mi: 5, slakeDurability: 0, pWaveVelocity: 1200, jrc: 0, jcs: 2, frictionAngle: 40),
    sources: [
      GeotechSource(author: "Laboratorios Geotécnicos Peru", year: 2020, ucsRange: [1.0, 4.0], confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "soil_sandy_gravel",
    name: "Grava Arenosa Medianamente Densa",
    category: "soil",
    description: "Depósito fluvial de grava fina a media con matriz de arena silícea.",
    region: "Terrazas Fluviales",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 1.2, tensile: 0.05, density: 1.98, porosity: 26.0, young: 0.18, poisson: 0.32, mi: 4, slakeDurability: 0, pWaveVelocity: 950, jrc: 0, jcs: 1, frictionAngle: 36),
    sources: [
      GeotechSource(author: "Manual Geotécnico de Suelos", year: 2018, ucsRange: [0.5, 2.0], confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "soil_arcilla_alta_plasticidad",
    name: "Arcilla Rígida de Alta Plasticidad (CH)",
    category: "soil",
    description: "Suelo fino cohesivo sobreconsolidado.",
    region: "Depósitos Lacustres",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: RecommendedProperties(ucs: 0.4, tensile: 0.05, density: 1.85, porosity: 38.0, young: 0.08, poisson: 0.35, mi: 4, slakeDurability: 0, pWaveVelocity: 600, jrc: 0, jcs: 0.4, frictionAngle: 20),
    sources: [
      GeotechSource(author: "Manual Geotécnico de Suelos", year: 2018, ucsRange: [0.2, 0.6], confidence: "alta"),
    ],
  ),
  GeotechMaterial(
    id: "soil_loess",
    name: "Loess Eólico (Limo Colapsable)",
    category: "soil",
    description: "Depósito eólico de limo cementado por sales soluble. Propenso a colapso por saturación.",
    region: "Depósitos Eólicos Coquimbano/Andinos",
    confidence: "media",
    variability: "Alta (±30%)",
    recommended: RecommendedProperties(ucs: 0.3, tensile: 0.02, density: 1.45, porosity: 46.0, young: 0.04, poisson: 0.28, mi: 3, slakeDurability: 0, pWaveVelocity: 450, jrc: 0, jcs: 0.3, frictionAngle: 26),
    sources: [
      GeotechSource(author: "ISRM Database", year: 2014, ucsRange: [0.1, 0.5], confidence: "media"),
    ],
  ),
];

// --- COMPENDIO COMPLETO DE MÉTODOS SUGERIDOS ISRM (BLUE BOOK, ORANGE BOOK & ACTUALIZACIONES) ---
const List<ISRMStandard> EXPANDED_ISRM_STANDARDS = [
  // --- CARACTERIZACIÓN DE MACIZO Y DISCONTINUIDADES ---
  ISRMStandard(
    id: "isrm_sm_01",
    code: "ISRM-SM-01",
    book: "blue",
    title: "Suggested Methods for the Quantitative Description of Discontinuities in Rock Masses",
    year: 1978,
    category: "Discontinuidades y Macizo Rocoso",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 15(6): 319-368",
    summary: "Guía sistemática para medir y clasificar los 10 parámetros esenciales de discontinuidades en afloramientos y testigos de perforación.",
    keyRequirements: [
      "1. Orientación (Rumbo / Buzamiento)",
      "2. Espaciamiento de juntas",
      "3. Persistencia y extensión",
      "4. Rugosidad y perfiles JRC",
      "5. Resistencia de paredes (JCS) con martillo Schmidt",
      "6. Apertura y ancho de junta",
      "7. Relleno (naturaleza y dureza)",
      "8. Filtraciones de agua",
      "9. Número de familias de juntas",
      "10. Tamaño de bloques (Jv y RQD)"
    ],
    testEquipment: [
      "Brújula de geólogo tipo Freiberger / Brunton",
      "Martillo Schmidt L-hammer / N-hammer",
      "Peine de rugosidad de Barton",
      "Calibrador vernier y cinta métrica"
    ],
    testProcedure: [
      "Mapeo por celda de detalle (Scanline mapping) o por ventana de afloramiento.",
      "Registro de orientación con la regla de la mano derecha.",
      "Estimación del JRC mediante comparación fotográfica o perfilador de rugosidad.",
      "Ensayo de rebote Schmidt en pared seca de junta para determinar JCS."
    ],
    calculatedOutputs: "Orientación media, JRC (0-20), JCS (MPa), Espaciamiento medio (m), Tamaño de bloque Jv (bloques/m3).",
  ),
  ISRMStandard(
    id: "isrm_sm_02",
    code: "ISRM-SM-02",
    book: "blue",
    title: "Suggested Method for Core Logging and Rock Core Quality Designation (RQD)",
    year: 1978,
    category: "Discontinuidades y Macizo Rocoso",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 15(6): 369-375",
    summary: "Procedimiento estándar para la medición de la recuperación de testigo (TCR), recuperación de roca sana (SCR) y Designación de la Calidad de la Roca (RQD) acuñado por Deere.",
    keyRequirements: [
      "Conteo exclusivo de trozos de testigo sonoros > 10 cm (4 pulgadas).",
      "Exclusión de fracturas mecánicas inducidas por la perforación.",
      "Uso de tubo testigo doble o triple para minimizar alteración."
    ],
    testEquipment: [
      "Caja de testigos estandarizada",
      "Regla rígida graduada en milímetros",
      "Lupa geológica y ácido clorhídrico diluido (10%)"
    ],
    testProcedure: [
      "Alinear los pedazos de testigo encajando las caras naturales.",
      "Medir a lo largo del eje central del testigo cada tramo intacto > 10 cm.",
      "Sumar las longitudes y dividir entre la longitud total de la maniobra."
    ],
    calculatedOutputs: "RQD (%) = (Suma de trozos > 10cm / Longitud maniobra) × 100",
  ),
  ISRMStandard(
    id: "isrm_sm_03",
    code: "ISRM-SM-03",
    book: "orange",
    title: "Suggested Method for Optical and Acoustic Borehole Televiewer Logging",
    year: 2013,
    category: "Discontinuidades y Macizo Rocoso",
    commissionName: "Commission on Borehole Inspection",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 45-62",
    summary: "Inspección continua de paredes de sondeos mediante sensores ópticos (OPTV) y acústicos (ATV) para digitalización 360° de orientación de juntas.",
    keyRequirements: [
      "Imágenes de alta resolución unwrapped (desenrolladas 0-360°).",
      "Inclinómetro digital interno para orientación magnética/geográfica.",
      "Corrección de velocidad acústica según fluido de perforación."
    ],
    testEquipment: [
      "Sonda televiewer acústica ATV / ópticos OPTV",
      "Winche geofísico con contador óptico de profundidad"
    ],
    testProcedure: [
      "Calibrar sonda televiewer en superficie.",
      "Descenso controlado a velocidad < 2 m/min.",
      "Procesamiento digital de trazas sinusoides de juntas."
    ],
    calculatedOutputs: "Diagramas de polos, rosetas de rumbo, mapas de densidad estereográfica, dip y dip direction por metro.",
  ),

  // --- ENSAYOS DE LABORATORIO: PROPIEDADES FÍSICAS E ÍNDICES ---
  ISRMStandard(
    id: "isrm_sm_04",
    code: "ISRM-SM-04",
    book: "blue",
    title: "Suggested Methods for Determining Water Content, Porosity, Density, Absorption and Degree of Saturation",
    year: 1979,
    category: "Laboratorio - Propiedades Físicas",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 16(2): 141-156",
    summary: "Procedimientos gravimétricos y de saturación en vacío para medir los parámetros físicos fundamentales de la matriz rocosa.",
    keyRequirements: [
      "Secado en horno a 105°C ± 3°C durante 24 horas.",
      "Saturación mediante inmersión en agua desgasificada bajo vacío (7 o 20 kPa).",
      "Medición de volumen por técnica de empuje hidrostático (Principio de Arquímedes)."
    ],
    testEquipment: [
      "Horno de secado termostático a 105°C",
      "Balanza analítica con precisión de 0.01 g",
      "Desecador y bomba de vacío hidrostática"
    ],
    testProcedure: [
      "Pesar probeta natural (M1).",
      "Saturar en recipiente de vacío por 24 horas y pesar sumergido (M2) y desparramado (M3).",
      "Secar en horno a 105°C por 24h y determinar peso seco (M4)."
    ],
    calculatedOutputs: "Humedad natural w (%), Porosidad n (%), Densidad seca yd (g/cm3), Grado de saturación Sr (%).",
  ),
  ISRMStandard(
    id: "isrm_sm_05",
    code: "ISRM-SM-05",
    book: "blue",
    title: "Suggested Method for Determining the Slake Durability Index (SDI)",
    year: 1979,
    category: "Laboratorio - Propiedades Físicas",
    commissionName: "Commission on Testing Methods",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 16(2): 157-160",
    summary: "Determinación de la resistencia de rocas blandas, lutitas y pelitas a la desintegración por ciclos combinados de humedecimiento, secado y abrasión.",
    keyRequirements: [
      "Uso de 10 fragmentos de roca de peso individual entre 40 y 60 g (Peso total 450-550 g).",
      "Tambor de malla estándar N° 10 (apertura 2.0 mm) rotando a 20 rpm.",
      "Ciclo de rotación sumergido en agua a 20°C durante 10 minutos (200 revoluciones)."
    ],
    testEquipment: [
      "Equipo de Slake Durability con tanque de agua y motor a 20 rpm",
      "Tambores de malla de alambre N° 10 de acero inoxidable",
      "Horno de secado a 105°C"
    ],
    testProcedure: [
      "Colocar 10 fragmentos secos en el tambor y pesar (Cero).",
      "Sumergir en agua y hacer rotar por 10 min a 20 rpm.",
      "Extraer el tambor, secar en horno a 105°C por 24 horas y pesar (Id1).",
      "Repetir un segundo ciclo completo para determinar el índice durabilidad Id2."
    ],
    calculatedOutputs: "Índice Slake Durability de segundo ciclo Id2 (%) = (Peso retenido seco / Peso inicial) × 100",
  ),
  ISRMStandard(
    id: "isrm_sm_06",
    code: "ISRM-SM-06",
    book: "blue",
    title: "Suggested Method for Determining Point Load Strength (Is50)",
    year: 1985,
    category: "Laboratorio - Índices de Resistencia",
    commissionName: "Commission on Testing Methods",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 22(2): 51-60",
    summary: "Ensayo rápido de carga puntual Is(50) sobre testigos diametrales, axiales o bloques irregulares para estimación indirecta de UCS.",
    keyRequirements: [
      "Puntas cónicas de acero endurecido a 60° con radio de curvatura de 5 mm.",
      "Corrección del diámetro equivalente De al valor de referencia estándar De = 50 mm.",
      "Fórmula de correlación UCS ≈ F × Is(50), donde F varía entre 20 y 25."
    ],
    testEquipment: [
      "Prensa hidráulica portátil con medidor de carga máxima",
      "Marco de carga puntual con puntas cónicas estandarizadas",
      "Calibrador de distancia de puntas"
    ],
    testProcedure: [
      "Posicionar la probeta entre las puntas cónicas.",
      "Incrementar la carga de forma continua de manera que la falla ocurra entre 10 y 60 segundos.",
      "Registrar la carga de falla P y la distancia entre puntas D."
    ],
    calculatedOutputs: "Índice no corregido Is = P / De2, Índice corregido Is(50) = F × Is, Estimación UCS (MPa).",
  ),
  ISRMStandard(
    id: "isrm_sm_07",
    code: "ISRM-SM-07",
    book: "orange",
    title: "Suggested Method for Determining the Cerchar Abrasivity Index (CAI)",
    year: 2014,
    category: "Laboratorio - Abrasividad",
    commissionName: "Commission on Testing Methods",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 115-128",
    summary: "Determinación del índice de abrasividad de la roca Cerchar (CAI) para estimar el desgaste de herramientas de corte (picas, cortadores TBM, brocas).",
    keyRequirements: [
      "Pila de acero estandarizado con dureza Rockwell HRC 54-56.",
      "Fuerza de contacto constante de 70 N aplicada sobre la cara pulida de la roca.",
      "Desplazamiento del punzón sobre una longitud de 10 mm a velocidad de 1 mm/s."
    ],
    testEquipment: [
      "Aparato de ensayo Cerchar estandarizado",
      "Puntas de acero HRC 54-56",
      "Microscopio óptico de medición de plano de desgaste con escala graduada"
    ],
    testProcedure: [
      "Fijar la muestra de roca firmemente en la mordaza del aparato.",
      "Rayar la superficie con el punzón bajo la carga de 70 N en 10 mm de recorrido.",
      "Medir el diámetro plano del desgaste de la punta bajo microscopio en centésimas de milímetro."
    ],
    calculatedOutputs: "Índice CAI = Diámetro de desgaste (mm) × 10. Clasificación: Extremadamente Abrasiva (CAI > 4.5).",
  ),

  // --- ENSAYOS DE LABORATORIO: RESISTENCIA Y MECÁNICA ---
  ISRMStandard(
    id: "isrm_sm_08",
    code: "ISRM-SM-08",
    book: "blue",
    title: "Suggested Method for Determining Uniaxial Compressive Strength and Deformability of Rock Materials",
    year: 1979,
    category: "Laboratorio - Compresión",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 16(2): 135-140",
    summary: "Ensayo fundamental para medir la resistencia a compresión uniaxial (UCS), el Módulo de Young (E) y el Coeficiente de Poisson (v) mediante extensometría.",
    keyRequirements: [
      "Testigos cilindricos con relación L/D de 2.0 a 2.5.",
      "Diámetro de probeta nominalmente 54 mm (Núcleo NX) no menor a 10 veces el tamaño de grano.",
      "Planicidad de caras extremas mejor a 0.02 mm y perpendicularidad mejor a 0.001 rad.",
      "Velocidad de carga constante dentro del rango 0.5 a 1.0 MPa/s."
    ],
    testEquipment: [
      "Prensa servocontrolada de alta rigidez de al menos 1000 kN",
      "Extensómetros LVDT o galgas extensométricas (Strain Gauges) axiales y diametrales",
      "Rectificadora de diamantes para caras de probeta"
    ],
    testProcedure: [
      "Medir diámetro y longitud de la probeta en 3 puntos con micrómetro.",
      "Montar galgas o anillos LVDT axiales y diametrales.",
      "Aplicar carga continua hasta la rotura registrando la curva Tensión vs Deformación axial/lateral."
    ],
    calculatedOutputs: "Resistencia UCS = Pmax / A0 (MPa), Módulo Young tangente/secante E (GPa), Coeficiente Poisson v.",
  ),
  ISRMStandard(
    id: "isrm_sm_09",
    code: "ISRM-SM-09",
    book: "blue",
    title: "Suggested Method for Determining Tensile Strength of Rock Materials (Brazilian Test)",
    year: 1978,
    category: "Laboratorio - Tracción",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Sci. & Geomech. Abstr. 15(3): 99-103",
    summary: "Determinación indirecta de la resistencia a tracción uniaxial de la roca mediante compresión diametral en discos cilíndricos.",
    keyRequirements: [
      "Probetas en forma de disco con relación espesor/diámetro (t/D) entre 0.2 y 0.75.",
      "Mordazas curvadas de carga (Jaw arc) con radio ajustado de 54 mm.",
      "Falla por tracción pura a lo largo del diámetro vertical de carga."
    ],
    testEquipment: [
      "Mordazas de ensayo Brasileño con caras cilíndricas cóncavas",
      "Prensa hidráulica con registro continuo de carga de falla"
    ],
    testProcedure: [
      "Colocar el disco de roca horizontalmente entre las mordazas curvadas.",
      "Aplicar carga a velocidad constante de 0.2 MPa/s hasta la rotura axial del disco."
    ],
    calculatedOutputs: "Resistencia a la Tracción Brasileña ot = (2 × Pmax) / (pi × D × t) (MPa).",
  ),
  ISRMStandard(
    id: "isrm_sm_10",
    code: "ISRM-SM-10",
    book: "orange",
    title: "Suggested Method for Determining the Triaxial Compressive Strength of Rock Materials",
    year: 2007,
    category: "Laboratorio - Triaxial",
    commissionName: "Commission on Testing Methods",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 89-102",
    summary: "Determinación de la envolvente de resistencia no lineal del macizo bajo tensión de confinamiento s3 en celda de compresión Hoek.",
    keyRequirements: [
      "Uso de membrana de caucho impermeable sintético (Neopreno/Viton) rodeando la probeta.",
      "Mantenimiento estricto de la presión hidráulica de confinamiento s3 mediante acumulador de nitrógeno.",
      "Ajuste regresivo del criterio de falla no lineal Hoek-Brown o Mohr-Coulomb."
    ],
    testEquipment: [
      "Celda triaxial Hoek original de alta presión (hasta 70 MPa)",
      "Bomba hidráulica de presión de confinamiento constante",
      "Prensa servocontrolada para carga axial P"
    ],
    testProcedure: [
      "Insertar probeta en la membrana e introducir dentro de la celda Hoek.",
      "Incrementar la presión hidráulica lateral s3 al valor consignado.",
      "Aplicar carga desviadora axial s1 de forma continua hasta la rotura o fluencia."
    ],
    calculatedOutputs: "Envolvente s1 vs s3, Cohesión c (MPa), Ángulo de fricción interna phi (°), Parámetros Hoek-Brown mb, s, a.",
  ),
  ISRMStandard(
    id: "isrm_sm_11",
    code: "ISRM-SM-11",
    book: "orange",
    title: "Suggested Method for Laboratory Direct Shear Testing of Rock Joints",
    year: 2007,
    category: "Laboratorio - Corte en Juntas",
    commissionName: "Commission on Testing Methods",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 103-114",
    summary: "Determinación del comportamiento resistente al corte de discontinuidades naturales o serradas bajo tensión normal sn constante o rigidez normal CNS.",
    keyRequirements: [
      "Encapsulado de los dos bloques de roca con resina epóxica rápida de alta resistencia.",
      "Medición simultánea de la fuerza de corte t, fuerza normal N, desplazamiento horizontal s y dilatancia vertical d.",
      "Ajuste del modelo resistente no lineal de Barton-Bandis t = sn × tan[ JRC × log10(JCS/sn) + phib ]."
    ],
    testEquipment: [
      "Caja de corte directo portátil o de laboratorio servo-hidráulica",
      "Resina de encapsulado de poliuretano / epóxico",
      "LVDT de desplazamiento cortante y dilatancia"
    ],
    testProcedure: [
      "Montar la junta dentro de la caja asegurando la alineación del plano de corte.",
      "Aplicar la tensión normal sn seleccionada.",
      "Desplazar la caja a velocidad de corte constante de 0.1 a 0.5 mm/min registrando la resistencia pico y residual."
    ],
    calculatedOutputs: "Resistencia al corte pico y residual t, Coeficiente JRC movilizado, Ángulo de fricción básica phib (°), Dilatancia dy/dx.",
  ),
  ISRMStandard(
    id: "isrm_sm_12",
    code: "ISRM-SM-12",
    book: "orange",
    title: "Suggested Method for Determining the Fracture Toughness of Rock (Mode I SCB Test)",
    year: 2014,
    category: "Laboratorio - Tenacidad de Fractura",
    commissionName: "Commission on Rock Fracturing",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 129-144",
    summary: "Determinación del factor crítico de intensidad de tensiones Modo I (KIC) mediante el ensayo de viga semi-circular con entalla en flexión (SCB).",
    keyRequirements: [
      "Probeta semi-circular obtenida por corte diametral de testigo cilíndrico.",
      "Entalla mecánica recta introducida en el centro del borde plano de longitud a.",
      "Carga a flexión en tres puntos hasta la propagación inestable de la grieta."
    ],
    testEquipment: [
      "Marco de flexión en tres puntos ajustado",
      "Sierra de disco diamantada ultrafina (ancho < 0.5 mm)",
      "Prensa servocontrolada por desplazamiento CMOD"
    ],
    testProcedure: [
      "Posicionar el disco semicircular entallado sobre los apolyo inferiores.",
      "Cargar el rodillo superior central hasta la iniciación del patrón de fractura.",
      "Determinar la carga pico Pmax."
    ],
    calculatedOutputs: "Tenacidad a la Fractura Modo I KIC (MPa·m^0.5).",
  ),

  // --- ENSAYOS IN-SITU Y MEDICIONES DE CAMPO ---
  ISRMStandard(
    id: "isrm_sm_13",
    code: "ISRM-SM-13",
    book: "blue",
    title: "Suggested Methods for In-Situ Determination of Rock Mass Deformability (Plate Jacking & Radial Jacking)",
    year: 1979,
    category: "Campo / In-Situ",
    commissionName: "Commission on Standardization of Laboratory and Field Tests",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. & Geomech. Abstr. 16(3): 195-214",
    summary: "Medición directa del módulo de deformación (Em) y módulo de elasticidad (Erm) del macizo rocoso mediante placas de carga hidráulica en galerías de ensayo.",
    keyRequirements: [
      "Superficie de ensaye nivelada con mortero epóxico especial de alto módulo.",
      "Placas rígidas de acero de 1.0 m de diámetro cargadas hidráulicamente hasta tensiones de 5 a 10 MPa.",
      "Medición de deformación profunda en el macizo mediante cadenas de extensómetros MPBX."
    ],
    testEquipment: [
      "Gatos hidráulicos de carga de 500 toneladas con bomba de alta precisión",
      "Células de carga y placas de acero rígido de 1m",
      "Extensómetros multinivel de sondeo (MPBX)"
    ],
    testProcedure: [
      "Preparar la nicho o galería de ensayo limpia sin perturbación por voladura.",
      "Aplicar ciclos de carga y descarga en escalones progresivos (1, 2, 5, 10 MPa).",
      "Registrar la deformación elástica plástica en función de la profundidad."
    ],
    calculatedOutputs: "Módulo de deformación del macizo Em (GPa), Módulo elástico del macizo Erm (GPa), Coeficiente de deformación diferida.",
  ),
  ISRMStandard(
    id: "isrm_sm_14",
    code: "ISRM-SM-14",
    book: "orange",
    title: "Suggested Method for Rock Stress Estimation Using Overcoring and Hydraulic Fracturing Methods",
    year: 2003,
    category: "Campo / In-Situ",
    commissionName: "Commission on Rock Stress",
    publicationInfo: "Int. J. Rock Mech. Min. Sci. 40(7-8): 961-1035",
    summary: "Determinación del tensor completo de tensiones in-situ (s1, s2, s3, orientación 3D) mediante células de sobreperforación (CSIRO HI cell) y fracturamiento hidráulico.",
    keyRequirements: [
      "Perforación pilón concéntrica de pequeño diámetro (EX 38 mm) y sobreperforación de gran diámetro (HQ/PQ).",
      "Lectura continua de 12 a 16 galgas extensométricas tridimensionales pegadas a las paredes del sondeo piloto.",
      "Relajación completa de tensiones tras el paso de la corona diamantada de sobreperforación."
    ],
    testEquipment: [
      "Célula tridimensional CSIRO HI Cell / CSIR Doorstopper",
      "Cinta de colocación orientada y resina epóxica de secado bajo agua",
      "Sonda de fracturamiento hidráulico empacadora doble (Packers)"
    ],
    testProcedure: [
      "Ejecutar sondeo primario y extender sondeo piloto EX.",
      "Inyectar resina y posicionar la célula de deformación tridimensional.",
      "Realizar la sobreperforación HQ registrando el salto de deformación elástica de relajación.",
      "Calibrar la matriz elástica en celda biaxial de laboratorio."
    ],
    calculatedOutputs: "Tensor de tensiones 3D (s1, s2, s3 en MPa), Orientación del esfuerzo principal mayor shmin y sHMAX (°).",
  ),
  ISRMStandard(
    id: "isrm_sm_15",
    code: "ISRM-SM-15",
    book: "orange",
    title: "Suggested Method for Monitoring Rock Movements Using Extensometers and Inclinometers",
    year: 2013,
    category: "Campo / In-Situ",
    commissionName: "Commission on Field Instrumentation",
    publicationInfo: "ISRM Book of Suggested Methods 2007-2014, Springer, pp. 165-182",
    summary: "Instalación y lectura sistemática de instrumentación geotécnica subterránea y de superficie para monitoreo de deformaciones en túneles, taludes y cavernas.",
    keyRequirements: [
      "Inclinómetros con sonda MEMS servoblanza de alta resolución (±0.02 mm/m).",
      "Extensómetros de varilla de fibra de vidrio o acero inalterable (Invar) ancorados con lechada.",
      "Automatización de lecturas mediante dataloggers y transmisión inalámbrica IoT."
    ],
    testEquipment: [
      "Cojinetes e inclinómetros de torpedo servobalanza MEMS",
      "Tubería inclinométrica de aluminio/ABS ranurada",
      "Extensómetros de cabeza electrónica multiplexada"
    ],
    testProcedure: [
      "Perforación e inyección de tubería guía inclinométrica.",
      "Pasada de calibración baseline (Lecturas A0 y B0).",
      "Monitoreo temporal continuo trazando la curva de desplazamiento acumulado vs profundidad."
    ],
    calculatedOutputs: "Perfil de desplazamiento horizontal (mm), Profundidad del plano de falla principal (m), Velocidad de deformación (mm/día).",
  ),
];


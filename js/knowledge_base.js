/* ==========================================================================
   LITHICA GEOTECH - VERSIONED SCIENTIFIC KNOWLEDGE BASE DATA STORE
   ========================================================================== */

export const GEOTECH_MATERIALS = [
  {
    id: "rock_granite_san_cristobal",
    name: "Granito (Sano / Intacto)",
    category: "igneous",
    description: "Roca ígnea plutónica de grano medio a grueso. Alta resistencia y comportamiento frágil.",
    region: "Andes Centrales / Batolito de Lima",
    confidence: "alta",
    variability: "Alta (±25%)",
    recommended: {
      ucs: 180, // MPa
      tensile: 12, // MPa
      density: 2.68, // g/cm3
      young: 65, // GPa
      poisson: 0.22,
      mi: 32
    },
    sources: [
      {
        author: "Hoek & Brown",
        year: 2002,
        ucs_range: [100, 250],
        mi: 32,
        confidence: "alta",
        notes: "Muestras de rocas ígneas plutónicas sanas en proyectos de túneles."
      },
      {
        author: "Goodman",
        year: 1989,
        ucs_range: [50, 200],
        mi: 28,
        confidence: "media",
        notes: "Manual de Mecánica de Rocas para ingeniería civil."
      },
      {
        author: "ISRM Suggested Methods Database",
        year: 2014,
        ucs_range: [120, 240],
        n_samples: 245,
        confidence: "alta",
        notes: "Compilatorio Orange Book de ensayos UCS estándar."
      }
    ]
  },
  {
    id: "rock_andesita_porfidica",
    name: "Andesita (Porfídica)",
    category: "igneous",
    description: "Roca ígnea volcánica extrusiva de composición intermedia. Abundante en franjas metalogenéticas andinas.",
    region: "Cordillera Occidental de los Andes",
    confidence: "alta",
    variability: "Media (±15%)",
    recommended: {
      ucs: 140,
      tensile: 9.5,
      density: 2.62,
      young: 52,
      poisson: 0.24,
      mi: 25
    },
    sources: [
      {
        author: "Marinos & Hoek",
        year: 2000,
        ucs_range: [100, 200],
        mi: 25,
        confidence: "alta",
        notes: "Caracterización geomecánica de rocas volcánicas andinas."
      },
      {
        author: "Wyllie & Mah",
        year: 2004,
        ucs_range: [80, 180],
        mi: 24,
        confidence: "media",
        notes: "Ingeniería de Taludes en Roca."
      }
    ]
  },
  {
    id: "rock_basalto_vesicular",
    name: "Basalto (Denso / Levemente Vesicular)",
    category: "igneous",
    description: "Roca volcánica máfica de grano fino. Matriz muy dura con porosidad variable.",
    region: "Global",
    confidence: "alta",
    variability: "Media (±18%)",
    recommended: {
      ucs: 210,
      tensile: 14,
      density: 2.85,
      young: 78,
      poisson: 0.21,
      mi: 25
    },
    sources: [
      {
        author: "Hoek",
        year: 2002,
        ucs_range: [150, 300],
        mi: 25,
        confidence: "alta",
        notes: "Valores promedio de roca intacta en minería subterránea."
      },
      {
        author: "Brady & Brown",
        year: 2006,
        ucs_range: [100, 260],
        mi: 25,
        confidence: "alta",
        notes: "Mecánica de Rocas para Minería Subterránea."
      }
    ]
  },
  {
    id: "rock_caliza_espatica",
    name: "Caliza (Micrítica / Espática)",
    category: "sedimentary",
    description: "Roca sedimentaria carbonatada de origen marino. Sensible a disolución kárstica.",
    region: "Formación Pucará / Andes",
    confidence: "alta",
    variability: "Media (±20%)",
    recommended: {
      ucs: 95,
      tensile: 6.8,
      density: 2.55,
      young: 45,
      poisson: 0.27,
      mi: 12
    },
    sources: [
      {
        author: "Bieniawski",
        year: 1989,
        ucs_range: [50, 140],
        mi: 12,
        confidence: "alta",
        notes: "Clasificación de macizos rocosos en túneles."
      },
      {
        author: "Hoek & Marinos",
        year: 2005,
        ucs_range: [60, 150],
        mi: 12,
        confidence: "alta",
        notes: "Criterio de rotura para rocas sedimentarias carbonatadas."
      }
    ]
  },
  {
    id: "rock_arenisca_cuarcitica",
    name: "Arenisca (Cuarcítica / Grano Medio)",
    category: "sedimentary",
    description: "Roca sedimentaria detrítica con cemento silíceo. Alta abrasividad.",
    region: "Grupo Goyllarisquizga",
    confidence: "alta",
    variability: "Alta (±22%)",
    recommended: {
      ucs: 130,
      tensile: 8.2,
      density: 2.48,
      young: 48,
      poisson: 0.20,
      mi: 17
    },
    sources: [
      {
        author: "Hoek",
        year: 2002,
        ucs_range: [70, 200],
        mi: 17,
        confidence: "alta"
      },
      {
        author: "Goodman",
        year: 1989,
        ucs_range: [50, 160],
        mi: 15,
        confidence: "media"
      }
    ]
  },
  {
    id: "rock_esquisto_biotitico",
    name: "Esquisto (Biotítico / Foliado)",
    category: "metamorphic",
    description: "Roca metamórfica foliada con marcada anisotropía mecánica según el plano de esquistosidad.",
    region: "Complejo Marañón",
    confidence: "media",
    variability: "Alta (±30%)",
    recommended: {
      ucs: 65,
      tensile: 4.2,
      density: 2.70,
      young: 32,
      poisson: 0.28,
      mi: 10
    },
    sources: [
      {
        author: "Hoek & Brown",
        year: 1997,
        ucs_range: [30, 110],
        mi: 10,
        confidence: "alta",
        notes: "Comportamiento anisótropo paralelos/perpendiculares a la folación."
      },
      {
        author: "Barton",
        year: 2002,
        ucs_range: [25, 90],
        mi: 8,
        confidence: "media"
      }
    ]
  }
];

export const ISRM_STANDARDS = [
  {
    id: "isrm_ucs_1979",
    book: "blue",
    title: "Suggested Method for Determining Compressive Strength and Deformability of Rock Materials",
    year: 1979,
    category: "Ensayos de Laboratorio - Compresión",
    summary: "Ensayo estándar de compresión uniaxial (UCS) utilizando probetas cilíndricas con relación L/D de 2.0 a 2.5.",
    key_requirements: [
      "Diámetro de probeta nominalmente 54 mm (núcleo NX).",
      "Relación longitud/diámetro entre 2.0 y 2.5.",
      "Carga aplicada continuamente a una velocidad constante de 0.5 a 1.0 MPa/s."
    ]
  },
  {
    id: "isrm_point_load_1985",
    book: "blue",
    title: "Suggested Method for Determining Point Load Strength (Is50)",
    year: 1985,
    category: "Ensayos de Campo y Laboratorio",
    summary: "Determinación rápida del índice de carga puntual Is(50) en testigos cilíndricos, bloques o fragmentos irregulares.",
    key_requirements: [
      "Determinación del diámetro equivalente De.",
      "Corrección de tamaño al diámetro estándar de 54 mm.",
      "Correlación empírica directa con UCS: UCS ≈ (20 a 25) × Is(50)."
    ]
  },
  {
    id: "isrm_discontinuities_1978",
    book: "blue",
    title: "Suggested Methods for the Quantitative Description of Discontinuities in Rock Masses",
    year: 1978,
    category: "Caracterización de Macizo Rocoso",
    summary: "Guía metodológica para la descripción sistemática de 10 parámetros de discontinuidades en afloramientos y testigos.",
    key_requirements: [
      "Orientación, Espaciamiento, Persistencia, Rugosidad.",
      "Resistencia de las paredes de la junta (JCS).",
      "Apertura, Relleno, Filtraciones, Número de familias y Tamaño de bloque."
    ]
  },
  {
    id: "isrm_triaxial_2007",
    book: "orange",
    title: "Suggested Method for Determining the Triaxial Compressive Strength of Rock Materials",
    year: 2007,
    category: "Ensayos de Laboratorio - Triaxial",
    summary: "Determinación de la envolvente de resistencia bajo tensión confinante σ3 en celda Hoek.",
    key_requirements: [
      "Presión de confinamiento constante durante la falla axil.",
      "Alineamiento de datos para ajuste del criterio Hoek-Brown o Mohr-Coulomb."
    ]
  },
  {
    id: "isrm_p_wave_2014",
    book: "orange",
    title: "Suggested Method for Determining Ultrasonic Wave Velocities in Rock Materials",
    year: 2014,
    category: "Propiedades Geofísicas",
    summary: "Medición de velocidad de onda P y S para estimar módulos elásticos dinámicos (Edyn, νdyn).",
    key_requirements: [
      "Transductores piezoeléctricos acoplados con gel a las caras paralelas.",
      "Frecuencia de pulso típicamente entre 500 kHz y 1 MHz."
    ]
  }
];

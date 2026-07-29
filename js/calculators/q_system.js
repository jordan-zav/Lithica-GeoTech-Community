/* ==========================================================================
   LITHICA GEOTECH - Q-SYSTEM BARTON CALCULATOR MODULE (FULL VECTOR NGI 2015)
   ========================================================================== */

export const Q_JN_OPTIONS = [
  { text: "Masivo, sin o con muy pocas juntas (Jn = 0.5 - 1)", val: 1.0 },
  { text: "Una familia de juntas (Jn = 2)", val: 2.0 },
  { text: "Una familia más una junta ocasional (Jn = 3)", val: 3.0 },
  { text: "Dos familias de juntas (Jn = 4)", val: 4.0 },
  { text: "Dos familias más una junta ocasional (Jn = 6)", val: 6.0 },
  { text: "Tres familias de juntas (Jn = 9)", val: 9.0 },
  { text: "Tres familias más una junta ocasional (Jn = 12)", val: 12.0 },
  { text: "Cuatro familias o más, roca muy fracturada (Jn = 15)", val: 15.0 },
  { text: "Roca desintegrada, terrosa (Jn = 20)", val: 20.0 }
];

export const Q_JR_OPTIONS = [
  { text: "Juntas discontinuas (Jr = 4)", val: 4.0 },
  { text: "Rugosa u ondulada, Ininterrumpida (Jr = 3)", val: 3.0 },
  { text: "Lisa, ondulada (Jr = 2)", val: 2.0 },
  { text: "Friccionada, ondulada (Jr = 1.5)", val: 1.5 },
  { text: "Rugosa o irregular, plana (Jr = 1.5)", val: 1.5 },
  { text: "Lisa, plana (Jr = 1.0)", val: 1.0 },
  { text: "Friccionada, plana (Jr = 0.5)", val: 0.5 },
  { text: "Junta con relleno blando o arcilloso (Jr = 1.0)", val: 1.0 }
];

export const Q_JA_OPTIONS = [
  { text: "Contacto pared-pared sin relleno arcilloso, sana (Ja = 0.75)", val: 0.75 },
  { text: "Paredes de junta levemente alteradas, pátinas (Ja = 1.0)", val: 1.0 },
  { text: "Paredes alteradas con minerales no arcillosos (Ja = 2.0)", val: 2.0 },
  { text: "Pátinas de arcilla limosa (Ja = 3.0)", val: 3.0 },
  { text: "Pátinas de arcilla blando u orgánico (Ja = 4.0)", val: 4.0 },
  { text: "Relleno continuo de arcilla delgada < 5mm (Ja = 6.0)", val: 6.0 },
  { text: "Relleno continuo de arcilla gruesa > 5mm (Ja = 8.0 - 12.0)", val: 10.0 }
];

export const Q_JW_OPTIONS = [
  { text: "Excavación seca o afluencia menor < 5 L/min (Jw = 1.0)", val: 1.0 },
  { text: "Afluencia media o presión moderada (Jw = 0.66)", val: 0.66 },
  { text: "Afluencia grande o alta presión en roca sana (Jw = 0.5)", val: 0.5 },
  { text: "Afluencia o presión excepcionalmente alta (Jw = 0.33)", val: 0.33 },
  { text: "Afluencia o presión excepcionalmente alta continua (Jw = 0.1)", val: 0.1 }
];

export const Q_SRF_OPTIONS = [
  { text: "Zona débil que intersecta excavación, roca suelta (SRF = 5.0)", val: 5.0 },
  { text: "Múltiples zonas débiles (SRF = 10.0)", val: 10.0 },
  { text: "Roca competente, tensiones normales (σc/σ1 > 10) (SRF = 1.0)", val: 1.0 },
  { text: "Tensiones elevadas, estallido de roca leve (σc/σ1 = 2.5 - 5) (SRF = 2.0)", val: 2.0 },
  { text: "Estallido de roca severo (σc/σ1 < 2.5) (SRF = 10.0)", val: 10.0 },
  { text: "Roca deformable / fluencia plástica (SRF = 5.0 - 15.0)", val: 8.0 }
];

export function calculateQ(rqd, jn, jr, ja, jw, srf) {
  const qVal = (rqd / jn) * (jr / ja) * (jw / srf);
  return Math.max(0.001, parseFloat(qVal.toFixed(3)));
}

export function getQQualityCategory(q) {
  if (q >= 400) return "Roca Excepcionalmente Buena";
  if (q >= 100) return "Roca Extremadamente Buena";
  if (q >= 40) return "Roca Muy Buena";
  if (q >= 10) return "Roca Buena";
  if (q >= 4) return "Roca Regular";
  if (q >= 1) return "Roca Mala";
  if (q >= 0.1) return "Roca Muy Mala";
  if (q >= 0.01) return "Roca Extremadamente Mala";
  return "Roca Excepcionalmente Mala";
}

// Barton 2002 / NGI 2015 Support Categories definition enriched with executable engineering parameters
export const BARTON_SUPPORT_ZONES = [
  {
    id: 1,
    name: "Sin Soporte",
    desc: "Excavación estable sin soporte estructural requerido",
    color: "rgba(96, 160, 64, 0.18)",
    stroke: "#60A040",
    shotcreteDesc: "0 cm",
    shotcrete: {
      thickness: "0 cm",
      type: "Sin shotcrete",
      fiber: "Ninguna",
      strength: "N/A",
      application: "No requiere concreto lanzado"
    },
    bolts: {
      required: false,
      type: "Sin pernos (o desatado puntual)",
      diameter: "N/A",
      spacing: "N/A",
      pattern: "Puntual si se requiere",
      location: "N/A"
    },
    mesh: {
      required: "No",
      type: "No requerida",
      location: "N/A"
    },
    girders: {
      required: "No requerido",
      profile: "Ninguno",
      spacing: "N/A"
    },
    constructiveMeaning: "Macizo rocoso extremadamente competente y masivo. La excavación se autosoporta a sección completa sin necesidad de instalar elementos estructurales activos ni pasivos. Únicamente se realiza desatado riguroso (scaling) de bloques sueltos post-voladura."
  },
  {
    id: 2,
    name: "Pernado Ocasional",
    desc: "Pernos de anclaje puntuales según discontinuidades",
    color: "rgba(81, 180, 180, 0.18)",
    stroke: "#51B4B4",
    shotcreteDesc: "Pernos puntuales",
    shotcrete: {
      thickness: "0 - 3 cm",
      type: "Sellado local (si aplica)",
      fiber: "Ninguna",
      strength: "25 MPa",
      application: "Capa de protección localizada en fracturas expuestas"
    },
    bolts: {
      required: true,
      type: "Split Set / Swellex",
      diameter: "22 - 25 mm",
      spacing: "Puntual (2.0 - 2.5 m)",
      pattern: "Puntual en bloques desatados",
      location: "Techo y cuñas en clave"
    },
    mesh: {
      required: "No",
      type: "Opcional en zonas de falla",
      location: "Localizada"
    },
    girders: {
      required: "No requerido",
      profile: "Ninguno",
      spacing: "N/A"
    },
    constructiveMeaning: "El macizo es mayoritariamente estable pero presenta cuñas de roca identificables por intersección de discontinuidades. Se instalan pernos puntuales dirigidos a estabilizar bloques potencialmente inestables inmediatamente después de la ventilación y desatado."
  },
  {
    id: 3,
    name: "Pernado Sistemático",
    desc: "Pernos en cuadrícula (espaciamiento 1.5 - 2.5 m)",
    color: "rgba(109, 159, 222, 0.18)",
    stroke: "#6D9FDE",
    shotcreteDesc: "Pernos S = 1.5-2.5m",
    shotcrete: {
      thickness: "0 - 4 cm",
      type: "Sellado sin fibra / Local",
      fiber: "Ninguna",
      strength: "25 - 30 MPa",
      application: "Shotcrete no estructural para evitar intemperismo"
    },
    bolts: {
      required: true,
      type: "Split Set / Swellex / Barra Helicoidal",
      diameter: "25 mm",
      spacing: "1.5 - 2.5 m",
      pattern: "Cuadrícula o Traba",
      location: "Techo y hastiales superiores"
    },
    mesh: {
      required: "Opcional",
      type: "Electrosoldada 6x6 W2.9/W2.9",
      location: "Techo"
    },
    girders: {
      required: "No requerido",
      profile: "Ninguno",
      spacing: "N/A"
    },
    constructiveMeaning: "Roca de calidad regular a buena con familias de juntas bien definidas. Se requiere un patrón regular de pernos para generar un arco de roca auto-portante alrededor de la bóveda del túnel mediante confinamiento activo o pasivo."
  },
  {
    id: 4,
    name: "Pernado + HP (4-5 cm)",
    desc: "Pernos sistemáticos + Hormigón proyectado 40 - 50 mm",
    color: "rgba(154, 91, 196, 0.18)",
    stroke: "#9A5BC4",
    shotcreteDesc: "HP 4-5 cm",
    shotcrete: {
      thickness: "4 - 5 cm",
      type: "Hormigón Proyectado (HP)",
      fiber: "Opcional (Fibra ligera)",
      strength: "30 MPa",
      application: "Primera capa de sellado inmediato tras la voladura"
    },
    bolts: {
      required: true,
      type: "Barra Helicoidal / Swellex / Cementados",
      diameter: "25 mm",
      spacing: "1.5 - 2.0 m",
      pattern: "Cuadrícula",
      location: "Techo y hastiales"
    },
    mesh: {
      required: "Opcional",
      type: "Electrosoldada 6x6 W2.9/W2.9",
      location: "Techo y paredes"
    },
    girders: {
      required: "No requerido",
      profile: "Ninguno",
      spacing: "N/A"
    },
    constructiveMeaning: "Combina el confinamiento de la masa rocosa mediante pernado sistemático con un sello continuo de shotcrete de 4 a 5 cm para prevenir desprendimientos menores de bloques (spalling) y detener la descompresión temprana."
  },
  {
    id: 5,
    name: "HP con Fibra (5-9 cm) + Pernos",
    desc: "Hormigón proyectado reforzado con fibra (5-9 cm) + Pernado",
    color: "rgba(212, 130, 69, 0.18)",
    stroke: "#D48245",
    shotcreteDesc: "HP Fibra 5-9 cm",
    shotcrete: {
      thickness: "5 - 9 cm",
      type: "Shotcrete con Fibra (Sfr)",
      fiber: "Acero (30-40 kg/m³) o Sintética (4-6 kg/m³)",
      strength: "30 MPa",
      application: "Capa primaria continua con proyección en bóveda y hastiales"
    },
    bolts: {
      required: true,
      type: "Barra Helicoidal cementada / Swellex",
      diameter: "25 mm",
      spacing: "1.3 - 1.8 m",
      pattern: "Cuadrícula",
      location: "Techo + hastiales"
    },
    mesh: {
      required: "No",
      type: "Sustituida por fibra sintética/acero",
      location: "Techo y paredes"
    },
    girders: {
      required: "No requerido",
      profile: "Ninguno",
      spacing: "N/A"
    },
    constructiveMeaning: "La adición de fibra de acero o macro-sintética proporciona alta tenacidad y ductilidad al shotcrete, distribuyendo la carga de deformación del macizo. Elimina la necesidad de instalar malla metálica manual en la clave, reduciendo riesgos operativos."
  },
  {
    id: 6,
    name: "HP con Fibra (9-12 cm) + Pernos",
    desc: "Hormigón proyectado con fibra (9-12 cm) + Pernado reforzado",
    color: "rgba(198, 121, 50, 0.18)",
    stroke: "#C67932",
    shotcreteDesc: "HP Fibra 9-12 cm",
    shotcrete: {
      thickness: "9 - 12 cm",
      type: "Shotcrete con Fibra de alta tenacidad",
      fiber: "Acero (35-45 kg/m³) o Sintética (5-7 kg/m³)",
      strength: "30 MPa",
      application: "1ª Capa (4-5 cm) de sellado inmediato + 2ª Capa definitiva (hasta 12 cm)"
    },
    bolts: {
      required: true,
      type: "Barra Helicoidal con resina/cemento",
      diameter: "25 mm",
      spacing: "1.2 - 1.5 m",
      pattern: "Cuadrícula densa",
      location: "Techo + hastiales completos"
    },
    mesh: {
      required: "Opcional",
      type: "Electrosoldada 6x6 W2.9/W2.9 en hastiales",
      location: "Techo y paredes"
    },
    girders: {
      required: "No requerido",
      profile: "Opcional si hay falla local",
      spacing: "N/A"
    },
    constructiveMeaning: "Sostenimiento estructural pesado para roca mala. El sostenimiento se ejecuta en 2 pasadas de shotcrete: sello de protección de 4-5 cm en el frente, perforación e instalación de pernos sistemáticos, y colocación de la capa final de shotcrete con fibra para completar de 9 a 12 cm."
  },
  {
    id: 7,
    name: "HP con Fibra (12-15 cm) + Pernos",
    desc: "Hormigón proyectado pesado (12-15 cm) + Pernos densos",
    color: "rgba(224, 86, 86, 0.18)",
    stroke: "#E05656",
    shotcreteDesc: "HP Fibra 12-15 cm",
    shotcrete: {
      thickness: "12 - 15 cm",
      type: "Shotcrete estructural pesado reforzado",
      fiber: "Acero (40-50 kg/m³) o Sintética (6-8 kg/m³)",
      strength: "30 - 35 MPa",
      application: "Proyección por capas sucesivas con acelerante de fraguado rápido"
    },
    bolts: {
      required: true,
      type: "Barra Helicoidal cementada / Cable Bolts",
      diameter: "25 - 32 mm",
      spacing: "1.0 - 1.3 m",
      pattern: "Cuadrícula densa",
      location: "Techo, hastiales y solera"
    },
    mesh: {
      required: "Sí",
      type: "Electrosoldada 6x6 W2.9/W2.9 / Q-188",
      location: "Techo y paredes completas"
    },
    girders: {
      required: "Opcional / Recomendado",
      profile: "TH-21 / Lattice Girder",
      spacing: "1.5 m"
    },
    constructiveMeaning: "Roca muy mala susceptible a convergencias rápidas y alta plastificación. Requiere excavación por etapas (avance de bóveda y posterior destrozo). La aplicación de shotcrete de fraguado ultrarrápido en el frente es crítica antes de permitir que el macizo se desajuste."
  },
  {
    id: 8,
    name: "Revestimiento de Hormigón (>15 cm)",
    desc: "Revestimiento continuo de hormigón proyectado o moldeado",
    color: "rgba(180, 60, 120, 0.22)",
    stroke: "#B43C78",
    shotcreteDesc: "Revestimiento >15 cm",
    shotcrete: {
      thickness: "15 - 20 cm",
      type: "Shotcrete estructural denso + Hormigón moldeado",
      fiber: "Acero estructural + Malla",
      strength: "35 MPa",
      application: "Múltiples capas de proyectado y revestimiento de solera (invert)"
    },
    bolts: {
      required: true,
      type: "Barra Helicoidal / Cable Bolt",
      diameter: "25 - 32 mm",
      spacing: "0.8 - 1.0 m",
      pattern: "Cuadrícula muy denso",
      location: "Techo, hastiales y frente"
    },
    mesh: {
      required: "Sí",
      type: "Doble capa Malla Electrosoldada Q-188",
      location: "Techo y hastiales"
    },
    girders: {
      required: "Requerido",
      profile: "Cerchas TH-29 / HEB-140",
      spacing: "1.0 m"
    },
    constructiveMeaning: "Roca extremadamente mala con presencia de esfuerzos destructivos o descomposiciones severas. Exige la instalación de cerchas metálicas pesadas (TH o HEB) integradas dentro de la capa de shotcrete de 15 a 20 cm, y cierre rápido de solera (invert) para formar un anillo estructural cerrado."
  },
  {
    id: 9,
    name: "Revestimiento Especial Armado",
    desc: "Arcos de acero pesados / Revestimiento especial de hormigón armado",
    color: "rgba(150, 40, 150, 0.25)",
    stroke: "#962896",
    shotcreteDesc: "Arcos Acero + HP Armado",
    shotcrete: {
      thickness: "> 20 cm",
      type: "Hormigón Proyectado + Encofrado Moldeado Armado",
      fiber: "Acero / Malla estructural pesada",
      strength: "35 - 40 MPa",
      application: "Múltiples pasadas + hormigonado encofrado definitivo"
    },
    bolts: {
      required: true,
      type: "Cable Bolts / Anclajes de alta capacidad",
      diameter: "32 mm / Cable 15.2mm",
      spacing: "0.8 m",
      pattern: "Cuadrícula pesada + Paraguas de tubo (forepoling)",
      location: "Techo, hastiales, frente y solera"
    },
    mesh: {
      required: "Sí",
      type: "Doble capa de malla electrosoldada estructural",
      location: "Perímetro completo"
    },
    girders: {
      required: "Requerido",
      profile: "HEB-160 / Cerchas TH-36 pesadas",
      spacing: "0.75 - 1.0 m"
    },
    constructiveMeaning: "Condiciones extremas de expansividad, fluencia plástica severa (squeezing) o zonas de falla de gran potencia. Requiere pre-sostenimiento mediante paraguas de tubos cementados (forepoling), excavación a sección reducida, cerchas pesadas en retícula y cierre inmediato de la solera con bóveda invertida."
  }
];

export function calculateBoltLength(span, esr) {
  if (!esr || esr <= 0) esr = 1.0;
  const l = (2 + 0.15 * span) / esr;
  return parseFloat(l.toFixed(2));
}

export function roundBoltLength(lCalc) {
  if (lCalc <= 2.0) return 2.0;
  if (lCalc <= 2.5) return 2.5;
  if (lCalc <= 3.0) return 3.0;
  if (lCalc <= 3.5) return 3.5;
  if (lCalc <= 4.0) return 4.0;
  if (lCalc <= 4.5) return 4.5;
  if (lCalc <= 5.0) return 5.0;
  if (lCalc <= 5.5) return 5.5;
  if (lCalc <= 6.0) return 6.0;
  if (lCalc <= 7.0) return 7.0;
  if (lCalc <= 8.0) return 8.0;
  return Math.ceil(lCalc * 2) / 2;
}

export function getBartonSupportZone(Q, De) {
  const limit1 = 2.2 * Math.pow(Q, 0.42);
  const limit2 = 4.2 * Math.pow(Q, 0.40);
  const limit3 = 7.5 * Math.pow(Q, 0.38);
  const limit4 = 12.0 * Math.pow(Q, 0.36);
  const limit5 = 18.0 * Math.pow(Q, 0.34);
  const limit6 = 26.0 * Math.pow(Q, 0.32);
  const limit7 = 35.0 * Math.pow(Q, 0.30);
  const limit8 = 48.0 * Math.pow(Q, 0.28);

  if (De <= limit1) return BARTON_SUPPORT_ZONES[0];
  if (De <= limit2) return BARTON_SUPPORT_ZONES[1];
  if (De <= limit3) return BARTON_SUPPORT_ZONES[2];
  if (De <= limit4) return BARTON_SUPPORT_ZONES[3];
  if (De <= limit5) return BARTON_SUPPORT_ZONES[4];
  if (De <= limit6) return BARTON_SUPPORT_ZONES[5];
  if (De <= limit7) return BARTON_SUPPORT_ZONES[6];
  if (De <= limit8) return BARTON_SUPPORT_ZONES[7];
  return BARTON_SUPPORT_ZONES[8];
}

export function renderQSupportChart(canvasId, Q, De) {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  const width = canvas.width;
  const height = canvas.height;

  ctx.clearRect(0, 0, width, height);

  const isLight = document.body.classList.contains('light-theme');

  // Fill background
  ctx.fillStyle = isLight ? "#F8FAFC" : "#0A2233";
  ctx.fillRect(0, 0, width, height);

  // Padding & Plot dimensions (Log-Log chart with dual Y axes)
  const padL = 60;
  const padR = 65; // Extended for Right Y-Axis (Bolt Length)
  const padT = 55; // Extended for Top Category Bar
  const padB = 45;
  const plotW = width - padL - padR;
  const plotH = height - padT - padB;

  const minQLog = -3; // 0.001
  const maxQLog = 3;  // 1000
  const minDeLog = Math.log10(0.5); // ~ -0.301
  const maxDeLog = Math.log10(50);  // ~ 1.699

  function qToX(qVal) {
    const qClamped = Math.max(0.001, Math.min(1000, qVal));
    const logQ = Math.log10(qClamped);
    return padL + ((logQ - minQLog) / (maxQLog - minQLog)) * plotW;
  }

  function deToY(deVal) {
    const deClamped = Math.max(0.5, Math.min(50, deVal));
    const logDe = Math.log10(deClamped);
    return height - padB - ((logDe - minDeLog) / (maxDeLog - minDeLog)) * plotH;
  }

  // 1. Draw Top Header Bar for Rock Mass Quality Ratings (Barton NGI Standard)
  const qualityCategories = [
    { name: "Excepc. Mala", min: 0.001, max: 0.01, color: "rgba(180, 60, 120, 0.4)" },
    { name: "Extrem. Mala", min: 0.01, max: 0.1, color: "rgba(224, 86, 86, 0.4)" },
    { name: "Muy Mala", min: 0.1, max: 1, color: "rgba(212, 130, 69, 0.4)" },
    { name: "Mala", min: 1, max: 4, color: "rgba(198, 121, 50, 0.4)" },
    { name: "Regular", min: 4, max: 10, color: "rgba(154, 91, 196, 0.4)" },
    { name: "Buena", min: 10, max: 40, color: "rgba(109, 159, 222, 0.4)" },
    { name: "Muy Buena", min: 40, max: 100, color: "rgba(81, 180, 180, 0.4)" },
    { name: "Extrem. Buena", min: 100, max: 400, color: "rgba(96, 160, 64, 0.4)" },
    { name: "Excepc. Buena", min: 400, max: 1000, color: "rgba(128, 192, 48, 0.4)" }
  ];

  const topBarY = 16;
  const topBarH = 22;

  qualityCategories.forEach(cat => {
    const x1 = qToX(cat.min);
    const x2 = qToX(cat.max);
    const catW = x2 - x1;

    ctx.fillStyle = cat.color;
    ctx.fillRect(x1, topBarY, catW, topBarH);

    ctx.strokeStyle = isLight ? "rgba(15, 23, 42, 0.2)" : "rgba(255, 255, 255, 0.2)";
    ctx.lineWidth = 1;
    ctx.strokeRect(x1, topBarY, catW, topBarH);

    if (catW > 25) {
      ctx.fillStyle = isLight ? "#0F172A" : "#FFFFFF";
      ctx.font = "bold 9px Inter, sans-serif";
      ctx.textAlign = "center";
      ctx.fillText(cat.name, x1 + catW / 2, topBarY + 14);
    }
  });

  // Draw Barton Support Zone Curves & Shaded Background Bands
  const activeZone = getBartonSupportZone(Q, De);
  const boundaryCurves = [
    { exp: 0.42, coef: 2.2, zone: BARTON_SUPPORT_ZONES[0], thick: "0 cm" },
    { exp: 0.40, coef: 4.2, zone: BARTON_SUPPORT_ZONES[1], thick: "5 cm" },
    { exp: 0.38, coef: 7.5, zone: BARTON_SUPPORT_ZONES[2], thick: "6 cm" },
    { exp: 0.36, coef: 12.0, zone: BARTON_SUPPORT_ZONES[3], thick: "9 cm" },
    { exp: 0.34, coef: 18.0, zone: BARTON_SUPPORT_ZONES[4], thick: "12 cm" },
    { exp: 0.32, coef: 26.0, zone: BARTON_SUPPORT_ZONES[5], thick: "15 cm" },
    { exp: 0.30, coef: 35.0, zone: BARTON_SUPPORT_ZONES[6], thick: "25 cm" },
    { exp: 0.28, coef: 48.0, zone: BARTON_SUPPORT_ZONES[7], thick: "RRS / Arcos" }
  ];

  // Draw Zone Shading Bands
  for (let bIdx = boundaryCurves.length - 1; bIdx >= 0; bIdx--) {
    const curve = boundaryCurves[bIdx];
    ctx.beginPath();
    ctx.moveTo(padL, height - padB);

    const steps = 60;
    for (let i = 0; i <= steps; i++) {
      const qVal = Math.pow(10, minQLog + (i / steps) * (maxQLog - minQLog));
      const deVal = curve.coef * Math.pow(qVal, curve.exp);
      const x = qToX(qVal);
      const y = deToY(deVal);
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }

    ctx.lineTo(padL + plotW, height - padB);
    ctx.closePath();

    ctx.fillStyle = curve.zone.color;
    ctx.fill();
  }

  // Draw Energy Absorption Lines (E = 500J, 700J, 1000J) for squeezing conditions
  const energyLines = [
    { label: "E = 500 J", slope: -0.45, yInterceptDe: 2.2 },
    { label: "E = 700 J", slope: -0.45, yInterceptDe: 4.0 },
    { label: "E = 1000 J", slope: -0.45, yInterceptDe: 7.5 }
  ];

  energyLines.forEach(el => {
    ctx.beginPath();
    const steps = 30;
    for (let i = 0; i <= steps; i++) {
      const qVal = Math.pow(10, -3 + (i / steps) * 2.0); // 0.001 to 0.1
      const deVal = el.yInterceptDe * Math.pow(qVal / 0.001, el.slope);
      const x = qToX(qVal);
      const y = deToY(deVal);
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.strokeStyle = "rgba(154, 91, 196, 0.6)";
    ctx.lineWidth = 1.5;
    ctx.setLineDash([4, 3]);
    ctx.stroke();
    ctx.setLineDash([]);

    const labelX = qToX(0.003);
    const labelY = deToY(el.yInterceptDe * Math.pow(0.003 / 0.001, el.slope));
    if (labelX > padL && labelY > padT && labelY < height - padB) {
      ctx.fillStyle = "rgba(154, 91, 196, 0.9)";
      ctx.font = "bold 9px Fira Code, monospace";
      ctx.fillText(el.label, labelX + 2, labelY - 3);
    }
  });

  // Draw Bolt Spacing Iso-Curves with Shotcrete & Without Shotcrete
  const boltCurves = [
    { label: "1.0m c/c", coef: 14.0, exp: 0.35 },
    { label: "1.5m c/c", coef: 9.0, exp: 0.37 },
    { label: "2.0m c/c", coef: 5.5, exp: 0.39 },
    { label: "2.5m c/c", coef: 3.0, exp: 0.41 },
    { label: "3.0m s/s", coef: 1.8, exp: 0.43 },
    { label: "4.0m s/s", coef: 0.9, exp: 0.45 }
  ];

  boltCurves.forEach(bc => {
    ctx.beginPath();
    const steps = 40;
    for (let i = 0; i <= steps; i++) {
      const qVal = Math.pow(10, minQLog + (i / steps) * (maxQLog - minQLog));
      const deVal = bc.coef * Math.pow(qVal, bc.exp);
      const x = qToX(qVal);
      const y = deToY(deVal);
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.strokeStyle = isLight ? "rgba(100, 116, 139, 0.35)" : "rgba(255, 255, 255, 0.25)";
    ctx.lineWidth = 1;
    ctx.setLineDash([2, 3]);
    ctx.stroke();
    ctx.setLineDash([]);
  });

  // Draw Boundary Lines, Shotcrete Thickness Callouts & Zone Watermarks
  boundaryCurves.forEach((curve, idx) => {
    ctx.beginPath();
    const steps = 60;
    for (let i = 0; i <= steps; i++) {
      const qVal = Math.pow(10, minQLog + (i / steps) * (maxQLog - minQLog));
      const deVal = curve.coef * Math.pow(qVal, curve.exp);
      const x = qToX(qVal);
      const y = deToY(deVal);
      if (i === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }

    const isActiveBoundary = (activeZone && activeZone.id === curve.zone.id);
    ctx.strokeStyle = isActiveBoundary ? "#80C030" : (isLight ? "rgba(71, 85, 105, 0.4)" : "rgba(64, 112, 128, 0.4)");
    ctx.lineWidth = isActiveBoundary ? 2.5 : 1.2;
    if (!isActiveBoundary) ctx.setLineDash([4, 4]);
    else ctx.setLineDash([]);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw Shotcrete Thickness Callout on the boundary line
    const calloutQ = Math.pow(10, -0.5 + idx * 0.4);
    const calloutDe = curve.coef * Math.pow(calloutQ, curve.exp);
    const cx = qToX(calloutQ);
    const cy = deToY(calloutDe);
    if (cx > padL && cx < padL + plotW - 20 && cy > padT + 10 && cy < height - padB - 10) {
      ctx.fillStyle = isLight ? "#0F172A" : "#FFFFFF";
      ctx.font = "bold 9px Fira Code, monospace";
      ctx.textAlign = "center";
      ctx.fillText(curve.thick, cx, cy - 4);
    }

    // Draw Zone Number Watermarks
    const labelQ = Math.pow(10, -2.2 + idx * 0.62);
    const labelDe = curve.coef * Math.pow(labelQ, curve.exp) * 0.72;
    const lx = qToX(labelQ);
    const ly = deToY(labelDe);
    if (lx > padL && lx < padL + plotW && ly > padT + 10 && ly < height - padB) {
      ctx.fillStyle = isLight ? "rgba(15, 23, 42, 0.5)" : "rgba(255, 255, 255, 0.5)";
      ctx.font = "bold 10px Outfit, sans-serif";
      ctx.fillText(`Zona ${curve.zone.id}`, lx, ly);
    }
  });

  // Draw Grid Lines & Axis Ticks
  ctx.strokeStyle = isLight ? "rgba(148, 163, 184, 0.25)" : "rgba(64, 112, 128, 0.25)";
  ctx.lineWidth = 1;

  // Q Ticks (0.001, 0.01, 0.1, 1, 10, 100, 1000)
  const qTicks = [0.001, 0.01, 0.1, 1, 10, 100, 1000];
  qTicks.forEach(tick => {
    const x = qToX(tick);
    ctx.beginPath();
    ctx.moveTo(x, padT);
    ctx.lineTo(x, height - padB);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "center";
    ctx.fillText(tick >= 1 ? tick.toString() : tick.toFixed(3), x, height - padB + 16);
  });

  // Left De Ticks (0.5, 1, 2, 5, 10, 20, 50)
  const deTicks = [0.5, 1, 2, 5, 10, 20, 50];
  deTicks.forEach(tick => {
    const y = deToY(tick);
    ctx.beginPath();
    ctx.moveTo(padL, y);
    ctx.lineTo(padL + plotW, y);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "right";
    ctx.fillText(`${tick}m`, padL - 8, y + 4);

    // Right Y-Axis (Bolt Length L = 2 + 0.15 * De for ESR = 1)
    const boltL = (2 + 0.15 * tick).toFixed(1);
    ctx.textAlign = "left";
    ctx.fillText(`${boltL}m`, padL + plotW + 8, y + 4);
  });

  // Right Y-Axis Title (Bolt Length)
  ctx.save();
  ctx.translate(width - 12, padT + plotH / 2);
  ctx.rotate(Math.PI / 2);
  ctx.fillStyle = "#51B4B4";
  ctx.font = "bold 10px Outfit, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("Longitud del Perno L (m) para ESR = 1", 0, 0);
  ctx.restore();

  // Left Y-Axis Title
  ctx.save();
  ctx.translate(18, padT + plotH / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillStyle = "#80C030";
  ctx.font = "bold 11px Outfit, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("Dimensión Equivalente De = Luz / ESR (m)", 0, 0);
  ctx.restore();

  // Bottom X-Axis Title
  ctx.fillStyle = "#80C030";
  ctx.font = "bold 11px Outfit, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("Calidad de la Masa Rocosa Q = (RQD/Jn) × (Jr/Ja) × (Jw/SRF)", padL + plotW / 2, height - 6);

  // Plot User Operating Point (Q, De)
  const curX = qToX(Q);
  const curY = deToY(De);
  const userBoltL = (2 + 0.15 * De).toFixed(1);

  // Dashed crosshairs connecting point to axes
  ctx.strokeStyle = "rgba(128, 192, 48, 0.6)";
  ctx.lineWidth = 1;
  ctx.setLineDash([3, 3]);

  ctx.beginPath();
  ctx.moveTo(curX, height - padB);
  ctx.lineTo(curX, curY);
  ctx.lineTo(padL, curY);
  ctx.lineTo(padL + plotW, curY);
  ctx.stroke();
  ctx.setLineDash([]);

  // Outer Glowing Pulse Circle
  ctx.beginPath();
  ctx.arc(curX, curY, 12, 0, 2 * Math.PI);
  ctx.fillStyle = "rgba(128, 192, 48, 0.25)";
  ctx.fill();
  ctx.strokeStyle = "#80C030";
  ctx.lineWidth = 2;
  ctx.stroke();

  // Core Solid Marker Point
  ctx.beginPath();
  ctx.arc(curX, curY, 5, 0, 2 * Math.PI);
  ctx.fillStyle = "#FFFFFF";
  ctx.fill();

  // HUD Box removed from inside canvas per user request (moved to external card below)
}

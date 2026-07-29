/* ==========================================================================
   LITHICA GEOTECH - RMR CALCULATOR MODULE (BIENIAWSKI 1973, 1976, 1989 & RMR14)
   ========================================================================== */

export const RMR_VERSIONS = {
  rmr89: {
    name: "Bieniawski 1989 (RMR89)",
    author: "Bieniawski, Z.T. (1989)",
    ref: "Engineering Rock Mass Classifications, John Wiley & Sons",
    p1_options: [
      { text: "UCS > 250 MPa | PLI > 10 MPa", score: 15 },
      { text: "UCS 100 - 250 MPa | PLI 4 - 10 MPa", score: 12 },
      { text: "UCS 50 - 100 MPa | PLI 2 - 4 MPa", score: 7 },
      { text: "UCS 25 - 50 MPa | PLI 1 - 2 MPa", score: 4 },
      { text: "UCS 5 - 25 MPa | Sin carga puntual", score: 2 },
      { text: "UCS 1 - 5 MPa", score: 1 },
      { text: "UCS < 1 MPa", score: 0 }
    ],
    p3_options: [
      { text: "> 2.0 m (Muy ancho)", score: 20 },
      { text: "0.6 - 2.0 m (Ancho)", score: 15 },
      { text: "200 - 600 mm (Moderado)", score: 10 },
      { text: "60 - 200 mm (Estrecho)", score: 8 },
      { text: "< 60 mm (Muy estrecho)", score: 5 }
    ],
    p4_options: [
      { text: "Superficies muy rugosas, no continuas, sin separación, pared de roca sana", score: 30 },
      { text: "Ligeramente rugosas, separación < 1 mm, paredes ligeramente alteradas", score: 25 },
      { text: "Ligeramente rugosas, separación < 1 mm, paredes muy alteradas", score: 20 },
      { text: "Superficies lisas o relleno < 5 mm o apertura 1 - 5 mm, continuas", score: 10 },
      { text: "Relleno blando > 5 mm o apertura > 5 mm, continuas", score: 0 }
    ],
    p5_options: [
      { text: "Completamente seco (Flujo = 0 L/min)", score: 15 },
      { text: "Ligeramente húmedo (Flujo < 10 L/min)", score: 10 },
      { text: "Húmedo (Flujo 10 - 25 L/min)", score: 7 },
      { text: "Goteando (Flujo 25 - 125 L/min)", score: 4 },
      { text: "Agua a presión (Flujo > 125 L/min)", score: 0 }
    ],
    p6_options: [
      { text: "Muy Favorable", score: 0 },
      { text: "Favorable", score: -2 },
      { text: "Regular", score: -5 },
      { text: "Desfavorable", score: -10 },
      { text: "Muy Desfavorable", score: -12 }
    ]
  },

  rmr76: {
    name: "Bieniawski 1976 (RMR76)",
    author: "Bieniawski, Z.T. (1976)",
    ref: "Rock Mass Classification in Jointed Rock Masses",
    p1_options: [
      { text: "UCS > 200 MPa | PLI > 8 MPa", score: 15 },
      { text: "UCS 100 - 200 MPa | PLI 4 - 8 MPa", score: 12 },
      { text: "UCS 50 - 100 MPa | PLI 2 - 4 MPa", score: 7 },
      { text: "UCS 25 - 50 MPa | PLI 1 - 2 MPa", score: 4 },
      { text: "UCS < 25 MPa", score: 0 }
    ],
    p3_options: [
      { text: "> 3.0 m", score: 20 },
      { text: "1.0 - 3.0 m", score: 15 },
      { text: "0.3 - 1.0 m", score: 10 },
      { text: "50 - 300 mm", score: 8 },
      { text: "< 50 mm", score: 5 }
    ],
    p4_options: [
      { text: "Superficies muy rugosas, cerradas, paredes no alteradas", score: 25 },
      { text: "Ligeramente rugosas, separación < 1 mm", score: 20 },
      { text: "Superficies lisas o pared alterada", score: 12 },
      { text: "Superficies de fricción / Relleno < 5 mm", score: 6 },
      { text: "Relleno blando > 5 mm", score: 0 }
    ],
    p5_options: [
      { text: "Completamente seco", score: 10 },
      { text: "Húmedo", score: 7 },
      { text: "Moja la mano", score: 4 },
      { text: "Goteando", score: 2 },
      { text: "Agua a presión", score: 0 }
    ],
    p6_options: [
      { text: "Muy Favorable", score: 0 },
      { text: "Favorable", score: -2 },
      { text: "Regular", score: -5 },
      { text: "Desfavorable", score: -10 },
      { text: "Muy Desfavorable", score: -12 }
    ]
  },

  rmr73: {
    name: "Bieniawski 1973 (RMR73 Histórico)",
    author: "Bieniawski, Z.T. (1973)",
    ref: "Engineering Classification of Jointed Rock Masses",
    p1_options: [
      { text: "UCS > 200 MPa", score: 10 },
      { text: "UCS 100 - 200 MPa", score: 9 },
      { text: "UCS 50 - 100 MPa", score: 7 },
      { text: "UCS 25 - 50 MPa", score: 4 },
      { text: "UCS < 25 MPa", score: 1 }
    ],
    p3_options: [
      { text: "> 3.0 m", score: 30 },
      { text: "1.0 - 3.0 m", score: 25 },
      { text: "0.3 - 1.0 m", score: 20 },
      { text: "50 - 300 mm", score: 10 },
      { text: "< 50 mm", score: 5 }
    ],
    p4_options: [
      { text: "Paredes de junta sanas y rugosas", score: 25 },
      { text: "Ligeramente alteradas y rugosas", score: 18 },
      { text: "Lisas y alteradas", score: 10 },
      { text: "Mucha alteración o relleno", score: 0 }
    ],
    p5_options: [
      { text: "Seco", score: 10 },
      { text: "Húmedo", score: 7 },
      { text: "Goteando", score: 2 }
    ],
    p6_options: [
      { text: "Favorable", score: 0 },
      { text: "Desfavorable", score: -5 }
    ]
  },

  rmr14: {
    name: "Celada et al. 2014 (RMR14 Actualizado)",
    author: "Celada, B. et al. (2014)",
    ref: "Specific Parameters of RMR14 in Tunnelling, World Tunnel Congress",
    p1_options: [
      { text: "UCS > 250 MPa", score: 15 },
      { text: "UCS 100 - 250 MPa", score: 12 },
      { text: "UCS 50 - 100 MPa", score: 7 },
      { text: "UCS 25 - 50 MPa", score: 4 },
      { text: "UCS < 25 MPa", score: 1 }
    ],
    p3_options: [
      { text: "> 2.0 m", score: 20 },
      { text: "0.6 - 2.0 m", score: 15 },
      { text: "200 - 600 mm", score: 10 },
      { text: "60 - 200 mm", score: 8 },
      { text: "< 60 mm", score: 5 }
    ],
    p4_options: [
      { text: "Condición excelente de discontinuidades", score: 30 },
      { text: "Condición buena", score: 25 },
      { text: "Condición regular", score: 20 },
      { text: "Condición mala", score: 10 },
      { text: "Condición muy mala", score: 0 }
    ],
    p5_options: [
      { text: "Seco", score: 15 },
      { text: "Húmedo", score: 10 },
      { text: "Agua fluida", score: 4 },
      { text: "Agua a gran presión", score: 0 }
    ],
    p6_options: [
      { text: "Ajuste muy favorable F0 = 1.0", score: 0 },
      { text: "Ajuste favorable F0 = 0.95", score: -3 },
      { text: "Ajuste regular F0 = 0.85", score: -7 },
      { text: "Ajuste desfavorable F0 = 0.70", score: -12 }
    ]
  }
};

export function calculateRQDScore(rqdVal) {
  if (rqdVal >= 90) return 20;
  if (rqdVal >= 75) return 17;
  if (rqdVal >= 50) return 13;
  if (rqdVal >= 25) return 8;
  return 3;
}

export function getRMRClass(score) {
  if (score >= 81) {
    return {
      classNum: "I",
      description: "Roca Muy Buena",
      cohesion: "> 400 kPa",
      friction: "> 45°",
      standUpTime: "20 años para 15 m de luz",
      support: "Generalmente no requiere soporte excepto pernos ocasionales."
    };
  } else if (score >= 61) {
    return {
      classNum: "II",
      description: "Roca Buena",
      cohesion: "300 - 400 kPa",
      friction: "35° - 45°",
      standUpTime: "1 año para 10 m de luz",
      support: "Pernos localizados en bóveda L=3m espaciados 2.5m con malla ocasional."
    };
  } else if (score >= 41) {
    return {
      classNum: "III",
      description: "Roca Regular",
      cohesion: "200 - 300 kPa",
      friction: "25° - 35°",
      standUpTime: "1 semana para 5 m de luz",
      support: "Pernos sistemáticos L=3-4m espaciados 1.5-2m en bóveda y hastiales con 50-100mm de shotcrete."
    };
  } else if (score >= 21) {
    return {
      classNum: "IV",
      description: "Roca Mala",
      cohesion: "100 - 200 kPa",
      friction: "15° - 25°",
      standUpTime: "10 horas para 2.5 m de luz",
      support: "Pernos sistemáticos L=4-5m espaciados 1-1.5m con 100-150mm de shotcrete reforzado con fibra o malla y cerchas ligeras a moderadas."
    };
  } else {
    return {
      classNum: "V",
      description: "Roca Muy Mala",
      cohesion: "< 100 kPa",
      friction: "< 15°",
      standUpTime: "30 minutos para 1 m de luz",
      support: "Shotcrete 150-200mm en bóveda y hastiales, cerchas pesadas espaciadas 0.75m y cuadro completo."
    };
  }
}

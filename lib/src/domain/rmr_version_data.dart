class RMRParamOption {
  final String text;
  final int score;

  const RMRParamOption({required this.text, required this.score});
}

class RMRVersionDefinition {
  final String key;
  final String name;
  final String author;
  final String publication;
  final List<RMRParamOption> p1UcsOptions;
  final List<RMRParamOption> p3SpacingOptions;
  final List<RMRParamOption> p4ConditionOptions;
  final List<RMRParamOption> p5WaterOptions;
  final List<RMRParamOption> p6OrientationOptions;

  const RMRVersionDefinition({
    required this.key,
    required this.name,
    required this.author,
    required this.publication,
    required this.p1UcsOptions,
    required this.p3SpacingOptions,
    required this.p4ConditionOptions,
    required this.p5WaterOptions,
    required this.p6OrientationOptions,
  });
}

const Map<String, RMRVersionDefinition> RMR_VERSION_DEFINITIONS = {
  "rmr89": RMRVersionDefinition(
    key: "rmr89",
    name: "Bieniawski 1989 (RMR89)",
    author: "Bieniawski, Z.T. (1989)",
    publication: "Engineering Rock Mass Classifications, John Wiley & Sons",
    p1UcsOptions: [
      RMRParamOption(text: "UCS > 250 MPa | PLI > 10 MPa (+15 pts)", score: 15),
      RMRParamOption(
        text: "UCS 100 - 250 MPa | PLI 4 - 10 MPa (+12 pts)",
        score: 12,
      ),
      RMRParamOption(
        text: "UCS 50 - 100 MPa | PLI 2 - 4 MPa (+7 pts)",
        score: 7,
      ),
      RMRParamOption(
        text: "UCS 25 - 50 MPa | PLI 1 - 2 MPa (+4 pts)",
        score: 4,
      ),
      RMRParamOption(
        text: "UCS 5 - 25 MPa | Sin carga puntual (+2 pts)",
        score: 2,
      ),
      RMRParamOption(text: "UCS 1 - 5 MPa (+1 pts)", score: 1),
      RMRParamOption(text: "UCS < 1 MPa (0 pts)", score: 0),
    ],
    p3SpacingOptions: [
      RMRParamOption(text: "> 2.0 m (Muy ancho) (+20 pts)", score: 20),
      RMRParamOption(text: "0.6 - 2.0 m (Ancho) (+15 pts)", score: 15),
      RMRParamOption(text: "200 - 600 mm (Moderado) (+10 pts)", score: 10),
      RMRParamOption(text: "60 - 200 mm (Estrecho) (+8 pts)", score: 8),
      RMRParamOption(text: "< 60 mm (Muy estrecho) (+5 pts)", score: 5),
    ],
    p4ConditionOptions: [
      RMRParamOption(
        text: "Muy rugosas, discontinuas, no aperturadas, pared sana (+30 pts)",
        score: 30,
      ),
      RMRParamOption(
        text: "Ligeramente rugosas, apertura < 1mm, poco alteradas (+25 pts)",
        score: 25,
      ),
      RMRParamOption(
        text: "Ligeramente rugosas, apertura < 1mm, muy alteradas (+20 pts)",
        score: 20,
      ),
      RMRParamOption(
        text: "Lisas o relleno < 5mm o apertura 1-5mm (+10 pts)",
        score: 10,
      ),
      RMRParamOption(
        text: "Relleno blando > 5mm o apertura > 5mm (+0 pts)",
        score: 0,
      ),
    ],
    p5WaterOptions: [
      RMRParamOption(
        text: "Completamente seco (Flujo = 0 L/min) (+15 pts)",
        score: 15,
      ),
      RMRParamOption(
        text: "Ligeramente húmedo (Flujo < 10 L/min) (+10 pts)",
        score: 10,
      ),
      RMRParamOption(text: "Húmedo (Flujo 10 - 25 L/min) (+7 pts)", score: 7),
      RMRParamOption(
        text: "Goteando (Flujo 25 - 125 L/min) (+4 pts)",
        score: 4,
      ),
      RMRParamOption(
        text: "Agua a gran presión (Flujo > 125 L/min) (0 pts)",
        score: 0,
      ),
    ],
    p6OrientationOptions: [
      RMRParamOption(text: "Muy Favorable (0 pts)", score: 0),
      RMRParamOption(text: "Favorable (-2 pts)", score: -2),
      RMRParamOption(text: "Regular (-5 pts)", score: -5),
      RMRParamOption(text: "Desfavorable (-10 pts)", score: -10),
      RMRParamOption(text: "Muy Desfavorable (-12 pts)", score: -12),
    ],
  ),

  "rmr76": RMRVersionDefinition(
    key: "rmr76",
    name: "Bieniawski 1976 (RMR76)",
    author: "Bieniawski, Z.T. (1976)",
    publication: "Rock Mass Classification in Jointed Rock Masses, CSIR",
    p1UcsOptions: [
      RMRParamOption(text: "UCS > 200 MPa | PLI > 8 MPa (+15 pts)", score: 15),
      RMRParamOption(
        text: "UCS 100 - 200 MPa | PLI 4 - 8 MPa (+12 pts)",
        score: 12,
      ),
      RMRParamOption(
        text: "UCS 50 - 100 MPa | PLI 2 - 4 MPa (+7 pts)",
        score: 7,
      ),
      RMRParamOption(
        text: "UCS 25 - 50 MPa | PLI 1 - 2 MPa (+4 pts)",
        score: 4,
      ),
      RMRParamOption(text: "UCS < 25 MPa (0 pts)", score: 0),
    ],
    p3SpacingOptions: [
      RMRParamOption(text: "> 3.0 m (+30 pts)", score: 30),
      RMRParamOption(text: "1.0 - 3.0 m (+25 pts)", score: 25),
      RMRParamOption(text: "0.3 - 1.0 m (+20 pts)", score: 20),
      RMRParamOption(text: "50 - 300 mm (+10 pts)", score: 10),
      RMRParamOption(text: "< 50 mm (+5 pts)", score: 5),
    ],
    p4ConditionOptions: [
      RMRParamOption(
        text: "Muy rugosas, cerradas, paredes no alteradas (+25 pts)",
        score: 25,
      ),
      RMRParamOption(
        text: "Ligeramente rugosas, apertura < 1 mm (+20 pts)",
        score: 20,
      ),
      RMRParamOption(
        text: "Superficies lisas o pared alterada (+12 pts)",
        score: 12,
      ),
      RMRParamOption(
        text: "Superficies de fricción / Relleno < 5 mm (+6 pts)",
        score: 6,
      ),
      RMRParamOption(text: "Relleno blando > 5 mm (+0 pts)", score: 0),
    ],
    p5WaterOptions: [
      RMRParamOption(text: "Completamente seco (+10 pts)", score: 10),
      RMRParamOption(text: "Húmedo (+7 pts)", score: 7),
      RMRParamOption(text: "Moja la mano (+4 pts)", score: 4),
      RMRParamOption(text: "Goteando (+2 pts)", score: 2),
      RMRParamOption(text: "Agua a presión (0 pts)", score: 0),
    ],
    p6OrientationOptions: [
      RMRParamOption(text: "Muy Favorable (0 pts)", score: 0),
      RMRParamOption(text: "Favorable (-2 pts)", score: -2),
      RMRParamOption(text: "Regular (-5 pts)", score: -5),
      RMRParamOption(text: "Desfavorable (-10 pts)", score: -10),
      RMRParamOption(text: "Muy Desfavorable (-12 pts)", score: -12),
    ],
  ),

  "rmr73": RMRVersionDefinition(
    key: "rmr73",
    name: "Bieniawski 1973 (RMR73 Histórico)",
    author: "Bieniawski, Z.T. (1973)",
    publication:
        "Engineering Classification of Jointed Rock Masses, Trans. S. Afr. Inst. Civ. Eng.",
    p1UcsOptions: [
      RMRParamOption(text: "UCS > 200 MPa (+10 pts)", score: 10),
      RMRParamOption(text: "UCS 100 - 200 MPa (+9 pts)", score: 9),
      RMRParamOption(text: "UCS 50 - 100 MPa (+7 pts)", score: 7),
      RMRParamOption(text: "UCS 25 - 50 MPa (+4 pts)", score: 4),
      RMRParamOption(text: "UCS < 25 MPa (+1 pts)", score: 1),
    ],
    p3SpacingOptions: [
      RMRParamOption(text: "> 3.0 m (+30 pts)", score: 30),
      RMRParamOption(text: "1.0 - 3.0 m (+25 pts)", score: 25),
      RMRParamOption(text: "0.3 - 1.0 m (+20 pts)", score: 20),
      RMRParamOption(text: "50 - 300 mm (+10 pts)", score: 10),
      RMRParamOption(text: "< 50 mm (+5 pts)", score: 5),
    ],
    p4ConditionOptions: [
      RMRParamOption(
        text: "Paredes de junta sanas y rugosas (+25 pts)",
        score: 25,
      ),
      RMRParamOption(
        text: "Ligeramente alteradas y rugosas (+18 pts)",
        score: 18,
      ),
      RMRParamOption(text: "Lisas y alteradas (+10 pts)", score: 10),
      RMRParamOption(text: "Mucha alteración o relleno (0 pts)", score: 0),
    ],
    p5WaterOptions: [
      RMRParamOption(text: "Seco (+10 pts)", score: 10),
      RMRParamOption(text: "Húmedo (+7 pts)", score: 7),
      RMRParamOption(text: "Goteando (+2 pts)", score: 2),
      RMRParamOption(text: "Agua a presión (0 pts)", score: 0),
    ],
    p6OrientationOptions: [
      RMRParamOption(text: "Favorable (0 pts)", score: 0),
      RMRParamOption(text: "Desfavorable (-5 pts)", score: -5),
    ],
  ),

  "rmr14": RMRVersionDefinition(
    key: "rmr14",
    name: "Celada et al. 2014 (RMR14)",
    author: "Celada, B., Tardáguila, I., Varona, P. (2014)",
    publication: "Specific Parameters of RMR14 in Tunnelling, WTC 2014",
    p1UcsOptions: [
      RMRParamOption(text: "UCS > 250 MPa (+15 pts)", score: 15),
      RMRParamOption(text: "UCS 100 - 250 MPa (+12 pts)", score: 12),
      RMRParamOption(text: "UCS 50 - 100 MPa (+7 pts)", score: 7),
      RMRParamOption(text: "UCS 25 - 50 MPa (+4 pts)", score: 4),
      RMRParamOption(text: "UCS 5 - 25 MPa (+2 pts)", score: 2),
      RMRParamOption(text: "UCS 1 - 5 MPa (+1 pt)", score: 1),
      RMRParamOption(text: "UCS < 1 MPa (0 pts)", score: 0),
    ],
    p3SpacingOptions: [
      RMRParamOption(text: "> 2.0 m (+20 pts)", score: 20),
      RMRParamOption(text: "0.6 - 2.0 m (+15 pts)", score: 15),
      RMRParamOption(text: "200 - 600 mm (+10 pts)", score: 10),
      RMRParamOption(text: "60 - 200 mm (+8 pts)", score: 8),
      RMRParamOption(text: "< 60 mm (+5 pts)", score: 5),
    ],
    p4ConditionOptions: [
      RMRParamOption(text: "Condición excelente Fd (+30 pts)", score: 30),
      RMRParamOption(text: "Condición buena Fd (+25 pts)", score: 25),
      RMRParamOption(text: "Condición regular Fd (+20 pts)", score: 20),
      RMRParamOption(text: "Condición mala Fd (+10 pts)", score: 10),
      RMRParamOption(text: "Condición muy mala Fd (0 pts)", score: 0),
    ],
    p5WaterOptions: [
      RMRParamOption(text: "Seco (+15 pts)", score: 15),
      RMRParamOption(text: "Húmedo (+10 pts)", score: 10),
      RMRParamOption(text: "Mojado (+7 pts)", score: 7),
      RMRParamOption(text: "Agua fluida (+4 pts)", score: 4),
      RMRParamOption(text: "Agua a gran presión (0 pts)", score: 0),
    ],
    p6OrientationOptions: [
      RMRParamOption(text: "Muy favorable: F0 = 0", score: 0),
      RMRParamOption(text: "Favorable: F0 = -2", score: -2),
      RMRParamOption(text: "Regular: F0 = -5", score: -5),
      RMRParamOption(text: "Desfavorable: F0 = -10", score: -10),
      RMRParamOption(text: "Muy desfavorable: F0 = -12", score: -12),
    ],
  ),
};

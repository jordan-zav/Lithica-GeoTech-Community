/* ==========================================================================
   LITHICA GEOTECH - HOEK-BROWN (2002/2018) & MOHR CIRCLE VECTOR ENGINE
   ========================================================================== */

export function calculateHoekBrown(sigCi, mi, gsi, D = 0) {
  const mb = mi * Math.exp((gsi - 100) / (28 - 14 * D));
  const s = Math.exp((gsi - 100) / (9 - 3 * D));
  const a = 0.5 + (1 / 6) * (Math.exp(-gsi / 15) - Math.exp(-20 / 3));

  // Global Rock Mass Strength sig_cm (MPa)
  const term1 = mb + 4 * s - a * (mb - 8 * s);
  const term2 = Math.pow(mb / 4 + s, a - 1);
  const sigCm = sigCi * (term1 * term2) / (2 * (1 + a) * (2 + a));

  // Uniaxial Tensile Strength sig_t (MPa)
  const sigT = - (s * sigCi) / mb;

  // Equivalent Mohr-Coulomb Parameters (c and phi) for slope / tunnel confinement range
  const sig3max = sigCi * 0.25; // Standard equivalent range
  const cCohesion = (sigCi * ((1 + 2 * a) * s + (1 - a) * mb * (sig3max / sigCi)) * Math.pow(s + mb * (sig3max / sigCi), a - 1)) /
                    ((1 + a) * (2 + a) * Math.sqrt(1 + (6 * a * mb * Math.pow(s + mb * (sig3max / sigCi), a - 1)) / ((1 + a) * (2 + a))));
  
  const sinPhi = (6 * a * mb * Math.pow(s + mb * (sig3max / sigCi), a - 1)) /
                 (2 * (1 + a) * (2 + a) + 6 * a * mb * Math.pow(s + mb * (sig3max / sigCi), a - 1));
  const phiFriction = Math.asin(Math.max(-1, Math.min(1, sinPhi))) * (180 / Math.PI);

  return {
    mb: parseFloat(mb.toFixed(3)),
    s: parseFloat(s.toFixed(5)),
    a: parseFloat(a.toFixed(3)),
    sigCm: parseFloat(sigCm.toFixed(1)),
    sigT: parseFloat(sigT.toFixed(2)),
    cohesionKPa: Math.round(cCohesion * 1000), // in kPa
    frictionDeg: parseFloat(phiFriction.toFixed(1)),
    Em: Math.round((sigCi <= 100 ? (1 - D / 2) * Math.sqrt(sigCi / 100) * Math.pow(10, (gsi - 10) / 40) * 1000 : (1 - D / 2) * Math.pow(10, (gsi - 10) / 40) * 1000))
  };
}

let hoverStateMap = new WeakMap();
export let currentPlotMode = 'mohr'; // Default to Mohr Plane ('mohr' or 'principal')

export function setHoekBrownPlotMode(mode) {
  if (['mohr', 'principal'].includes(mode)) {
    currentPlotMode = mode;
  }
}

export function renderHoekBrownEnvelope(canvasId, sigCi, mi, gsi, D = 0, mode = currentPlotMode) {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  const width = canvas.width;
  const height = canvas.height;

  ctx.clearRect(0, 0, width, height);

  const isLight = document.body.classList.contains('light-theme');
  ctx.fillStyle = isLight ? "#F8FAFC" : "#0A2233";
  ctx.fillRect(0, 0, width, height);

  const hb = calculateHoekBrown(sigCi, mi, gsi, D);

  // Setup hover state listener
  if (!hoverStateMap.has(canvas)) {
    const state = { mouseX: null, mouseY: null };
    hoverStateMap.set(canvas, state);

    canvas.addEventListener('mousemove', (e) => {
      const rect = canvas.getBoundingClientRect();
      state.mouseX = e.clientX - rect.left;
      state.mouseY = e.clientY - rect.top;
      renderHoekBrownEnvelope(canvasId, sigCi, mi, gsi, D, currentPlotMode);
    });

    canvas.addEventListener('mouseleave', () => {
      state.mouseX = null;
      state.mouseY = null;
      renderHoekBrownEnvelope(canvasId, sigCi, mi, gsi, D, currentPlotMode);
    });
  }

  const hover = hoverStateMap.get(canvas);

  if (mode === 'mohr') {
    renderMohrPlane(ctx, width, height, sigCi, mi, gsi, D, hb, isLight, hover);
  } else {
    renderPrincipalPlane(ctx, width, height, sigCi, mi, gsi, D, hb, isLight, hover);
  }
}

/* ==========================================================================
   MODE 1: MOHR PLANE (tau vs sigma) - 100% RIGOROUS MOHR CIRCLE TANGENT ENGINE
   ========================================================================== */
function renderMohrPlane(ctx, width, height, sigCi, mi, gsi, D, hb, isLight, hover) {
  const padL = 60;
  const padR = 35;
  const padT = 35;
  const padB = 45;
  const plotW = width - padL - padR;
  const plotH = height - padT - padB;

  // Maximum stress on X-axis (from sig_t up to 1.2 * sig_ci)
  const minSigma = hb.sigT * 1.5; // Include tensile region
  const maxSigma = Math.max(10, sigCi * 1.0);
  const maxTau = maxSigma * 0.6; // Isotropic scale ratio for visual clarity

  function toX(sigma) { return padL + ((sigma - minSigma) / (maxSigma - minSigma)) * plotW; }
  function toY(tau) { return height - padB - (tau / maxTau) * plotH; }

  // 1. Grid Lines & Axis Ticks
  ctx.strokeStyle = isLight ? "rgba(148, 163, 184, 0.25)" : "rgba(64, 112, 128, 0.25)";
  ctx.lineWidth = 1;

  // Vertical zero line (sigma = 0 separator between tension and compression)
  const zeroX = toX(0);
  ctx.strokeStyle = isLight ? "rgba(71, 85, 105, 0.4)" : "rgba(255, 255, 255, 0.4)";
  ctx.setLineDash([4, 4]);
  ctx.beginPath();
  ctx.moveTo(zeroX, padT);
  ctx.lineTo(zeroX, height - padB);
  ctx.stroke();
  ctx.setLineDash([]);

  // X-Ticks (Normal Stress sigma)
  const xTicks = 6;
  for (let i = 0; i <= xTicks; i++) {
    const sigVal = minSigma + (i / xTicks) * (maxSigma - minSigma);
    const x = toX(sigVal);
    ctx.strokeStyle = isLight ? "rgba(148, 163, 184, 0.2)" : "rgba(64, 112, 128, 0.2)";
    ctx.beginPath();
    ctx.moveTo(x, padT);
    ctx.lineTo(x, height - padB);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "center";
    ctx.fillText(Math.round(sigVal) + " MPa", x, height - padB + 16);
  }

  // Y-Ticks (Shear Strength tau)
  const yTicks = 5;
  for (let i = 0; i <= yTicks; i++) {
    const tauVal = (i / yTicks) * maxTau;
    const y = toY(tauVal);
    ctx.beginPath();
    ctx.moveTo(padL, y);
    ctx.lineTo(padL + plotW, y);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "right";
    ctx.fillText(Math.round(tauVal) + " MPa", padL - 8, y + 4);
  }

  // 2. Calculate Exact Hoek-Brown Shear Strength Envelope tau(sigma)
  const steps = 100;
  const hbShearEnvelope = [];
  const minSig3 = hb.sigT; // From tensile limit
  const maxSig3 = maxSigma * 0.5;

  for (let i = 0; i <= steps; i++) {
    const sig3 = minSig3 + (i / steps) * (maxSig3 - minSig3);
    const sig3Norm = Math.max(0.00001, (sig3 - hb.sigT) / sigCi);
    const sig1 = sig3 + sigCi * Math.pow(hb.mb * (sig3 / sigCi) + hb.s, hb.a);

    // Exact Hoek & Brown transformation for normal and shear stress at failure
    const hVal = 1 + hb.a * hb.mb * Math.pow(hb.mb * (sig3 / sigCi) + hb.s, hb.a - 1);
    const sigma = sig3 + (sig1 - sig3) / (2 + hVal);
    const tau = (sig1 - sig3) * Math.sqrt(1 + hVal) / (2 + hVal);

    hbShearEnvelope.push({ sig3, sig1, sigma, tau, hVal });
  }

  // 3. Draw Representative Mohr Circles (Uniaxial Tensile, Uniaxial Compressive, Confined Triaxial)
  const circleConfinements = [
    { label: "Tracción σt", sig3: hb.sigT },
    { label: "Compresión Uniaxial σcm", sig3: 0 },
    { label: "Triaxial Confinado", sig3: maxSigma * 0.2 }
  ];

  circleConfinements.forEach(conf => {
    const s3 = conf.sig3;
    const s1 = s3 + sigCi * Math.pow(hb.mb * (s3 / sigCi) + hb.s, hb.a);
    const centerSig = (s1 + s3) / 2;
    const radiusSig = (s1 - s3) / 2;

    const centerX = toX(centerSig);
    const centerY = toY(0);
    const radiusPx = (radiusSig / (maxSigma - minSigma)) * plotW;

    if (centerX + radiusPx > padL && centerX - radiusPx < padL + plotW) {
      // Draw Mohr Semi-circle
      ctx.beginPath();
      ctx.arc(centerX, centerY, radiusPx, Math.PI, 2 * Math.PI); // Top semi-circle
      ctx.strokeStyle = "rgba(128, 192, 48, 0.45)";
      ctx.lineWidth = 1.5;
      ctx.setLineDash([4, 4]);
      ctx.stroke();
      ctx.setLineDash([]);

      // Mark sig3 and sig1 intercepts on horizontal axis
      const sig3X = toX(s3);
      const sig1X = toX(s1);

      ctx.fillStyle = "#80C030";
      ctx.beginPath();
      ctx.arc(sig3X, centerY, 3.5, 0, 2 * Math.PI);
      ctx.arc(sig1X, centerY, 3.5, 0, 2 * Math.PI);
      ctx.fill();
    }
  });

  // 4. Draw Equivalent Mohr-Coulomb Line Envelope (tau = c' + sigma * tan(phi'))
  const mcTan = Math.tan((hb.frictionDeg * Math.PI) / 180);
  const mcCohesionMPa = hb.cohesionKPa / 1000;

  ctx.beginPath();
  const mcY1 = toY(mcCohesionMPa + 0 * mcTan);
  const mcY2 = toY(mcCohesionMPa + maxSigma * mcTan);
  ctx.moveTo(toX(0), mcY1);
  ctx.lineTo(toX(maxSigma), mcY2);
  ctx.strokeStyle = "#D48245";
  ctx.lineWidth = 2;
  ctx.setLineDash([4, 4]);
  ctx.stroke();
  ctx.setLineDash([]);

  // 5. Draw Non-Linear Hoek-Brown Shear Strength Envelope Curve
  ctx.beginPath();
  hbShearEnvelope.forEach((pt, idx) => {
    const x = toX(pt.sigma);
    const y = toY(pt.tau);
    if (idx === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.strokeStyle = "#80C030";
  ctx.lineWidth = 3;
  ctx.stroke();

  // Fill area under shear envelope
  ctx.lineTo(toX(maxSigma), toY(0));
  ctx.lineTo(toX(minSigma), toY(0));
  ctx.closePath();
  const grad = ctx.createLinearGradient(0, padT, 0, height - padB);
  grad.addColorStop(0, isLight ? "rgba(96, 160, 64, 0.22)" : "rgba(128, 192, 48, 0.25)");
  grad.addColorStop(1, isLight ? "rgba(96, 160, 64, 0.0)" : "rgba(128, 192, 48, 0.0)");
  ctx.fillStyle = grad;
  ctx.fill();

  // Axis Titles
  ctx.fillStyle = "#80C030";
  ctx.font = "bold 11px Outfit, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("Tensión Normal σ (MPa) — Plano de Cizalle de Mohr", padL + plotW / 2, height - 8);

  ctx.save();
  ctx.translate(18, padT + plotH / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText("Resistencia al Cizalle τ (MPa)", 0, 0);
  ctx.restore();

  // Top-Left Legend Panel
  const legW = 285;
  const legH = 70;
  const legX = padL + 12;
  const legY = padT + 8;

  ctx.fillStyle = isLight ? "rgba(255, 255, 255, 0.95)" : "rgba(11, 34, 56, 0.95)";
  ctx.strokeStyle = isLight ? "rgba(64, 112, 128, 0.3)" : "rgba(64, 112, 128, 0.4)";
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.roundRect(legX, legY, legW, legH, 8);
  ctx.fill();
  ctx.stroke();

  ctx.fillStyle = "#80C030";
  ctx.fillRect(legX + 10, legY + 12, 12, 4);
  ctx.fillStyle = isLight ? "#0F172A" : "#FFFFFF";
  ctx.font = "bold 10px Inter, sans-serif";
  ctx.textAlign = "left";
  ctx.fillText(`Envolvente Cizalle Hoek-Brown: σt = ${hb.sigT} MPa`, legX + 28, legY + 17);

  ctx.fillStyle = "rgba(128, 192, 48, 0.7)";
  ctx.fillRect(legX + 10, legY + 30, 12, 4);
  ctx.fillStyle = isLight ? "#0F172A" : "#FFFFFF";
  ctx.fillText(`Círculos de Mohr Tangentes (σ3 → σ1)`, legX + 28, legY + 35);

  ctx.fillStyle = "#D48245";
  ctx.fillRect(legX + 10, legY + 48, 12, 4);
  ctx.fillStyle = isLight ? "#0F172A" : "#FFFFFF";
  ctx.fillText(`Envolvente Mohr-Coulomb: c' = ${hb.cohesionKPa} kPa, φ' = ${hb.frictionDeg}°`, legX + 28, legY + 53);

  // Dynamic Crosshairs on Mouse Hover
  if (hover && hover.mouseX >= padL && hover.mouseX <= padL + plotW && hover.mouseY >= padT && hover.mouseY <= height - padB) {
    const hoveredSigma = minSigma + ((hover.mouseX - padL) / plotW) * (maxSigma - minSigma);
    const closestPt = hbShearEnvelope.reduce((prev, curr) => 
      Math.abs(curr.sigma - hoveredSigma) < Math.abs(prev.sigma - hoveredSigma) ? curr : prev
    );

    const xPos = toX(closestPt.sigma);
    const yPos = toY(closestPt.tau);

    ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
    ctx.lineWidth = 1;
    ctx.setLineDash([2, 2]);
    ctx.beginPath();
    ctx.moveTo(xPos, padT);
    ctx.lineTo(xPos, height - padB);
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.beginPath();
    ctx.arc(xPos, yPos, 5, 0, 2 * Math.PI);
    ctx.fillStyle = "#FFFFFF";
    ctx.fill();
    ctx.strokeStyle = "#80C030";
    ctx.lineWidth = 2;
    ctx.stroke();

    // Floating Tooltip Box
    const tipW = 165;
    const tipH = 46;
    let tipX = xPos + 12;
    if (tipX + tipW > padL + plotW) tipX = xPos - tipW - 12;
    let tipY = yPos - 20;
    if (tipY < padT) tipY = padT + 10;

    ctx.fillStyle = isLight ? "rgba(15, 23, 42, 0.94)" : "rgba(6, 21, 33, 0.95)";
    ctx.strokeStyle = "#80C030";
    ctx.lineWidth = 1.2;
    ctx.beginPath();
    ctx.roundRect(tipX, tipY, tipW, tipH, 6);
    ctx.fill();
    ctx.stroke();

    ctx.fillStyle = "#FFFFFF";
    ctx.font = "10px Fira Code, monospace";
    ctx.textAlign = "left";
    ctx.fillText(`Tensión Normal σ = ${closestPt.sigma.toFixed(1)} MPa`, tipX + 8, tipY + 14);
    ctx.fillStyle = "#80C030";
    ctx.fillText(`Cizalle τ        = ${closestPt.tau.toFixed(1)} MPa`, tipX + 8, tipY + 27);
    ctx.fillStyle = "#51B4B4";
    ctx.fillText(`Confinamiento σ3 = ${closestPt.sig3.toFixed(1)} MPa`, tipX + 8, tipY + 40);
  }
}

/* ==========================================================================
   MODE 2: PRINCIPAL STRESS PLANE (sig1 vs sig3)
   ========================================================================== */
function renderPrincipalPlane(ctx, width, height, sigCi, mi, gsi, D, hb, isLight, hover) {
  const padL = 60;
  const padR = 30;
  const padT = 30;
  const padB = 45;
  const plotW = width - padL - padR;
  const plotH = height - padT - padB;

  const maxSig3 = Math.max(10, sigCi * 0.5);
  const points = 80;

  let maxSig1 = 0;
  const massCurve = [];
  const intactCurve = [];
  const mcCurve = [];

  for (let i = 0; i <= points; i++) {
    const sig3 = (i / points) * maxSig3;
    const sig1Mass = sig3 + sigCi * Math.pow(hb.mb * (sig3 / sigCi) + hb.s, hb.a);
    const sig1Intact = sig3 + sigCi * Math.pow(mi * (sig3 / sigCi) + 1.0, 0.5);
    const kMC = (1 + Math.sin(hb.frictionDeg * Math.PI / 180)) / (1 - Math.sin(hb.frictionDeg * Math.PI / 180));
    const sig1MC = hb.sigCm + sig3 * kMC;

    if (sig1Intact > maxSig1) maxSig1 = sig1Intact;
    if (sig1Mass > maxSig1) maxSig1 = sig1Mass;

    massCurve.push({ sig3, sig1: sig1Mass });
    intactCurve.push({ sig3, sig1: sig1Intact });
    mcCurve.push({ sig3, sig1: sig1MC });
  }

  function toX(sig3) { return padL + (sig3 / maxSig3) * plotW; }
  function toY(sig1) { return height - padB - (sig1 / maxSig1) * plotH; }

  // Grid Ticks
  ctx.strokeStyle = isLight ? "rgba(148, 163, 184, 0.25)" : "rgba(64, 112, 128, 0.25)";
  ctx.lineWidth = 1;

  for (let i = 0; i <= 5; i++) {
    const s3 = (i / 5) * maxSig3;
    const x = toX(s3);
    ctx.beginPath();
    ctx.moveTo(x, padT);
    ctx.lineTo(x, height - padB);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "center";
    ctx.fillText(Math.round(s3) + " MPa", x, height - padB + 16);
  }

  for (let i = 0; i <= 5; i++) {
    const s1 = (i / 5) * maxSig1;
    const y = toY(s1);
    ctx.beginPath();
    ctx.moveTo(padL, y);
    ctx.lineTo(padL + plotW, y);
    ctx.stroke();

    ctx.fillStyle = isLight ? "#475569" : "#9CA3AF";
    ctx.font = "10px Inter, sans-serif";
    ctx.textAlign = "right";
    ctx.fillText(Math.round(s1) + " MPa", padL - 8, y + 4);
  }

  // Intact Curve
  ctx.beginPath();
  intactCurve.forEach((pt, idx) => {
    const x = toX(pt.sig3);
    const y = toY(pt.sig1);
    if (idx === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.strokeStyle = "#51B4B4";
  ctx.lineWidth = 2;
  ctx.setLineDash([5, 5]);
  ctx.stroke();
  ctx.setLineDash([]);

  // Mohr-Coulomb Equivalent
  ctx.beginPath();
  mcCurve.forEach((pt, idx) => {
    const x = toX(pt.sig3);
    const y = toY(pt.sig1);
    if (idx === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.strokeStyle = "#D48245";
  ctx.lineWidth = 1.8;
  ctx.setLineDash([3, 3]);
  ctx.stroke();
  ctx.setLineDash([]);

  // Rock Mass Curve
  ctx.beginPath();
  massCurve.forEach((pt, idx) => {
    const x = toX(pt.sig3);
    const y = toY(pt.sig1);
    if (idx === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.strokeStyle = "#80C030";
  ctx.lineWidth = 3;
  ctx.stroke();

  // Titles & Legend
  ctx.fillStyle = "#80C030";
  ctx.font = "bold 11px Outfit, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("Tensión Principal Menor σ3 (Confinamiento Hidrostático, MPa)", padL + plotW / 2, height - 8);

  ctx.save();
  ctx.translate(18, padT + plotH / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText("Tensión Principal Mayor σ1 (Resistencia, MPa)", 0, 0);
  ctx.restore();
}

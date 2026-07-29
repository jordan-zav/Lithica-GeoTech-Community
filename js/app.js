/* ==========================================================================
   LITHICA GEOTECH - MAIN APPLICATION LOGIC & EVENT CONTROLLER
   ========================================================================== */

import { initMaterialsComponent } from './components/materials.js';
import { initISRMComponent } from './components/isrm.js';
import { RMR_VERSIONS, calculateRQDScore, getRMRClass } from './calculators/rmr.js';
import {
  Q_JN_OPTIONS, Q_JR_OPTIONS, Q_JA_OPTIONS, Q_JW_OPTIONS, Q_SRF_OPTIONS,
  calculateQ, getQQualityCategory, getBartonSupportZone, renderQSupportChart,
  calculateBoltLength, roundBoltLength
} from './calculators/q_system.js';
import { calculateHoekBrown, renderHoekBrownEnvelope, setHoekBrownPlotMode, currentPlotMode } from './calculators/hoek_brown.js';
import { initSettingsSystem } from './settings.js';

document.addEventListener('DOMContentLoaded', () => {
  initLaunchSplash();
  initSettingsSystem();
  initTopographicCanvas();
  initNavigation();
  initModeToggle();
  initMaterialsComponent();
  initISRMComponent();
  
  initRMRCalculator();
  initQCalculator();
  initHoekBrownCalculator();
});

/* --------------------------------------------------------------------------
   0. LAUNCH SPLASH ANIMATION (MATCHING LITHICA ATLAS TIMING)
   -------------------------------------------------------------------------- */
function initLaunchSplash() {
  const splash = document.getElementById('launch-splash');
  if (!splash) return;
  requestAnimationFrame(() => {
    splash.classList.add('visible');
  });
  setTimeout(() => {
    splash.classList.add('fade-out');
    setTimeout(() => {
      splash.remove();
    }, 900);
  }, 900);
}


/* --------------------------------------------------------------------------
   1. TOPOGRAPHIC BACKGROUND CANVAS PAINTER (MATCHING LITHICA ATLAS)
   -------------------------------------------------------------------------- */
function initTopographicCanvas() {
  const canvas = document.getElementById('topographic-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');

  function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    drawContourLines();
  }

  function drawContourLines() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const isLight = document.body.classList.contains('light-theme');
    ctx.strokeStyle = isLight ? "rgba(16, 42, 67, 0.16)" : "rgba(64, 112, 128, 0.12)";
    ctx.lineWidth = 1.2;

    const numLines = 14;
    const centerX = canvas.width * 0.15;
    const centerY = canvas.height * 0.25;

    for (let i = 1; i <= numLines; i++) {
      const radius = i * 45;
      ctx.beginPath();
      for (let angle = 0; angle <= Math.PI * 2; angle += 0.05) {
        const distortion = Math.sin(angle * 4 + i * 0.3) * 18 + Math.cos(angle * 2) * 12;
        const r = radius + distortion;
        const x = centerX + r * Math.cos(angle) * 1.6;
        const y = centerY + r * Math.sin(angle);
        if (angle === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }
      ctx.closePath();
      ctx.stroke();
    }
  }

  window.addEventListener('resize', resize);
  window.addEventListener('geotech-theme-changed', () => {
    drawContourLines();
    updateQCalculation();
    updateHBCalculation();
  });
  resize();
}

/* --------------------------------------------------------------------------
   2. TAB NAVIGATION & MODE TOGGLE
   -------------------------------------------------------------------------- */
function initNavigation() {
  const navBtns = document.querySelectorAll('.nav-btn');
  const tabPanels = document.querySelectorAll('.tab-panel');

  navBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetTab = btn.getAttribute('data-tab');
      navBtns.forEach(b => b.classList.remove('active'));
      tabPanels.forEach(p => p.classList.remove('active'));

      btn.classList.add('active');
      document.getElementById(`tab-${targetTab}`)?.classList.add('active');

      // Trigger canvas re-renders when tab opens
      if (targetTab === 'q-system') {
        updateQCalculation();
      } else if (targetTab === 'hoek-brown') {
        updateHBCalculation();
      }
    });
  });
}

function initModeToggle() {
  const toggle = document.getElementById('expert-mode-toggle');
  if (!toggle) return;

  toggle.addEventListener('change', (e) => {
    if (e.target.checked) {
      document.body.classList.add('expert-active');
    } else {
      document.body.classList.remove('expert-active');
    }
  });
}

/* --------------------------------------------------------------------------
   3. RMR CALCULATOR CONTROLLER
   -------------------------------------------------------------------------- */
function initRMRCalculator() {
  const versionSelect = document.getElementById('rmr-version-select');
  const rqdSlider = document.getElementById('rmr-p2-rqd');

  if (versionSelect) {
    versionSelect.addEventListener('change', () => populateRMRForm());
  }

  if (rqdSlider) {
    rqdSlider.addEventListener('input', (e) => {
      document.getElementById('rmr-rqd-val').innerText = `${e.target.value}%`;
      recalculateRMR();
    });
  }

  populateRMRForm();
}

function populateRMRForm() {
  const versionKey = document.getElementById('rmr-version-select')?.value || 'rmr89';
  const ver = RMR_VERSIONS[versionKey];

  document.getElementById('active-rmr-tag').innerText = ver.name;

  populateSelect('rmr-p1-select', ver.p1_options);
  populateSelect('rmr-p3-select', ver.p3_options);
  populateSelect('rmr-p4-select', ver.p4_options);
  populateSelect('rmr-p5-select', ver.p5_options);
  populateSelect('rmr-p6-select', ver.p6_options);

  ['rmr-p1-select', 'rmr-p3-select', 'rmr-p4-select', 'rmr-p5-select', 'rmr-p6-select'].forEach(id => {
    document.getElementById(id)?.addEventListener('change', recalculateRMR);
  });

  recalculateRMR();
}

function populateSelect(selectId, options) {
  const el = document.getElementById(selectId);
  if (!el) return;
  el.innerHTML = options.map((opt, idx) => `
    <option value="${opt.score}" ${idx === 1 ? 'selected' : ''}>${opt.text} (${opt.score > 0 ? '+' : ''}${opt.score} pts)</option>
  `).join('');
}

function recalculateRMR() {
  const s1 = parseInt(document.getElementById('rmr-p1-select')?.value || 12);
  const rqdVal = parseInt(document.getElementById('rmr-p2-rqd')?.value || 75);
  const s2 = calculateRQDScore(rqdVal);
  const s3 = parseInt(document.getElementById('rmr-p3-select')?.value || 15);
  const s4 = parseInt(document.getElementById('rmr-p4-select')?.value || 25);
  const s5 = parseInt(document.getElementById('rmr-p5-select')?.value || 10);
  const s6 = parseInt(document.getElementById('rmr-p6-select')?.value || 0);

  const total = Math.max(0, Math.min(100, s1 + s2 + s3 + s4 + s5 + s6));
  const rmrClass = getRMRClass(total);

  document.getElementById('rmr-total-score').innerText = total;
  document.getElementById('rmr-class-badge').innerText = `Clase ${rmrClass.classNum}: ${rmrClass.description}`;
  
  document.getElementById('est-cohesion').innerText = rmrClass.cohesion;
  document.getElementById('est-friction').innerText = rmrClass.friction;
  document.getElementById('est-standuptime').innerText = rmrClass.standUpTime;
  document.getElementById('tunnel-support-text').innerText = rmrClass.support;

  // Breakdown table
  const versionKey = document.getElementById('rmr-version-select')?.value || 'rmr89';
  document.getElementById('support-author-ref').innerText = RMR_VERSIONS[versionKey].author;

  const tbody = document.getElementById('rmr-breakdown-body');
  if (tbody) {
    tbody.innerHTML = `
      <tr><td>1. Resistencia Roca Intacta</td><td>UCS / PLI Selección</td><td><strong>+${s1}</strong></td></tr>
      <tr><td>2. RQD (${rqdVal}%)</td><td>Designación Calidad Roca</td><td><strong>+${s2}</strong></td></tr>
      <tr><td>3. Espaciamiento Discontinuidades</td><td>Distancia entre juntas</td><td><strong>+${s3}</strong></td></tr>
      <tr><td>4. Condición de Discontinuidades</td><td>Rugosidad y alteración</td><td><strong>+${s4}</strong></td></tr>
      <tr><td>5. Agua Subterránea</td><td>Flujo / Presión de agua</td><td><strong>+${s5}</strong></td></tr>
      <tr style="color: var(--accent-ochre);"><td>6. Ajuste Orientación Juntas</td><td>Alineamiento con túnel</td><td><strong>${s6}</strong></td></tr>
    `;
  }
}

/* --------------------------------------------------------------------------
   4. Q-SYSTEM CALCULATOR CONTROLLER
   -------------------------------------------------------------------------- */
let currentZoneId = null;

function initQCalculator() {
  populateSelectVal('q-select-jn', Q_JN_OPTIONS);
  populateSelectVal('q-select-jr', Q_JR_OPTIONS);
  populateSelectVal('q-select-ja', Q_JA_OPTIONS);
  populateSelectVal('q-select-jw', Q_JW_OPTIONS);
  populateSelectVal('q-select-srf', Q_SRF_OPTIONS);

  const rqdSlider = document.getElementById('q-input-rqd');
  if (rqdSlider) {
    rqdSlider.addEventListener('input', (e) => {
      document.getElementById('q-rqd-display').innerText = `${e.target.value}%`;
      updateQCalculation();
    });
  }

  ['q-select-jn', 'q-select-jr', 'q-select-ja', 'q-select-jw', 'q-select-srf', 'q-select-esr', 'q-input-span', 'q-version-select'].forEach(id => {
    document.getElementById(id)?.addEventListener('change', updateQCalculation);
    document.getElementById(id)?.addEventListener('input', updateQCalculation);
  });

  // Listeners for interactive updates in the Proposed Support Module
  const supportModuleInputs = [
    'bolt-adopted-length-input', 'bolt-type-select', 'bolt-diameter-select',
    'bolt-spacing-input', 'bolt-pattern-select', 'bolt-location-select',
    'shotcrete-thickness-input', 'shotcrete-type-select', 'shotcrete-fiber-select',
    'shotcrete-strength-select', 'shotcrete-application-input',
    'mesh-required-select', 'mesh-type-select', 'mesh-location-input',
    'girders-required-select', 'girders-spacing-select', 'girders-profile-input'
  ];

  supportModuleInputs.forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      el.addEventListener('change', () => refreshBlueprintCard());
      el.addEventListener('input', () => refreshBlueprintCard());
    }
  });

  updateQCalculation();
}

function populateSelectVal(id, list) {
  const el = document.getElementById(id);
  if (!el) return;
  el.innerHTML = list.map((opt, idx) => `
    <option value="${opt.val}" ${idx === 0 ? 'selected' : ''}>${opt.text}</option>
  `).join('');
}

function updateQCalculation() {
  const rqd = parseFloat(document.getElementById('q-input-rqd')?.value || 80);
  const jn = parseFloat(document.getElementById('q-select-jn')?.value || 9);
  const jr = parseFloat(document.getElementById('q-select-jr')?.value || 3);
  const ja = parseFloat(document.getElementById('q-select-ja')?.value || 1);
  const jw = parseFloat(document.getElementById('q-select-jw')?.value || 1);
  const srf = parseFloat(document.getElementById('q-select-srf')?.value || 1);

  const esr = parseFloat(document.getElementById('q-select-esr')?.value || 1.6);
  const span = parseFloat(document.getElementById('q-input-span')?.value || 10);

  const Q = calculateQ(rqd, jn, jr, ja, jw, srf);
  const category = getQQualityCategory(Q);
  const De = parseFloat((span / esr).toFixed(2));

  document.getElementById('q-calculated-value').innerText = Q;
  document.getElementById('q-quality-desc').innerText = category;
  document.getElementById('q-block-size').innerText = (rqd / jn).toFixed(2);
  document.getElementById('q-joint-friction').innerText = (jr / ja).toFixed(2);
  document.getElementById('q-stress-water').innerText = (jw / srf).toFixed(2);
  document.getElementById('q-de-val').innerText = `${De} m`;

  renderQSupportChart('q-support-canvas', Q, De);

  // Update Barton Support Zone Card below the chart canvas
  const zone = getBartonSupportZone(Q, De);
  const esrSelect = document.getElementById('q-select-esr');
  const esrText = esrSelect ? esrSelect.options[esrSelect.selectedIndex]?.text : `ESR = ${esr}`;
  const boltLCalc = calculateBoltLength(span, esr);

  const zoneCard = document.getElementById('q-barton-zone-card');
  if (zoneCard && zone) {
    zoneCard.style.borderColor = zone.stroke || 'var(--primary-green)';
    const shotText = zone.shotcreteDesc || (typeof zone.shotcrete === 'string' ? zone.shotcrete : zone.shotcrete.thickness);
    zoneCard.innerHTML = `
      <div class="barton-card-header">
        <div class="barton-zone-title" style="color: ${zone.stroke || 'var(--primary-lime)'};">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
          <span>Zona Barton ${zone.id}: ${zone.name}</span>
        </div>
        <span class="traceable-badge">Trazable</span>
      </div>
      <div class="barton-card-grid">
        <div class="barton-grid-item">
          <span class="barton-item-label">Método Base:</span>
          <span class="barton-item-val">Grimstad & Barton (1993) - S(fr)</span>
        </div>
        <div class="barton-grid-item">
          <span class="barton-item-label">Cita Bibliográfica:</span>
          <span class="barton-item-val">Grimstad, E. & Barton, N. (1993)</span>
        </div>
        <div class="barton-grid-item">
          <span class="barton-item-label">Carta Aplicada:</span>
          <span class="barton-item-val">Carta de Soporte Q vs De (1993)</span>
        </div>
        <div class="barton-grid-item">
          <span class="barton-item-label">Excavación & ESR:</span>
          <span class="barton-item-val">${esrText}</span>
        </div>
        <div class="barton-grid-item">
          <span class="barton-item-label">Sostenimiento Sugerido:</span>
          <span class="barton-item-val highlight-green" style="color: ${zone.stroke || 'var(--primary-lime)'};">${shotText} (${zone.desc})</span>
        </div>
        <div class="barton-grid-item">
          <span class="barton-item-label">Longitud Perno (L):</span>
          <span class="barton-item-val">~${boltLCalc} m [L = (2 + 0.15×Span)/ESR]</span>
        </div>
        <div class="barton-grid-item full-width">
          <span class="barton-item-label">Nivel de Confianza:</span>
          <span class="barton-item-val">Diseño Empírico / Preliminar (Se recomienda modelado numérico)</span>
        </div>
      </div>
    `;
  }

  // Update Proposed Support Module
  const isZoneChange = (currentZoneId !== zone.id);
  currentZoneId = zone.id;
  updateProposedSupportModule(zone, span, esr, isZoneChange);
}

function updateProposedSupportModule(zone, span, esr, isZoneChange) {
  const calcL = calculateBoltLength(span, esr);
  const calcLDisplay = document.getElementById('bolt-calc-length-val');
  if (calcLDisplay) calcLDisplay.innerText = `${calcL} m`;

  const adoptedInput = document.getElementById('bolt-adopted-length-input');

  // Populate default form values when zone changes or on initial load
  if (isZoneChange && zone) {
    if (adoptedInput) adoptedInput.value = roundBoltLength(calcL);

    setSelectValue('bolt-type-select', zone.bolts.type);
    setSelectValue('bolt-diameter-select', zone.bolts.diameter);
    setInputValue('bolt-spacing-input', zone.bolts.spacing);
    setSelectValue('bolt-pattern-select', zone.bolts.pattern);
    setSelectValue('bolt-location-select', zone.bolts.location);

    setInputValue('shotcrete-thickness-input', zone.shotcrete.thickness);
    setSelectValue('shotcrete-type-select', zone.shotcrete.type);
    setSelectValue('shotcrete-fiber-select', zone.shotcrete.fiber);
    setSelectValue('shotcrete-strength-select', zone.shotcrete.strength);
    setInputValue('shotcrete-application-input', zone.shotcrete.application);

    setSelectValue('mesh-required-select', zone.mesh.required);
    setSelectValue('mesh-type-select', zone.mesh.type);
    setInputValue('mesh-location-input', zone.mesh.location);

    setSelectValue('girders-required-select', zone.girders.required);
    setSelectValue('girders-spacing-select', zone.girders.spacing);
    setInputValue('girders-profile-input', zone.girders.profile);

    // Update Constructive Meaning Box
    const titleEl = document.getElementById('constructive-meaning-title');
    const textEl = document.getElementById('constructive-meaning-text');
    if (titleEl) titleEl.innerText = `¿Qué significa constructivamente la Zona Barton Z${zone.id} (${zone.name})?`;
    if (textEl) textEl.innerText = zone.constructiveMeaning || zone.desc;
  }

  // Always sync blueprint summary card
  refreshBlueprintCard(zone, calcL);
}

function setSelectValue(id, value) {
  const el = document.getElementById(id);
  if (!el || !value) return;
  for (let i = 0; i < el.options.length; i++) {
    if (el.options[i].value.toLowerCase().includes(value.toLowerCase()) || value.toLowerCase().includes(el.options[i].value.toLowerCase())) {
      el.selectedIndex = i;
      return;
    }
  }
}

function setInputValue(id, value) {
  const el = document.getElementById(id);
  if (el && value !== undefined) {
    el.value = value;
  }
}

function refreshBlueprintCard(zoneParam, calcLParam) {
  const zoneTag = document.getElementById('blueprint-zone-tag');
  if (zoneTag && zoneParam) {
    zoneTag.innerText = `Zona Barton Z${zoneParam.id}: ${zoneParam.name}`;
    zoneTag.style.background = zoneParam.color || 'rgba(96, 160, 64, 0.18)';
    zoneTag.style.color = zoneParam.stroke || 'var(--primary-lime)';
  }

  const span = parseFloat(document.getElementById('q-input-span')?.value || 10);
  const esr = parseFloat(document.getElementById('q-select-esr')?.value || 1.6);
  const calcL = calcLParam || calculateBoltLength(span, esr);

  const adoptedL = parseFloat(document.getElementById('bolt-adopted-length-input')?.value || roundBoltLength(calcL));
  const boltType = document.getElementById('bolt-type-select')?.value || "Barra Helicoidal";
  const boltDiam = document.getElementById('bolt-diameter-select')?.value || "25 mm";
  const boltSpacing = document.getElementById('bolt-spacing-input')?.value || "1.5 m x 1.5 m";

  const shotThick = document.getElementById('shotcrete-thickness-input')?.value || "9-12 cm";
  const shotType = document.getElementById('shotcrete-type-select')?.value || "Con fibra";
  const shotFiber = document.getElementById('shotcrete-fiber-select')?.value || "Acero";

  const meshReq = document.getElementById('mesh-required-select')?.value || "Opcional";
  const meshType = document.getElementById('mesh-type-select')?.value || "Electrosoldada 6x6 W2.9/W2.9";

  const girdersReq = document.getElementById('girders-required-select')?.value || "No requerido";
  const girdersSpacing = document.getElementById('girders-spacing-select')?.value || "1.0 m";

  // Update Blueprint values
  const bpShotcrete = document.getElementById('bp-shotcrete-val');
  if (bpShotcrete) bpShotcrete.innerText = `Shotcrete ${shotThick} (${shotType}${shotFiber !== 'Ninguna' ? ' / ' + shotFiber : ''})`;

  const bpBolts = document.getElementById('bp-bolts-val');
  if (bpBolts) bpBolts.innerText = `L = ${adoptedL.toFixed(1)} m (Calc: ${calcL} m) | Ø${boltDiam} | ${boltSpacing} | ${boltType}`;

  const bpMesh = document.getElementById('bp-mesh-val');
  if (bpMesh) bpMesh.innerText = `${meshReq} (${meshType})`;

  const bpGirders = document.getElementById('bp-girders-val');
  if (bpGirders) bpGirders.innerText = girdersReq === 'No requerido' ? 'No requerido' : `${girdersReq} (c/ ${girdersSpacing})`;
}

/* --------------------------------------------------------------------------
   5. HOEK-BROWN & GSI MATRIX CALCULATOR CONTROLLER
   -------------------------------------------------------------------------- */
function initHoekBrownCalculator() {
  const gsiSlider = document.getElementById('hb-gsi-slider');
  const dSlider = document.getElementById('hb-d-slider');

  if (gsiSlider) {
    gsiSlider.addEventListener('input', (e) => {
      document.getElementById('hb-gsi-display').innerText = e.target.value;
      updateHBCalculation();
    });
  }

  if (dSlider) {
    dSlider.addEventListener('input', (e) => {
      const val = parseFloat(e.target.value);
      document.getElementById('hb-d-display').innerText = `${val.toFixed(1)} ${val === 0 ? '(Sin perturbación)' : val <= 0.5 ? '(Voladura media)' : '(Muy deficiente)'}`;
      updateHBCalculation();
    });
  }

  ['hb-sigci', 'hb-mi'].forEach(id => {
    document.getElementById(id)?.addEventListener('input', updateHBCalculation);
  });

  // Source & Reference chip button listeners
  document.querySelectorAll('.source-chips-group').forEach(group => {
    group.querySelectorAll('.chip-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        group.querySelectorAll('.chip-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
      });
    });
  });

  // Chart Mode Switcher listeners
  const btnMohr = document.getElementById('hb-mode-mohr');
  const btnPrincipal = document.getElementById('hb-mode-principal');

  if (btnMohr && btnPrincipal) {
    btnMohr.addEventListener('click', () => {
      btnMohr.classList.add('active');
      btnPrincipal.classList.remove('active');
      setHoekBrownPlotMode('mohr');
      updateHBCalculation();
    });

    btnPrincipal.addEventListener('click', () => {
      btnPrincipal.classList.add('active');
      btnMohr.classList.remove('active');
      setHoekBrownPlotMode('principal');
      updateHBCalculation();
    });
  }

  // GSI Matrix Modal handlers
  document.getElementById('open-gsi-matrix-btn')?.addEventListener('click', () => {
    document.getElementById('gsi-modal')?.classList.add('active');
    buildGSIMatrixTable();
  });

  document.getElementById('close-gsi-modal')?.addEventListener('click', () => {
    document.getElementById('gsi-modal')?.classList.remove('active');
  });

  updateHBCalculation();
}

function updateHBCalculation() {
  const sigCi = parseFloat(document.getElementById('hb-sigci')?.value || 80);
  const mi = parseFloat(document.getElementById('hb-mi')?.value || 15);
  const gsi = parseFloat(document.getElementById('hb-gsi-slider')?.value || 55);
  const D = parseFloat(document.getElementById('hb-d-slider')?.value || 0.6);

  const hb = calculateHoekBrown(sigCi, mi, gsi, D);

  document.getElementById('hb-res-mb').innerText = hb.mb;
  document.getElementById('hb-res-s').innerText = hb.s;
  document.getElementById('hb-res-a').innerText = hb.a;
  document.getElementById('hb-res-sigcm').innerText = `${hb.sigCm} MPa`;
  document.getElementById('hb-res-em').innerText = `${hb.Em.toLocaleString()} MPa`;

  // Mohr-Coulomb Equivalent parameters update
  const cMPa = (hb.cohesionKPa / 1000).toFixed(2);
  const cElement = document.getElementById('hb-res-cohesion');
  if (cElement) cElement.innerText = `${cMPa} MPa (${hb.cohesionKPa} kPa)`;

  const phiElement = document.getElementById('hb-res-friction');
  if (phiElement) phiElement.innerText = `${hb.frictionDeg}°`;

  renderHoekBrownEnvelope('hb-envelope-canvas', sigCi, mi, gsi, D, currentPlotMode);
}


function buildGSIMatrixTable() {
  const table = document.getElementById('gsi-matrix-table');
  if (!table) return;

  const rows = [
    { title: "Intacta / Masiva", scores: [85, 75, 65, 55, 45] },
    { title: "En bloque (Buena trabazón)", scores: [75, 65, 55, 45, 35] },
    { title: "Muy en bloque (Interconectada)", scores: [65, 55, 45, 35, 25] },
    { title: "Perturbada / Fracturada", scores: [50, 40, 30, 20, 15] },
    { title: "Desintegrada / Cizallada", scores: [35, 25, 18, 12, 10] }
  ];

  const cols = [
    "Muy Buena (Fresca)", "Buena (Poco alterada)", "Regular (Lisa/Rugosa)", "Mala (Alterada)", "Muy Mala (Pátinas arcilla)"
  ];

  let html = `<thead><tr><th>Estructura Geológica ↓ \\ Condición Superficie →</th>${cols.map(c => `<th>${c}</th>`).join('')}</tr></thead><tbody>`;

  rows.forEach(r => {
    html += `<tr><td style="font-weight: 600; text-align: left; background: rgba(18,49,73,0.5);">${r.title}</td>`;
    r.scores.forEach(s => {
      html += `<td data-gsi="${s}"><span class="gsi-cell-score">${s}</span>GSI aprox</td>`;
    });
    html += `</tr>`;
  });

  html += `</tbody>`;
  table.innerHTML = html;

  table.querySelectorAll('td[data-gsi]').forEach(cell => {
    cell.addEventListener('click', (e) => {
      const gsiVal = cell.getAttribute('data-gsi');
      const slider = document.getElementById('hb-gsi-slider');
      if (slider) {
        slider.value = gsiVal;
        document.getElementById('hb-gsi-display').innerText = gsiVal;
        updateHBCalculation();
      }
      document.getElementById('gsi-modal')?.classList.remove('active');
    });
  });
}

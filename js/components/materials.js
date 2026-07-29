/* ==========================================================================
   LITHICA GEOTECH - MATERIAL KNOWLEDGE BASE & CONTRADICTION RESOLVER COMPONENT
   ========================================================================== */

import { GEOTECH_MATERIALS } from '../knowledge_base.js';

let currentSelectedMaterialId = GEOTECH_MATERIALS[0].id;

export function initMaterialsComponent() {
  const searchInput = document.getElementById('material-search');
  const categoryFilter = document.getElementById('material-category-filter');

  if (searchInput) {
    searchInput.addEventListener('input', () => filterAndRenderMaterialList());
  }

  if (categoryFilter) {
    categoryFilter.addEventListener('change', () => filterAndRenderMaterialList());
  }

  filterAndRenderMaterialList();
  renderMaterialDetail(currentSelectedMaterialId);
}

export function filterAndRenderMaterialList() {
  const searchVal = document.getElementById('material-search')?.value.toLowerCase() || '';
  const catVal = document.getElementById('material-category-filter')?.value || 'all';
  const listEl = document.getElementById('material-list');

  if (!listEl) return;

  const filtered = GEOTECH_MATERIALS.filter(mat => {
    const matchesSearch = mat.name.toLowerCase().includes(searchVal) || mat.description.toLowerCase().includes(searchVal);
    const matchesCat = catVal === 'all' || mat.category === catVal;
    return matchesSearch && matchesCat;
  });

  listEl.innerHTML = filtered.map(mat => `
    <li class="material-item ${mat.id === currentSelectedMaterialId ? 'selected' : ''}" data-id="${mat.id}">
      <div>
        <div class="mat-name">${mat.name}</div>
        <small style="color: var(--text-muted); font-size: 0.75rem;">UCS Rec: ${mat.recommended.ucs} MPa</small>
      </div>
      <span class="mat-type-pill ${mat.category}">${mat.category}</span>
    </li>
  `).join('');

  // Add Click listeners
  listEl.querySelectorAll('.material-item').forEach(item => {
    item.addEventListener('click', (e) => {
      const id = e.currentTarget.getAttribute('data-id');
      currentSelectedMaterialId = id;
      document.querySelectorAll('.material-item').forEach(el => el.classList.remove('selected'));
      e.currentTarget.classList.add('selected');
      renderMaterialDetail(id);
    });
  });
}

export function renderMaterialDetail(materialId) {
  const detailEl = document.getElementById('material-detail-view');
  const mat = GEOTECH_MATERIALS.find(m => m.id === materialId);

  if (!detailEl || !mat) return;

  // Build Sources HTML for Expert Mode Contradiction Resolver
  const ucsMinAll = Math.min(...mat.sources.map(s => s.ucs_range[0]));
  const ucsMaxAll = Math.max(...mat.sources.map(s => s.ucs_range[1]));
  const ucsSpan = ucsMaxAll - ucsMinAll;

  const rangeBarsHtml = `
    <div class="prop-range-block">
      <div class="prop-name">
        <span>Rango Bibliográfico Comparativo UCS (MPa)</span>
        <span style="color: var(--accent-purple);">${ucsMinAll} MPa ───────── ${ucsMaxAll} MPa</span>
      </div>
      <div class="range-bar-track">
        <div class="range-bar-fill" style="left: 0%; width: 100%;"></div>
        ${mat.sources.map(src => {
          const avg = (src.ucs_range[0] + src.ucs_range[1]) / 2;
          const posPct = ((avg - ucsMinAll) / (ucsSpan || 1)) * 100;
          return `<div class="range-author-pin" style="left: ${posPct}%;" title="${src.author} (${src.year}): ${src.ucs_range[0]}-${src.ucs_range[1]} MPa"></div>`;
        }).join('')}
      </div>
    </div>
  `;

  const citationsHtml = mat.sources.map(src => `
    <li class="citation-item">
      <strong style="color: var(--primary-lime);">${src.author} (${src.year})</strong>: 
      Rango UCS: <code>${src.ucs_range[0]} - ${src.ucs_range[1]} MPa</code> | 
      Factor $m_i$: <code>${src.mi || mat.recommended.mi}</code> | 
      Confianza: <span class="confidence-indicator ${src.confidence}">${src.confidence}</span>
      ${src.n_samples ? ` | Muestras ($n$): ${src.n_samples}` : ''}
      ${src.notes ? `<p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.2rem;">${src.notes}</p>` : ''}
    </li>
  `).join('');

  detailEl.innerHTML = `
    <div class="mat-header-box">
      <div class="mat-title-area">
        <h3>${mat.name}</h3>
        <p class="subtitle">${mat.description}</p>
        <div class="mat-meta-info">
          <span class="pill-tag">${mat.region}</span>
          <span class="pill-tag" style="color: var(--primary-lime);">Confianza: ${mat.confidence.toUpperCase()}</span>
          <span class="pill-tag" style="color: var(--accent-purple);">Variabilidad: ${mat.variability}</span>
        </div>
      </div>
    </div>

    <!-- MODO INGENIERO: Recomendación Directa -->
    <div class="engineer-recommendation-box">
      <h4>Valores de Diseño Recomendados (Modo Ingeniero)</h4>
      <div class="rec-values-grid">
        <div class="rec-item">
          <span class="label">UCS Recomendado:</span>
          <span class="val">${mat.recommended.ucs} MPa</span>
        </div>
        <div class="rec-item">
          <span class="label">Resistencia Tracción:</span>
          <span class="val">${mat.recommended.tensile} MPa</span>
        </div>
        <div class="rec-item">
          <span class="label">Densidad Seca:</span>
          <span class="val">${mat.recommended.density} g/cm³</span>
        </div>
        <div class="rec-item">
          <span class="label">Módulo Young ($E_i$):</span>
          <span class="val">${mat.recommended.young} GPa</span>
        </div>
        <div class="rec-item">
          <span class="label">Coeficiente Poisson ($\nu$):</span>
          <span class="val">${mat.recommended.poisson}</span>
        </div>
        <div class="rec-item">
          <span class="label">Constante $m_i$ Intacta:</span>
          <span class="val" style="color: var(--accent-cyan);">${mat.recommended.mi}</span>
        </div>
      </div>
    </div>

    <!-- MODO EXPERTO: Resolutor de Contradicciones Bibliográficas -->
    <div class="expert-contradiction-section">
      <div class="section-title-expert">
        <h4>Análisis Bibliográfico & Trazabilidad de Fuentes (Modo Experto)</h4>
        <span class="confidence-indicator ${mat.confidence}">Nivel de Confianza: ${mat.confidence}</span>
      </div>
      
      ${rangeBarsHtml}

      <h5 style="color: var(--text-main); font-size: 0.9rem; margin-top: 1.2rem; margin-bottom: 0.6rem;">Desglose Bibliográfico por Autor y Año:</h5>
      <ul class="source-citations-list">
        ${citationsHtml}
      </ul>
    </div>
  `;
}

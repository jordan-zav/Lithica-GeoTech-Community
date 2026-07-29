/* ==========================================================================
   LITHICA GEOTECH - ISRM SUGGESTED METHODS COMPONENT
   ========================================================================== */

import { ISRM_STANDARDS } from '../knowledge_base.js';

export function initISRMComponent() {
  const container = document.getElementById('isrm-methods-grid');
  const filterBtns = document.querySelectorAll('.filter-pill');

  if (!container) return;

  filterBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      filterBtns.forEach(b => b.classList.remove('active'));
      e.target.classList.add('active');
      const book = e.target.getAttribute('data-book');
      renderISRM(book);
    });
  });

  renderISRM('all');
}

export function renderISRM(bookFilter = 'all') {
  const container = document.getElementById('isrm-methods-grid');
  if (!container) return;

  const filtered = ISRM_STANDARDS.filter(s => bookFilter === 'all' || s.book === bookFilter);

  container.innerHTML = filtered.map(item => `
    <div class="glass-card isrm-card">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <span class="isrm-book-badge ${item.book}">
          ${item.book === 'blue' ? 'Blue Book (1974-2006)' : 'Orange Book (2007-2014)'}
        </span>
        <span class="pill-tag" style="font-size: 0.72rem;">Año ${item.year}</span>
      </div>
      <h3 style="font-family: var(--font-heading); font-size: 1.15rem; color: #FFFFFF; margin-top: 0.4rem;">${item.title}</h3>
      <p style="font-size: 0.85rem; color: var(--text-muted);">${item.summary}</p>
      <div style="margin-top: 0.6rem; border-top: 1px solid var(--border-outline); padding-top: 0.6rem;">
        <strong style="font-size: 0.78rem; color: var(--accent-cyan); text-transform: uppercase;">Requisitos Clave ISRM:</strong>
        <ul style="margin-left: 1.2rem; font-size: 0.8rem; color: var(--text-main); margin-top: 0.3rem;">
          ${item.key_requirements.map(req => `<li>${req}</li>`).join('')}
        </ul>
      </div>
    </div>
  `).join('');
}

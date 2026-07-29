/* ==========================================================================
   LITHICA GEOTECH - SETTINGS & THEME CONTROLLER
   ========================================================================== */

import { setAppLanguage, t } from './i18n.js';

const STORAGE_KEYS = {
  THEME: 'lithica_geotech_theme_v1',
  LANG: 'lithica_geotech_lang_v1',
  SCALE: 'lithica_geotech_scale_v1'
};

export const AppSettings = {
  themePreference: 'system', // 'system' | 'light' | 'dark'
  languageCode: 'es',       // 'es' | 'en'
  guiScale: 1.0,            // 0.8 to 1.4
  systemThemeMediaQuery: null
};

export function initSettingsSystem() {
  loadPreferences();
  initSystemThemeListener();
  applyTheme();
  applyGuiScale();
  applyLanguage();

  initSettingsModalEvents();
}

function loadPreferences() {
  try {
    const savedTheme = localStorage.getItem(STORAGE_KEYS.THEME);
    if (['system', 'light', 'dark'].includes(savedTheme)) {
      AppSettings.themePreference = savedTheme;
    }

    const savedLang = localStorage.getItem(STORAGE_KEYS.LANG);
    if (['es', 'en'].includes(savedLang)) {
      AppSettings.languageCode = savedLang;
    }

    const savedScale = parseFloat(localStorage.getItem(STORAGE_KEYS.SCALE));
    if (!isNaN(savedScale) && savedScale >= 0.8 && savedScale <= 1.4) {
      AppSettings.guiScale = Math.round(savedScale * 10) / 10;
    }
  } catch (err) {
    console.warn('Lithica GeoTech: Error reading localStorage preferences', err);
  }
}

function savePreferences() {
  try {
    localStorage.setItem(STORAGE_KEYS.THEME, AppSettings.themePreference);
    localStorage.setItem(STORAGE_KEYS.LANG, AppSettings.languageCode);
    localStorage.setItem(STORAGE_KEYS.SCALE, AppSettings.guiScale.toString());
  } catch (err) {
    console.warn('Lithica GeoTech: Error writing localStorage preferences', err);
  }
}

function initSystemThemeListener() {
  AppSettings.systemThemeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
  AppSettings.systemThemeMediaQuery.addEventListener('change', () => {
    if (AppSettings.themePreference === 'system') {
      applyTheme();
    }
  });
}

export function applyTheme(pref = AppSettings.themePreference) {
  AppSettings.themePreference = pref;
  const body = document.body;

  let effectiveIsDark = true;
  if (pref === 'system') {
    effectiveIsDark = AppSettings.systemThemeMediaQuery ? AppSettings.systemThemeMediaQuery.matches : true;
  } else {
    effectiveIsDark = (pref === 'dark');
  }

  if (effectiveIsDark) {
    body.classList.add('dark-theme');
    body.classList.remove('light-theme');
    document.documentElement.setAttribute('data-theme', 'dark');
  } else {
    body.classList.add('light-theme');
    body.classList.remove('dark-theme');
    document.documentElement.setAttribute('data-theme', 'light');
  }

  // Update UI segmented control active state
  document.querySelectorAll('.theme-seg-btn').forEach(btn => {
    const val = btn.getAttribute('data-theme-val');
    if (val === pref) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  savePreferences();

  // Dispatch custom event for canvas dynamic re-rendering
  window.dispatchEvent(new CustomEvent('geotech-theme-changed', { detail: { isDark: effectiveIsDark } }));
}

export function applyGuiScale(scale = AppSettings.guiScale) {
  const normalized = Math.round(Math.max(0.8, Math.min(1.4, scale)) * 10) / 10;
  AppSettings.guiScale = normalized;

  document.documentElement.style.setProperty('--gui-scale', normalized.toString());

  const scaleValDisplay = document.getElementById('gui-scale-value-display');
  if (scaleValDisplay) {
    scaleValDisplay.innerText = `${Math.round(normalized * 100)}%`;
  }

  const slider = document.getElementById('gui-scale-slider');
  if (slider) {
    slider.value = normalized.toString();
  }

  savePreferences();
}

export function applyLanguage(lang = AppSettings.languageCode) {
  AppSettings.languageCode = lang;
  setAppLanguage(lang);

  // Update Language Segmented Button UI
  document.querySelectorAll('.lang-seg-btn').forEach(btn => {
    const val = btn.getAttribute('data-lang-val');
    if (val === lang) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  // Translate all DOM elements with data-i18n attribute
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (key) {
      el.innerText = t(key);
    }
  });

  // Translate placeholders
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.getAttribute('data-i18n-placeholder');
    if (key) {
      el.placeholder = t(key);
    }
  });

  // Translate title tooltips
  document.querySelectorAll('[data-i18n-title]').forEach(el => {
    const key = el.getAttribute('data-i18n-title');
    if (key) {
      el.title = t(key);
    }
  });

  savePreferences();
}

function initSettingsModalEvents() {
  const modal = document.getElementById('settings-modal');
  const openBtn = document.getElementById('open-settings-btn');
  const closeBtn = document.getElementById('close-settings-modal');

  if (openBtn && modal) {
    openBtn.addEventListener('click', () => {
      modal.classList.add('active');
    });
  }

  if (closeBtn && modal) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('active');
    });
  }

  // Close modal when clicking on overlay
  if (modal) {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('active');
      }
    });
  }

  // Theme Segmented Buttons
  document.querySelectorAll('.theme-seg-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const themeVal = btn.getAttribute('data-theme-val');
      applyTheme(themeVal);
    });
  });

  // Language Segmented Buttons
  document.querySelectorAll('.lang-seg-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const langVal = btn.getAttribute('data-lang-val');
      applyLanguage(langVal);
    });
  });

  // GUI Scale Slider & Reset Button
  const slider = document.getElementById('gui-scale-slider');
  if (slider) {
    slider.addEventListener('input', (e) => {
      applyGuiScale(parseFloat(e.target.value));
    });
  }

  const resetScaleBtn = document.getElementById('reset-scale-btn');
  if (resetScaleBtn) {
    resetScaleBtn.addEventListener('click', () => {
      applyGuiScale(1.0);
    });
  }

  // Scientific Attributions Modal Events
  const openAttrBtn = document.getElementById('open-attributions-btn');
  const attrModal = document.getElementById('attributions-modal');
  const closeAttrBtn = document.getElementById('close-attributions-modal');

  if (openAttrBtn && attrModal) {
    openAttrBtn.addEventListener('click', () => {
      attrModal.classList.add('active');
    });
  }

  if (closeAttrBtn && attrModal) {
    closeAttrBtn.addEventListener('click', () => {
      attrModal.classList.remove('active');
    });
  }

  if (attrModal) {
    attrModal.addEventListener('click', (e) => {
      if (e.target === attrModal) {
        attrModal.classList.remove('active');
      }
    });
  }
}

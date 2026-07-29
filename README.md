# Lithica GeoTech

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-v3.x-02569B?logo=flutter)](https://flutter.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20Windows-green.svg)](#)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](#)

**Lithica GeoTech** es una plataforma y base de conocimiento geotécnica versionada multiplataforma (Android y Windows), diseñada para la consulta técnica de laboratorio y campo, clasificación geomecánica de macizos rocosos y cálculos numéricos de diseño en ingeniería geológica y geotecnia de minería y obras civiles.

---

## 🚀 Características Principales

### 📚 Base de Conocimiento de Materiales Geotécnicos
- **Biblioteca Geológica Integral:** Compendio ordenado de rocas ígneas, sedimentarias, metamórficas y suelos representativos.
- **Propiedades Mecánicas y Físicas:** Valores recomendados de densidad, resistencia a la compresión simple ($\sigma_{ci}$), módulo de elasticidad ($E$), razón de Poisson ($\nu$), cohesión ($c$) y ángulo de fricción ($\phi$).
- **Trazabilidad y Calidad:** Información sobre procedencia, nivel de confianza y variabilidad típica de los datos.

### ⛏️ Clasificación Geomecánica RMR (Bieniawski)
- **Soporte Multiversión:** Implementación completa de **RMR89**, **RMR76**, **RMR73** e **RMR14** (*Bieniawski et al.*).
- **Cálculo RMR14 Avanzado:** Evaluación específica de frecuencia de discontinuidades, alterabilidad de matriz, orientación de juntas, factores de ajuste por esfuerzo y método de excavación.
- **Modo Experto:** Desglose matricial de puntuaciones parciales y fórmulas para auditoría geotécnica.

### 📐 Q-System de Barton
- **Parámetros Geomecánicos:** Cálculo de $Q = \left(\frac{RQD}{J_n}\right) \times \left(\frac{J_r}{J_a}\right) \times \left(\frac{J_w}{SRF}\right)$ y corrección por resistencia $Q_c$.
- **Criterios Históricos y Modernos:** Incorporación de Barton (1974), Grimstad & Barton (1993) y Barton (2002).
- **Carta de Soporte Interactiva:** Renderizado dinámico de la tabla de sostenimiento mediante canvas dedicado (`q_support_painter.dart`), evaluando la Dimensión Equivalente del túnel ($D_e = \text{Luz / ESR}$) con factores $ESR$ de 0.5 a 5.0.

### 📈 Criterio de Rotura Hoek-Brown & Mohr-Coulomb
- **Hoek-Brown (2002):** Determinación de la envolvente no lineal para macizos rocosos con parámetros $m_b$, $s$ y $a$ según $GSI$, $D$ y $m_i$.
- **Resistencia del Macizo Rocoso:** Cálculo de la resistencia a la compresión uniaxial del macizo ($\sigma_{cm}$) y resistencia a la tracción ($\sigma_{tm}$).
- **Equivalencia a Mohr-Coulomb:** Ajuste lineal dentro del rango de confinamiento ($\sigma_{3,\max}$) para estimar cohesión equivalente ($c'$) y ángulo de fricción ($ \phi' $).
- **Gráficos Interactivos:** Envolvente gráfica de esfuerzos normal y cortante mediante `hoek_envelope_painter.dart`.

### 📖 Compendio de Estándares ISRM
- **Sugerencias Metodológicas ISRM:** Guías de ensayo de laboratorio y campo de los libros *Blue Book* y *Orange Book*.
- **Filtros Especializados:** Búsqueda por categoría (propiedades índice, ensayos de resistencia, deformabilidad, discontinuidades).
- **Detalle Operativo:** Objetivos, equipamiento requerido, procedimiento paso a paso y criterios de aceptación.

---

## 🎨 Interfaz y Modos de Uso

- **Modo Ingeniero:** Interfaz optimizada para el cálculo operativo rápido en campo y gabinete.
- **Modo Experto:** Vista extendida con auditoría de ecuaciones, referencias bibliográficas y procedimientos detallados.
- **Adaptabilidad Responsiva:** Maquetación fluida para dispositivos móviles (vertical) y pantallas de escritorio/laptop (horizontal).
- **Diseño Visual:** Tema claro y oscuro con soporte para escalado de GUI personalizado y áreas seguras (*Safe Area*).

---

## 🛠️ Arquitectura del Proyecto

El código está estructurado bajo principios de arquitectura limpia (*Clean Architecture*) en Flutter/Dart:

```text
lib/
├── main.dart                       # Punto de entrada de la aplicación
└── src/
    ├── app.dart                    # Configuración global, temas y puerta de autenticación
    ├── application/                # Controladores de estado y servicios (Auth, Theme, Settings)
    ├── config/                     # Constantes de build y recursos legales
    ├── data/                       # Base de datos local de materiales geotécnicos (geotech_kb.dart)
    ├── domain/                     # Motores numéricos de RMR, Q-System, Hoek-Brown e ISRM
    ├── presentation/               # Vistas y pantallas (Home, RMR, Q, Hoek-Brown, ISRM, KB)
    ├── theme/                      # Paleta de colores y estilos Lithica
    └── widgets/                    # Componentes gráficos personalizados (Painters, Charts, Bars)
```

---

## 🔐 Seguridad y Control de Acceso

- **Autenticación:** Integración con Firebase Authentication y Google Sign-In (nativo en Android, OAuth PKCE en Windows).
- **Validación Offline:** Política de acceso fuera de línea de hasta 7 días mediante verificación en Firestore (`allowed_users`).
- **Privacidad:** Las credenciales y claves locales se gestionan mediante archivos de configuración excluidos del control de versiones.

---

## 🧪 Pruebas Unitarias e Integración

El proyecto cuenta con una suite de pruebas para verificar el dominio y comportamiento de la interfaz:

```bash
# Ejecutar todas las pruebas unitarias y de widgets
flutter test
```

Principales suites incluidas:
- `test/geotech_calculations_test.dart`: Validación matemática de RMR14, Q, Qc, Hoek-Brown y conversiones Mohr-Coulomb.
- `test/offline_access_policy_test.dart`: Verificación de la política de acceso offline de 7 días.
- `test/widget_test.dart`: Pruebas de la interfaz de usuario, escalado y navegación.

---

## 📦 Compilación y Desarrollo

### Requisitos Previos
- **Flutter SDK:** v3.x o superior
- **Dart SDK:** Incluido con Flutter
- **Android SDK:** (Para compilación Android)
- **Visual Studio 2022:** Con carga de trabajo "Desarrollo para el escritorio con C++" (Para compilación Windows)

### Ejecución Local

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en modo desarrollo para Windows
flutter run -d windows

# Ejecutar en modo desarrollo para Android
flutter run -d android
```

---

## 📜 Licencia

Este proyecto está distribuido bajo la licencia **GNU General Public License v3.0 (GPL-3.0)**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

```text
Copyright (C) 2026 Jordan Zavaleta
Lithica GeoTech es software libre: puedes redistribuirlo y/o modificarlo
bajo los términos de la Licencia Pública General GNU publicada por la
Free Software Foundation, ya sea la versión 3 de la Licencia, o (a tu elección)
cualquier versión posterior.
```

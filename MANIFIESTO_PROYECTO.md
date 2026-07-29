# Manifiesto del Proyecto Lithica GeoTech

Última revisión del inventario: 28 de julio de 2026

## Identidad

- Nombre comercial: Lithica GeoTech
- Paquete Flutter: lithica_geotech
- Identificador Android: com.gisgeodev.lithicageotech
- Versión declarada: 1.0.0
- Número de build declarado: 1
- Proyecto Firebase: lithica-geotech
- Plataformas de distribución activas: Android y Windows
- Propósito: plataforma y base de conocimiento geotécnica versionada para consulta técnica, clasificación de macizos rocosos y cálculos de diseño.

## Estado general

La aplicación principal es un proyecto Flutter de escritorio y móvil. Android y Windows comparten la misma lógica de dominio, presentación, autenticación y acceso a Firestore.

Los archivos index.html, css y js de la raíz corresponden a un prototipo web heredado. No son el punto de entrada usado por ABRIR_LITHICA_GEOTECH.bat ni por los empaquetadores actuales. El ejecutable oficial de Windows es artifacts\windows\Release\lithica_geotech.exe.

## Funciones incluidas

### Base de conocimiento

- Biblioteca de materiales geotécnicos.
- Rocas ígneas, sedimentarias y metamórficas.
- Materiales de suelo representativos.
- Propiedades mecánicas y físicas recomendadas.
- Procedencia, confianza y variabilidad de los valores.
- Base principal en lib\src\data\geotech_kb.dart.

### RMR de Bieniawski

- RMR89.
- RMR76.
- RMR73 histórico.
- RMR14.
- Tablas y parámetros propios de cada versión.
- Lógica específica de RMR14 para frecuencia de juntas, alterabilidad, factores de excavación y esfuerzo.
- Trazabilidad adicional en modo experto.

### Q-System de Barton

- Cálculo de Q mediante RQD, Jn, Jr, Ja, Jw y SRF.
- Cálculo separado de Qc.
- Versiones y criterios de Barton 1974, Grimstad y Barton 1993, y Barton 2002.
- Carta de soporte geotécnico.
- Selección de tipo de excavación y factor ESR.
- Tabla ESR desde 5.0 hasta 0.5.
- Ajuste de diseño para condiciones de Q bajo según el criterio incorporado.
- Visualización especializada mediante q_support_painter.dart.

### Hoek-Brown y Mohr-Coulomb

- Criterio Hoek-Brown 2002.
- Parámetros mb, s y a.
- Resistencia del macizo rocoso.
- Confinamiento máximo de aplicación.
- Equivalencia de cohesión y ángulo de fricción de Mohr-Coulomb.
- Conversión a esfuerzos normal y cortante.
- Envolvente gráfica mediante hoek_envelope_painter.dart.

### Estándares ISRM

- Compendio de métodos sugeridos ISRM.
- Clasificación Blue Book y Orange Book.
- Filtros por libro y categoría.
- Resumen, objetivo, criterios, equipamiento y procedimientos.
- Información técnica ampliada en modo experto.

## Modos de interfaz

- Modo Ingeniero para el uso operativo.
- Modo Experto con auditoría, formulación, procedimientos y datos técnicos adicionales.
- Tema claro, oscuro o según el sistema.
- Escala de interfaz configurable.
- Estado de las preferencias persistente.
- Navegación inferior adaptable.
- En formato vertical, la página completa se desplaza.
- En formato horizontal, se conservan los desplazamientos internos apropiados para laptops y PC.
- Respeto de las áreas seguras de Android, incluida la navegación mediante botones del sistema.

## Arquitectura del código

### Entrada y aplicación

- lib\main.dart: punto de entrada Flutter.
- lib\src\app.dart: aplicación, tema, pantalla inicial y puerta de autenticación.
- lib\src\presentation\geotech_home_page.dart: navegación principal y cambio entre módulos.

### Aplicación y estado

- lib\src\application\geotech_controller.dart: tema, escala de GUI y modo experto.
- lib\src\application\auth_access_controller.dart: sesión, autorización, Firestore y acceso offline.
- lib\src\application\google_identity_service.dart: inicio de sesión de Google para Android y Windows.

### Dominio

- lib\src\domain\geotech_models.dart: modelos de materiales y estándares.
- lib\src\domain\geotech_calculations.dart: cálculos RMR14, Q, Qc, ESR, Hoek-Brown y equivalencia Mohr-Coulomb.
- lib\src\domain\rmr_version_data.dart: definiciones versionadas de RMR.
- lib\src\domain\q_version_data.dart: versiones de Q-System, tablas de soporte y ESR.

### Presentación

- kb_page.dart: base de conocimiento.
- rmr_page.dart: calculadora RMR.
- q_system_page.dart: calculadora Q-System y soporte.
- hoek_brown_page.dart: Hoek-Brown y Mohr-Coulomb.
- isrm_page.dart: compendio ISRM.
- geotech_settings_dialog.dart: configuración, identidad y cierre de sesión.
- auth_gate.dart: bloqueo de entrada y pantalla de identificación.

### Tema y componentes

- lib\src\theme\lithica_theme.dart: paleta y estilos Lithica.
- lib\src\widgets\lithica_background.dart: fondo visual.
- lib\src\widgets\responsive_page_scroll.dart: comportamiento vertical y horizontal.
- lib\src\widgets\rock_range_bar.dart: rangos de propiedades.
- lib\src\widgets\q_support_painter.dart: carta de soporte Q.
- lib\src\widgets\hoek_envelope_painter.dart: envolvente de resistencia.

## Identificación y control de acceso

El acceso exige una cuenta de Google en Android y Windows.

### Flujo

1. Firebase Authentication identifica al usuario.
2. La aplicación consulta allowed_users usando el correo normalizado como identificador del documento.
3. Si el usuario no existe, la aplicación crea su registro con enabled igual a true y role igual a tester.
4. Si un administrador cambia enabled a false, el cliente no puede reactivarlo y se bloquea el acceso.
5. Una verificación online satisfactoria renueva el acceso offline por siete días.
6. Transcurridos más de siete días sin verificación online, se impide el ingreso.
7. Cerrar sesión elimina la verificación local guardada.

### Datos registrados en Firestore

- email
- uid
- enabled
- role
- createdAt
- appVersion
- buildNumber
- platform
- lastSeenAt
- sessionCount
- activeDay

### Seguridad de Firestore

- El usuario solo puede leer su propio documento.
- La creación automática exige identidad coincidente, enabled igual a true y role igual a tester.
- El cliente solo puede actualizar datos de uso.
- El cliente no puede modificar uid, enabled ni role.
- El cliente no puede eliminar documentos.
- Todas las demás colecciones quedan denegadas por defecto.
- La configuración local está en firebase.json y firestore.rules.
- Las reglas fueron publicadas en el proyecto Firebase el 27 de julio de 2026.

## Configuración Firebase y OAuth

- assets\config\firebase_options.json contiene las opciones públicas necesarias para inicializar Firebase en Android y Windows.
- Android usa Google Sign-In nativo.
- Windows usa OAuth de Google con PKCE, navegador del sistema y retorno por una dirección local temporal.
- local_secrets\google-desktop-oauth.json contiene la credencial de escritorio usada durante el build de Windows.
- local_secrets está excluido del control de versiones y no debe copiarse a paquetes públicos.
- android\key.properties y android\lithica-geotech-upload.jks son necesarios para firmar Android y tampoco deben publicarse.
- Este manifiesto no contiene claves, contraseñas ni valores secretos.

## Empaquetado y ejecución

### Apertura en Windows

ABRIR_LITHICA_GEOTECH.bat recompila la versión Release, actualiza artifacts\windows\Release y abre lithica_geotech.exe. No abre una página web.

### Build Android

- BUILD_APK.bat genera un APK Release firmado.
- BUILD_AAB.bat genera un Android App Bundle firmado para Google Play.
- Ambos solicitan versión y número de build.
- Ambos regeneran los iconos de Android.
- El nombre final incluye Lithica GeoTech, plataforma, versión y build.
- Los paquetes terminados se guardan en artifacts\android.

### Build Windows

- build-windows.bat solicita versión y número de build.
- Carga la configuración OAuth de escritorio.
- Genera el paquete Release completo.
- Copia el resultado a artifacts\windows\Release.

### Entorno portable

- Los BAT determinan la raíz del proyecto a partir de su propia ubicación.
- No dependen de una letra de unidad fija para localizar Lithica GeoTech.
- Los proyectos Lithica pueden compartir herramientas respetando la misma jerarquía.
- Flutter se busca mediante FLUTTER_ROOT, tools\flutter, el proyecto hermano Lithica Explorer o PATH.
- Los temporales, caché de Pub, Gradle y workspace de compilación se mantienen en D:\Lithica_Temp\LithicaGeoTech.
- La copia temporal evita los enlaces simbólicos problemáticos dentro de Google Drive.

## Artefactos disponibles al revisar

### Android

- artifacts\android\Lithica GeoTech Android v1.0.0 build 1.apk
- artifacts\android\Lithica GeoTech Android v0.1.0 build 1.aab

El AAB listado pertenece a una compilación anterior a la versión declarada actual. Antes de subir una versión nueva a Google Play debe generarse otro AAB con la versión y el build definitivos.

### Windows

- artifacts\windows\Release\lithica_geotech.exe
- Bibliotecas Flutter, Firebase y plugins necesarios.
- Carpeta data con recursos, motor Dart compilado, fuentes y configuración.

El ejecutable de Windows debe distribuirse junto con todo el contenido de artifacts\windows\Release, no como archivo aislado.

## Identidad visual

- assets\branding\logo.png: fuente transparente y foreground del icono adaptable Android.
- assets\branding\logo.jpg: variante con fondo blanco para iconos y empaquetado.
- assets\branding\logo_complete.png: marca completa usada en la pantalla inicial.
- Android usa un icono adaptable con fondo blanco para evitar esquinas negras.
- Windows usa windows\runner\resources\app_icon.ico.
- El nombre visible en Android se toma de app_name y es Lithica GeoTech.

## Pruebas existentes

- test\geotech_calculations_test.dart valida Q, Qc, ESR, RMR14, RMR76, Hoek-Brown y la transformación de esfuerzos.
- test\offline_access_policy_test.dart valida los siete días offline, la identidad coincidente y la protección contra alteraciones del reloj.
- test\widget_test.dart valida la aplicación, áreas seguras, modo experto, actualización del ESR y desplazamiento adaptable vertical u horizontal.

## Directorios generados o no publicables

- .dart_tool: estado local de Dart y Flutter.
- build: resultados intermedios.
- local_secrets: credenciales privadas.
- android\key.properties: contraseñas y ruta de firma.
- android\lithica-geotech-upload.jks: clave privada de carga.
- D:\Lithica_Temp\LithicaGeoTech: workspace y cachés temporales externos al proyecto.

## Archivos operativos principales

- pubspec.yaml: versión, dependencias, recursos e iconos.
- pubspec.lock: versiones resueltas de dependencias.
- ABRIR_LITHICA_GEOTECH.bat: actualizar y abrir Windows.
- BUILD_APK.bat: empaquetar APK.
- BUILD_AAB.bat: empaquetar AAB.
- build-windows.bat: empaquetar Windows.
- LITHICA_ENV.bat: entorno portable y workspace temporal.
- LITHICA_VERSION.bat: captura y valida versión y build.
- LITHICA_GOOGLE_OAUTH.bat: carga segura de OAuth de escritorio.
- firestore.rules: política de acceso a allowed_users.
- firebase.json: vínculo de despliegue de reglas.
- launcher_icons_android.yaml: configuración del icono Android.

## Regla de mantenimiento

Este documento describe el estado funcional y estructural del proyecto. Debe actualizarse cuando cambie alguna de estas áreas:

- Plataformas soportadas.
- Identificador o nombre del producto.
- Métodos geotécnicos.
- Flujo de autenticación o periodo offline.
- Estructura de Firestore.
- Scripts y rutas de empaquetado.
- Versionado o ubicación de artefactos.
- Archivos sensibles necesarios para compilar.

Los cambios puntuales y cronológicos deben registrarse en un historial separado; este archivo debe conservarse como fotografía vigente del proyecto.

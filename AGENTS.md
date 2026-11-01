# Instrucciones de trabajo

Antes de trabajar en este repositorio, lee y aplica las [instrucciones compartidas de Lithica](../AGENTS.md), situadas en LithicaRepos/AGENTS.md. Conserva también las instrucciones específicas de este archivo y de los AGENTS.md de sus subcarpetas. Si el archivo compartido no está disponible, informa de ello y no inventes su contenido ni crees una copia independiente que pueda quedar desactualizada.

## Instrucciones locales conservadas

Antes de tareas que requieran muchos tokens, avisa y usa consultas directas y acotadas.
Usa D:\DevResources como raiz local cuando exista y sea adecuada; verifica unidades fisicas, espacio y destinos en cada PC. Si no es valida, pide elegir una raiz antes de migrar.
Reutiliza SDK y dependencias existentes. Comparte caches compatibles mediante Shared, separa estado mutable por proyecto y copia de trabajo, y crea temporales unicos por ejecucion en Sessions.
Configura TEMP y TMP solamente en la sesion y sus procesos hijos. Conserva ajustes particulares de esta PC en configuracion local, sin trasladarlos innecesariamente a configuraciones compartidas.
Usa los lanzadores y bloqueos existentes. Maximo dos compilaciones pesadas simultaneas y exclusion para escrituras sobre el mismo workspace. No cierres programas ni detengas procesos ajenos.
En esta PC los lanzadores BAT integrados usan .devresources.local.cmd, configuracion local ignorada por Git. Para comandos directos usa DEVRESOURCES_RUN.cmd; verifica DEVRESOURCES_SESSION antes de ejecutar herramientas fuera de los lanzadores.
Antes de modificar recursos revisa instrucciones, remotos, ramas y cambios locales. Actualiza solo mediante pull con avance rapido; no uses reset, cambios de rama, descartes ni limpieza destructiva. Informa divergencias y continua con otros repositorios.
Corrige y comprueba rutas y lanzadores antes de consolidar duplicados. Conserva codigo, datos, autenticacion, claves, recursos necesarios y enlaces de compatibilidad. No dupliques recursos en C: ni en otros discos. No modifiques DriveFS, datos ni sincronizacion de Google Drive.
Antes de CUALQUIER eliminacion informa al usuario y espera su autorizacion. Solo considera caches o temporales regenerables e inactivos, despues de verificar referencias, copias y destinos fisicos. No ejecutes limpieza automatica durante esta auditoria.
No generes APK/AAB salvo solicitud expresa. No afirmes haber verificado compilaciones que no ejecutaste. Los informes Markdown o Word no deben usar backticks.

Antes de cambiar recursos comprueba unidades, instrucciones, remotos, ramas y cambios locales. Actualiza mediante pull con avance rapido y conserva cambios; informa divergencias sin reset ni cambio de rama.
Usa la raiz local D:\DevResources cuando sea valida; si no lo es, solicita elegir otra raiz. Reutiliza SDK y caches compatibles en Shared, separa estado mutable por proyecto y usa Sessions unicas por ejecucion.
Usa DEVRESOURCES_RUN.cmd para comandos de desarrollo; las configuraciones .devresources son locales y no deben subirse. TEMP y TMP se cambian solo para la sesion y sus hijos. Coordina bloqueos por workspace y maximo dos compilaciones pesadas.
No detengas procesos ajenos. No modifiques DriveFS, datos ni sincronizacion de Google Drive. Conserva codigo, datos, autenticacion, claves y enlaces de compatibilidad.
Comprueba rutas y lanzadores antes de consolidar. Antes de cualquier eliminacion presenta candidatos y espera autorizacion expresa; verifica referencias, copias, destinos fisicos e inactividad. No ejecutes limpiezas automaticas durante esta auditoria.
No afirmes compilaciones que no ejecutaste. Los informes Markdown y Word no deben contener backticks.

## Rutas según el equipo

Las referencias a E: corresponden a la laptop. En esta PC, el código y los scripts auxiliares permanecen en O:\0. Projects; se reutilizan los clones existentes. D:\DevResources se reserva para recursos, cachés, temporales de herramientas e informes. Verifica la raíz real antes de operar y conserva todas las instrucciones anteriores.

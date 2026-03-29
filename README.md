# EA4 - Proyecto integrador - Repositorio de todas las actividades

## Estudiante
Pablo Emilio Gómez Gómez

## Curso
Bases de Datos II

## Programa
Ingeniería en Software y Datos

## Institución
Institución Universitaria Digital de Antioquia

## Descripción general
Este repositorio integra los archivos, scripts, diagramas, evidencias y pruebas desarrolladas en el proyecto académico sobre la base de datos Jardinería. El trabajo incluye la construcción de la base transaccional, el modelo estrella para el data mart de ventas, consultas analíticas, validaciones estructurales y pruebas de calidad de datos sobre el sistema fuente y sobre el modelo dimensional.

## Estructura del repositorio

### 01_Documentacion
Contendrá documentos de soporte académico y descriptivo del proyecto.

### 02_Scripts_SQL
Incluye scripts de creación de base de datos, modelo estrella, verificaciones y consultas analíticas.

### 03_Diagramas
Incluye diagramas del modelo estrella en formato Markdown con Mermaid.

### 04_Pruebas_Calidad_Datos
Contiene los scripts de pruebas de calidad de datos y los resultados generados desde la terminal.

### 05_Evidencias_Git
Se usará para almacenar capturas o soportes del proceso de inicialización, agregado y confirmación de cambios en Git.

### 06_Entrega_Final
Contendrá el PDF final solicitado por el docente.

## Scripts principales incluidos
- 01_base_jardineria.sql
- 02_modelo_estrella_jardineria.sql
- 03_verificacion_jardineria.sql
- 04_verificacion_datos_jardineria.sql
- 05_verificacion_modelo_estrella_jardineria.sql
- 06_consultas_analiticas_jardineria.sql
- 09_consultas_filtros_libres_jardineria.sql
- 10_pruebas_calidad_datos_jardineria.sql
- 11_pruebas_calidad_modelo_estrella.sql

## Hallazgos relevantes de calidad de datos
En la base transaccional se identificaron registros duplicados de clientes, pedidos con fechas inconsistentes y pedidos entregados sin fecha de entrega. En contraste, el modelo estrella presentó consistencia estructural y ausencia de errores críticos en la tabla de hechos y dimensiones evaluadas.

## Objetivo del repositorio
Unificar y organizar de forma clara todos los productos desarrollados en las evidencias del curso, de modo que puedan ser consultados, ejecutados y evaluados fácilmente.

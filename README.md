# 🏠 Sistema Experto de Recomendación de Viviendas

> Motor de inferencia basado en reglas desarrollado con **CLIPS 6.3x** para la asignatura de Inteligencia Artificial (IA) — Grado en Ingeniería Informática.

*Read this in other languages: [English](#-real-estate-recommender-expert-system-english)*

---

## 📋 Descripción General

Este proyecto implementa un **sistema experto de recomendación inmobiliaria** que, dado un perfil de solicitante (restricciones obligatorias, preferencias de servicios y características personales), evalúa una base de conocimiento de viviendas y las clasifica y ordena automáticamente según su grado de adecuación.

El sistema entrevista al usuario a través de un diálogo interactivo, abstrae los datos en categorías simbólicas, aplica un conjunto de reglas heurísticas y emite una recomendación final con etiquetas cualitativas (`Muy_Recomendable`, `Adecuado`, `Parcialmente_Adecuado`), detallando los requisitos no cumplidos y las ventajas extra de cada vivienda.

El catálogo de viviendas evaluado incluye **100 instancias** de tipo `Vivienda`, `ViviendaVertical` y `Duplex`, junto con un mapa de **servicios urbanos** distribuidos espacialmente (hospitales, zonas verdes, transporte público, centros educativos, etc.).

---

## 🎯 Objetivos y Competencias Aplicadas

| Competencia | Descripción |
|---|---|
| **Representación del conocimiento** | Modelado de dominio mediante clases CLIPS (`defclass`) con jerarquías de herencia (`Vivienda → ViviendaVertical → Duplex`) |
| **Ontología formal** | Diseño y exportación de ontología OWL/Turtle (`mi-ontologia.ttl`) que formaliza las clases y propiedades del dominio |
| **Programación declarativa basada en reglas** | Más de 50 reglas `defrule` organizadas por módulos con control de prioridad mediante `salience` |
| **Arquitectura modular** | Pipeline de 5 módulos encadenados con `focus` y visibilidad controlada con `import/export` |
| **Abstracción de datos** | Transformación de valores numéricos a categorías simbólicas (ej. precio → bajo/medio/alto) |
| **Razonamiento heurístico** | Asociación de fallos y ventajas sobre cada vivienda para clasificarla cualitativamente |
| **Refinamiento y ordenación** | Priorización de resultados usando `salience` negativo y plantillas `deftemplate` |
| **Generación de datos de prueba** | Scripts Python para generar instancias CLIPS sintéticas de forma paramétrica |
| **Validación experimental** | Batería de 7 jocs de proves (casos de prueba) con salidas documentadas |

---

## 🏗️ Arquitectura y Estructura de Archivos

El proyecto sigue una arquitectura de **pipeline de 5 módulos** secuenciales con control de flujo explícito:

```
IA_Practica2/
│
├── 📂 src/                          # Código fuente principal
│   ├── 1_input.clp                  # MÓDULO 1 — Clases, funciones de entrada y diálogo interactivo
│   ├── 2_abstraccion.clp            # MÓDULO 2 — Categorización simbólica de atributos numéricos
│   ├── 3_heuristicas.clp            # MÓDULO 3 — Motor de asociaciones heurísticas y clasificación
│   ├── 4_refinamiento.clp           # MÓDULO 4 — Ordenación de resultados por prioridad
│   ├── 5_salida.clp                 # MÓDULO 5 — Presentación formateada de resultados
│   ├── 6_main.clp                   # Control de flujo: encadena los 5 módulos con focus
│   ├── instancias.clp               # Base de conocimiento: 100 viviendas + servicios urbanos
│   ├── mi-ontologia.ttl             # Ontología OWL/Turtle del dominio (Protégé)
│   ├── prototipo1.clp               # Prototipo MVP inicial (sistema de puntuación numérica)
│   ├── prototipo3.clp               # Prototipo 3 previo a la versión final
│   └── comandosParaEjecutar.txt     # Secuencia de comandos CLIPS para cargar y ejecutar
│
├── 📂 scripts/                      # Herramientas de apoyo en Python
│   ├── generadorViviendas.py        # Generador aleatorio de instancias Vivienda/ViviendaVertical/Duplex
│   ├── generadorServicios.py        # Generador aleatorio de instancias Servicio (hospitales, ocio, etc.)
│   └── porcentajes.py               # Analizador de resultados: calcula % de viviendas por categoría
│
├── 📂 docs/                         # Documentación del proyecto
│   ├── enunciado/
│   │   └── PracticaSBC.pdf          # Enunciado oficial de la práctica
│   └── informe/
│       └── Informe.pdf              # Informe técnico de la práctica entregado
│
├── 📂 jocsDeProbes/                 # Casos de prueba con diálogos y salidas registradas
│   ├── jocProbes1/sortida.txt       # Prueba 1: Pareja sin hijos, piso alto, muchas restricciones
│   ├── jocProbes2/sortida.txt       # Prueba 2: Segundo escenario de validación
│   ├── jocProbes4/sortida.txt       # Prueba 4: Perfil con restricciones mínimas
│   ├── jocProbes5/sortida.txt       # Prueba 5: Solicitante joven / estudiante
│   ├── jocProbes6/sortida.txt       # Prueba 6: Solicitante con movilidad reducida
│   └── jocProbes9/                  # Prueba 9: Caso sin viviendas válidas (fallback)
│       ├── DialogWindow.txt         # Diálogo completo del usuario registrado
│       └── fallback.txt             # Salida del sistema cuando no hay viviendas adecuadas
│
└── README.md                        # Este archivo
```

### Diagrama del pipeline de inferencia

```
  [Usuario]
      │
      ▼
┌─────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  MÓDULO 1   │───▶│    MÓDULO 2      │───▶│     MÓDULO 3        │
│   INPUT     │    │  ABSTRACCIÓN     │    │   HEURÍSTICAS       │
│             │    │                  │    │                     │
│ • Diálogo   │    │ • precio → cat.  │    │ • Evalúa requisitos │
│ • Restricc. │    │ • tamano → cat.  │    │ • Detecta ventajas  │
│ • Prefernc. │    │ • edad → cat.    │    │ • Reglas por perfil │
│ • Distancias│    │ • booleans → Abs │    │ • Clasifica etiqueta│
└─────────────┘    └──────────────────┘    └─────────────────────┘
                                                      │
                                                      ▼
                                           ┌─────────────────────┐
                                           │     MÓDULO 4        │
                                           │   REFINAMIENTO      │
                                           │                     │
                                           │ • Ordena por extras │
                                           │ • Gestiona prioridad│
                                           └─────────────────────┘
                                                      │
                                                      ▼
                                           ┌─────────────────────┐
                                           │     MÓDULO 5        │
                                           │      SALIDA         │
                                           │                     │
                                           │ • Lista ordenada    │
                                           │ • Fallos / Ventajas │
                                           │ • Resumen global    │
                                           └─────────────────────┘
```

---

## ⚙️ Tecnologías y Herramientas

| Herramienta | Versión | Uso |
|---|---|---|
| **CLIPS** | 6.30 / 6.31 | Motor de inferencia basado en reglas (lenguaje principal) |
| **Python** | 3.x | Scripts auxiliares de generación y análisis de datos |
| **Faker** (Python lib) | latest | Generación de datos aleatorios para instancias |
| **OWL / Turtle (TTL)** | OWL 2 | Formalización ontológica del dominio |
| **Protégé** | 5.x | Editor visual de ontologías OWL |
| **Git** | — | Control de versiones |

---

## 🚀 Requisitos e Instalación

### Prerrequisitos

- **CLIPS 6.30+** — [Descargar desde clipsrules.net](https://www.clipsrules.net/)
- **Python 3.x** (solo para los scripts auxiliares)
- Librería Python `faker`: `pip install faker`

### Pasos para ejecutar el sistema

**1. Clonar el repositorio:**
```bash
git clone https://github.com/ishaaaakkk/IA_Practica2.git
cd IA_Practica2
```

**2. Abrir CLIPS** (interfaz gráfica o línea de comandos):
```bash
clips
```

**3. Cargar todos los módulos en orden** (copiar y pegar en la consola CLIPS):
```clips
(load "src/1_input.clp")
(load "src/instancias.clp")
(load "src/2_abstraccion.clp")
(load "src/3_heuristicas.clp")
(load "src/4_refinamiento.clp")
(load "src/5_salida.clp")
(load "src/6_main.clp")
(reset)
(run)
```

> 💡 También puedes copiar directamente el contenido de `src/comandosParaEjecutar.txt` y ejecutarlo en la consola de CLIPS.

**4. Responder el diálogo interactivo** — El sistema realizará preguntas sobre:
- Edad y tipo de solicitante
- Tipo de vivienda deseada (casa / piso) y altura preferida
- Presupuesto máximo mensual
- Restricciones obligatorias (ascensor, mascotas, amueblado, etc.)
- Preferencias de proximidad a servicios urbanos

### Generar nuevas instancias (opcional)

```bash
# Generar 100 viviendas aleatorias en formato CLIPS
python3 scripts/generadorViviendas.py > src/instancias_nuevas.clp

# Generar servicios urbanos aleatorios
python3 scripts/generadorServicios.py >> src/instancias_nuevas.clp

# Analizar distribución de resultados de un caso de prueba
python3 scripts/porcentajes.py
# (requiere un fichero sortida.txt en el directorio de trabajo)
```

---

## ✨ Características Principales

### Sistema de clasificación de viviendas
- **Tres etiquetas de recomendación**: `Muy_Recomendable`, `Adecuado` y `Parcialmente_Adecuado`, asignadas mediante reglas declarativas con control de prioridad (`salience`).
- **Fallback inteligente**: Si ninguna vivienda cumple los criterios mínimos, el sistema lo comunica explícitamente.

### Jerarquía de clases OOP en CLIPS
- Clase base `Vivienda` con 20+ atributos.
- Subclase `ViviendaVertical` (añade `planta`, `atico`).
- Subclase `Duplex` (añade `numPlantas`).
- Clase `Solicitante` con preferencias y restricciones dinámicas.
- Clase `Servicio` con coordenadas geoespaciales.

### Abstracción simbólica automática
- Precio (€/mes) → `bajo` / `medio` / `alto`
- Número de habitaciones → `pequeño` / `medio` / `grande`
- Superficie (m²) → `pequeña` / `mediana` / `grande`
- Año de edificación → `reciente` / `moderna` / `antigua`
- Planta → `baja` / `media` / `alta`

### Motor de heurísticas con reglas específicas por perfil
- Reglas extra para **ancianos** (ventaja si hay hospital cercano).
- Reglas extra para **jóvenes** (ventaja si hay ocio nocturno o centro urbano cerca).
- Reglas extra para **estudiantes** (ventaja si hay centro educativo o transporte público cerca).
- Reglas extra para **parejas con hijos** (ventaja si hay colegio o zona verde a distancia media).
- Reglas extra para **personas con movilidad reducida** (ventaja si hay ascensor, aunque no lo hayan pedido).
- Reglas extra para **solicitantes sin coche** (ventaja si hay transporte público cerca).

### Cálculo de distancia geoespacial
- Distancia euclidiana entre vivienda y servicio para clasificar cada servicio como `cerca` (< 500 u.), `media` (500–1000 u.) o `lejos` (> 1000 u.).

### Ordenación inteligente de resultados
- Las viviendas `Muy_Recomendable` se ordenan por número de ventajas extra (de mayor a menor).
- Las viviendas `Adecuado` solo aparecen si no existen `Muy_Recomendable`.
- Las viviendas `Parcialmente_Adecuado` solo aparecen si no hay opciones mejores, ordenadas por número de fallos (de menor a mayor).

### Trazabilidad completa de decisiones
- El sistema muestra por cada vivienda recomendada: su ID, grado de recomendación, lista de **requisitos NO cumplidos** y lista de **ventajas extra** detectadas.
- Al final, imprime un **resumen global** de todos los fallos por vivienda para facilitar la depuración.

### Batería de casos de prueba
- 7 escenarios de validación documentados en `jocsDeProbes/`, cubriendo perfiles como: pareja sin hijos, estudiante, persona con movilidad reducida, solicitante sin restricciones y caso sin viviendas válidas.

### Scripts de utilidad Python
- **`generadorViviendas.py`**: genera N instancias CLIPS de tipo `Vivienda`, `ViviendaVertical` o `Duplex` con atributos aleatorios realistas.
- **`generadorServicios.py`**: genera instancias de servicios urbanos distribuidos en un mapa de 2000×2000 unidades.
- **`porcentajes.py`**: parsea la salida del sistema y calcula el porcentaje de viviendas clasificadas en cada categoría.

---

## 📂 Referencia Rápida de Archivos

| Archivo | Descripción | Ubicación |
|---|---|---|
| `1_input.clp` | Módulo de entrada: clases, funciones y diálogo | `src/` |
| `2_abstraccion.clp` | Módulo de abstracción: categorización simbólica | `src/` |
| `3_heuristicas.clp` | Motor heurístico: 30+ reglas de evaluación | `src/` |
| `4_refinamiento.clp` | Módulo de ordenación de resultados | `src/` |
| `5_salida.clp` | Módulo de presentación de resultados | `src/` |
| `6_main.clp` | Punto de entrada: encadena los 5 módulos | `src/` |
| `instancias.clp` | 100 viviendas + servicios urbanos | `src/` |
| `mi-ontologia.ttl` | Ontología OWL formal del dominio | `src/` |
| `prototipo1.clp` | MVP inicial con puntuación numérica | `src/` |
| `prototipo3.clp` | Versión intermedia previa al sistema final | `src/` |
| `comandosParaEjecutar.txt` | Secuencia de carga para CLIPS | `src/` |
| `generadorViviendas.py` | Generador sintético de viviendas | `scripts/` |
| `generadorServicios.py` | Generador sintético de servicios | `scripts/` |
| `porcentajes.py` | Análisis estadístico de resultados | `scripts/` |
| `PracticaSBC.pdf` | Enunciado oficial de la práctica | `docs/enunciado/` |
| `Informe.pdf` | Informe técnico entregado | `docs/informe/` |
| `jocProbesN/sortida.txt` | Salidas de los casos de prueba (N=1,2,4,5,6,9) | `jocsDeProbes/` |

---

## 👥 Autores

Desarrollado por **Ishak Felfoul** y **Eduard Corrons** como práctica académica para la asignatura **Inteligencia Artificial (IA)** del Grado en Ingeniería Informática.

---

# 🏠 Real Estate Recommender Expert System (English)

> Rule-based inference engine developed with **CLIPS 6.3x** for the Artificial Intelligence (AI) course — Bachelor's Degree in Computer Engineering.

*Leer en otros idiomas: [Español](#-sistema-experto-de-recomendación-de-viviendas)*

---

## 📋 General Overview

This project implements a **real estate recommender expert system** that, given an applicant's profile (mandatory restrictions, service preferences, and personal characteristics), evaluates a knowledge base of properties and automatically classifies and sorts them based on their suitability.

The system interviews the user through an interactive dialog, abstracts data into symbolic categories, applies a set of heuristic rules, and issues a final recommendation with qualitative labels (`Highly_Recommended`, `Suitable`, `Partially_Suitable`), detailing unfulfilled requirements and extra advantages of each property.

The evaluated property catalog includes **100 instances** of types `Vivienda` (Property), `ViviendaVertical` (Apartment), and `Duplex`, along with a map of spatially distributed **urban services** (hospitals, green areas, public transport, educational centers, etc.).

---

## 🎯 Objectives and Applied Skills

| Skill | Description |
|---|---|
| **Knowledge representation** | Domain modeling using CLIPS classes (`defclass`) with inheritance hierarchies (`Vivienda → ViviendaVertical → Duplex`) |
| **Formal ontology** | Design and export of OWL/Turtle ontology (`mi-ontologia.ttl`) formalizing domain classes and properties |
| **Declarative rule-based programming** | Over 50 `defrule` rules organized by modules with priority control via `salience` |
| **Modular architecture** | 5-module pipeline chained with `focus` and visibility controlled via `import/export` |
| **Data abstraction** | Transformation of numerical values to symbolic categories (e.g., price → low/medium/high) |
| **Heuristic reasoning** | Association of flaws and advantages to each property for qualitative classification |
| **Refinement and sorting** | Prioritization of results using negative `salience` and `deftemplate` templates |
| **Test data generation** | Python scripts to generate synthetic CLIPS instances parametrically |
| **Experimental validation** | Suite of 7 test cases (`jocs de proves`) with documented outputs |

---

## 🏗️ Architecture and File Structure

The project follows a sequential **5-module pipeline** architecture with explicit flow control:

```text
IA_Practica2/
│
├── 📂 src/                          # Main source code
│   ├── 1_input.clp                  # MODULE 1 — Classes, input functions and interactive dialog
│   ├── 2_abstraccion.clp            # MODULE 2 — Symbolic categorization of numeric attributes
│   ├── 3_heuristicas.clp            # MODULE 3 — Heuristic associations and classification engine
│   ├── 4_refinamiento.clp           # MODULE 4 — Sorting results by priority
│   ├── 5_salida.clp                 # MODULE 5 — Formatted presentation of results
│   ├── 6_main.clp                   # Flow control: chains the 5 modules with focus
│   ├── instancias.clp               # Knowledge base: 100 properties + urban services
│   ├── mi-ontologia.ttl             # OWL/Turtle domain ontology (Protégé)
│   ├── prototipo1.clp               # Initial MVP prototype (numeric scoring system)
│   ├── prototipo3.clp               # Prototype 3 prior to final version
│   └── comandosParaEjecutar.txt     # CLIPS commands sequence to load and execute
│
├── 📂 scripts/                      # Python support tools
│   ├── generadorViviendas.py        # Random instance generator (Vivienda/ViviendaVertical/Duplex)
│   ├── generadorServicios.py        # Random instance generator for services (hospitals, leisure, etc.)
│   └── porcentajes.py               # Results analyzer: calculates % of properties by category
│
├── 📂 docs/                         # Project documentation
│   ├── enunciado/
│   │   └── PracticaSBC.pdf          # Official assignment statement
│   └── informe/
│       └── Informe.pdf              # Submitted technical report
│
├── 📂 jocsDeProbes/                 # Test cases with logged dialogs and outputs
│   ├── jocProbes1/sortida.txt       # Test 1: Couple without children, high floor, many restrictions
│   ├── jocProbes2/sortida.txt       # Test 2: Second validation scenario
│   ├── jocProbes4/sortida.txt       # Test 4: Profile with minimal restrictions
│   ├── jocProbes5/sortida.txt       # Test 5: Young applicant / student
│   ├── jocProbes6/sortida.txt       # Test 6: Applicant with reduced mobility
│   └── jocProbes9/                  # Test 9: Case with no valid properties (fallback)
│       ├── DialogWindow.txt         # Full logged user dialog
│       └── fallback.txt             # System output when no suitable properties exist
│
└── README.md                        # This file
```

### Inference Pipeline Diagram

```text
  [User]
      │
      ▼
┌─────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  MODULE 1   │───▶│    MODULE 2      │───▶│     MODULE 3        │
│   INPUT     │    │   ABSTRACTION    │    │    HEURISTICS       │
│             │    │                  │    │                     │
│ • Dialog    │    │ • price → cat.   │    │ • Evals reqs.       │
│ • Restricts │    │ • size → cat.    │    │ • Detects perks     │
│ • Prefs.    │    │ • age → cat.     │    │ • Rules by profile  │
│ • Distances │    │ • booleans → Abs │    │ • Labels category   │
└─────────────┘    └──────────────────┘    └─────────────────────┘
                                                      │
                                                      ▼
                                           ┌─────────────────────┐
                                           │     MODULE 4        │
                                           │    REFINEMENT       │
                                           │                     │
                                           │ • Sorts by perks    │
                                           │ • Manages priority  │
                                           └─────────────────────┘
                                                      │
                                                      ▼
                                           ┌─────────────────────┐
                                           │     MODULE 5        │
                                           │      OUTPUT         │
                                           │                     │
                                           │ • Ordered list      │
                                           │ • Flaws / Perks     │
                                           │ • Global summary    │
                                           └─────────────────────┘
```

---

## ⚙️ Technologies and Tools

| Tool | Version | Usage |
|---|---|---|
| **CLIPS** | 6.30 / 6.31 | Rule-based inference engine (main language) |
| **Python** | 3.x | Auxiliary scripts for data generation and analysis |
| **Faker** (Python lib) | latest | Random data generation for instances |
| **OWL / Turtle (TTL)** | OWL 2 | Formal domain ontology |
| **Protégé** | 5.x | Visual OWL ontology editor |
| **Git** | — | Version control |

---

## 🚀 Requirements and Installation

### Prerequisites

- **CLIPS 6.30+** — [Download from clipsrules.net](https://www.clipsrules.net/)
- **Python 3.x** (only for auxiliary scripts)
- Python library `faker`: `pip install faker`

### Steps to run the system

**1. Clone the repository:**
```bash
git clone https://github.com/ishaaaakkk/IA_Practica2.git
cd IA_Practica2
```

**2. Open CLIPS** (GUI or command line):
```bash
clips
```

**3. Load all modules in order** (copy and paste into CLIPS console):
```clips
(load "src/1_input.clp")
(load "src/instancias.clp")
(load "src/2_abstraccion.clp")
(load "src/3_heuristicas.clp")
(load "src/4_refinamiento.clp")
(load "src/5_salida.clp")
(load "src/6_main.clp")
(reset)
(run)
```

> 💡 You can also directly copy the contents of `src/comandosParaEjecutar.txt` and run it in the CLIPS console.

**4. Answer the interactive dialog** — The system will ask questions about:
- Age and type of applicant
- Desired property type (house / apartment) and preferred floor
- Maximum monthly budget
- Mandatory restrictions (elevator, pets, furnished, etc.)
- Proximity preferences to urban services

### Generate new instances (optional)

```bash
# Generate 100 random properties in CLIPS format
python3 scripts/generadorViviendas.py > src/instancias_nuevas.clp

# Generate random urban services
python3 scripts/generadorServicios.py >> src/instancias_nuevas.clp

# Analyze result distribution of a test case
python3 scripts/porcentajes.py
# (requires a sortida.txt file in the working directory)
```

---

## ✨ Main Features

### Property Classification System
- **Three recommendation labels**: `Highly_Recommended`, `Suitable`, and `Partially_Suitable`, assigned via declarative rules with priority control (`salience`).
- **Smart fallback**: If no property meets the minimum criteria, the system communicates this explicitly.

### OOP Class Hierarchy in CLIPS
- Base class `Vivienda` with 20+ attributes.
- Subclass `ViviendaVertical` (adds `planta`, `atico`).
- Subclass `Duplex` (adds `numPlantas`).
- Class `Solicitante` with dynamic preferences and restrictions.
- Class `Servicio` with geospatial coordinates.

### Automatic Symbolic Abstraction
- Price (€/month) → `low` / `medium` / `high`
- Number of rooms → `small` / `medium` / `large`
- Area (m²) → `small` / `medium` / `large`
- Construction year → `recent` / `modern` / `old`
- Floor → `low` / `medium` / `high`

### Heuristics Engine with Profile-Specific Rules
- Extra rules for **elderly people** (perk if there's a nearby hospital).
- Extra rules for **young people** (perk if there's nearby nightlife or urban center).
- Extra rules for **students** (perk if there's a nearby educational center or public transport).
- Extra rules for **couples with children** (perk if there's a school or green area at a medium distance).
- Extra rules for **people with reduced mobility** (perk if there's an elevator, even if not explicitly requested).
- Extra rules for **applicants without a car** (perk if there's public transport nearby).

### Geospatial Distance Calculation
- Euclidean distance between property and service to classify each service as `close` (< 500 u.), `medium` (500–1000 u.), or `far` (> 1000 u.).

### Intelligent Result Sorting
- `Highly_Recommended` properties are sorted by the number of extra perks (descending).
- `Suitable` properties only appear if there are no `Highly_Recommended` ones.
- `Partially_Suitable` properties only appear if there are no better options, sorted by the number of flaws (ascending).

### Full Decision Traceability
- The system shows for each recommended property: its ID, recommendation degree, list of **UNFULFILLED requirements**, and list of detected **extra perks**.
- At the end, it prints a **global summary** of all flaws per property to facilitate debugging.

### Test Case Suite
- 7 validation scenarios documented in `jocsDeProbes/`, covering profiles like: couple without children, student, person with reduced mobility, applicant with no restrictions, and a case with no valid properties.

### Python Utility Scripts
- **`generadorViviendas.py`**: generates N CLIPS instances of type `Vivienda`, `ViviendaVertical`, or `Duplex` with realistic random attributes.
- **`generadorServicios.py`**: generates urban service instances distributed on a 2000×2000 unit map.
- **`porcentajes.py`**: parses system output and calculates the percentage of properties classified in each category.

---

## 📂 Quick File Reference

| File | Description | Location |
|---|---|---|
| `1_input.clp` | Input module: classes, functions, and dialog | `src/` |
| `2_abstraccion.clp` | Abstraction module: symbolic categorization | `src/` |
| `3_heuristicas.clp` | Heuristic engine: 30+ evaluation rules | `src/` |
| `4_refinamiento.clp` | Results sorting module | `src/` |
| `5_salida.clp` | Results presentation module | `src/` |
| `6_main.clp` | Entry point: chains the 5 modules | `src/` |
| `instancias.clp` | 100 properties + urban services | `src/` |
| `mi-ontologia.ttl` | Formal OWL domain ontology | `src/` |
| `prototipo1.clp` | Initial MVP with numerical scoring | `src/` |
| `prototipo3.clp` | Intermediate version prior to final system | `src/` |
| `comandosParaEjecutar.txt` | Load sequence for CLIPS | `src/` |
| `generadorViviendas.py` | Synthetic property generator | `scripts/` |
| `generadorServicios.py` | Synthetic service generator | `scripts/` |
| `porcentajes.py` | Statistical analysis of results | `scripts/` |
| `PracticaSBC.pdf` | Official assignment statement | `docs/enunciado/` |
| `Informe.pdf` | Submitted technical report | `docs/informe/` |
| `jocProbesN/sortida.txt` | Outputs of test cases (N=1,2,4,5,6,9) | `jocsDeProbes/` |

---

## 👥 Authors

Developed by **Ishak Felfoul** y **Eduard Corrons** as an academic project for the **Artificial Intelligence (AI)** course of the Bachelor's Degree in Computer Engineering.

---

<p align="center">
  <img src="https://img.shields.io/badge/CLIPS-6.3x-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Python-3.x-yellow?style=flat-square&logo=python" />
  <img src="https://img.shields.io/badge/OWL-Ontología-green?style=flat-square" />
  <img src="https://img.shields.io/badge/IA-Sistema_Experto-red?style=flat-square" />
  <img src="https://img.shields.io/badge/Estado-Completado-brightgreen?style=flat-square" />
</p>
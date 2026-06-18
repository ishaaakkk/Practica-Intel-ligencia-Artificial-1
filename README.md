# 🏠 Sistema Experto de Recomendación de Viviendas

> Motor de inferencia basado en reglas desarrollado con **CLIPS 6.3x** para la asignatura de Inteligencia Artificial (IA) — Grado en Ingeniería Informática.

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

<p align="center">
  <img src="https://img.shields.io/badge/CLIPS-6.3x-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Python-3.x-yellow?style=flat-square&logo=python" />
  <img src="https://img.shields.io/badge/OWL-Ontología-green?style=flat-square" />
  <img src="https://img.shields.io/badge/IA-Sistema_Experto-red?style=flat-square" />
  <img src="https://img.shields.io/badge/Estado-Completado-brightgreen?style=flat-square" />
</p>
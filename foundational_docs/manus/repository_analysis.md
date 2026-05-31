# Análisis de Repositorios de GitHub para AI Engineering

## 1. Sprintpilot

**Propósito:** Autopilot y addon multi-agente para el método BMad, automatizando sprints de desarrollo de software con un flujo de trabajo Git completo.

**Características Clave:**
*   **Automatización de Sprints:** Convierte planes de sprint en código revisado, probado y listo para PR de forma autónoma.
*   **Flujo de Trabajo Git Completo:** Creación de worktrees aislados, ramas, ejecución de pruebas (RED-GREEN TDD), linting, staging explícito, commits con mensajes convencionales, revisión paralela por tres revisores, aplicación automática de parches, push y creación de PRs.
*   **Orquestador de Máquina de Estados:** Un orquestador determinista (Node.js) que sigue el ciclo de 7 pasos de BMad, delegando la ejecución de habilidades y decisiones de juicio a los LLMs.
*   **Perfiles de Complejidad:** Permite ajustar el nivel de proceso (nano, small, medium, large, legacy) según la complejidad del sprint, incluyendo la capacidad de ejecución paralela de historias con Claude Code en perfiles `large`.
*   **Interacción en Lenguaje Natural:** El copiloto escanea el chat para interjecciones del usuario, permitiendo dirigir el proceso con comandos en lenguaje natural (ej. "skip this story", "pause").
*   **Recuperación de Sesión:** Checkpoints de estado cada N historias, informes de traspaso y reanudación exacta en una nueva sesión, con detección de divergencias y recuperación de fallos.
*   **Habilidades Multi-Agente:** Incluye habilidades como `sprintpilot-codebase-map` (análisis de código), `sprintpilot-assess` (auditoría de deuda técnica), `sprintpilot-reverse-architect` (extracción de arquitectura) y `sprintpilot-research` (investigación web paralela).
*   **Compatibilidad Multi-Herramienta:** Utiliza el formato `SKILL.md` universal, compatible con Claude Code, Cursor, Windsurf, Kiro, Gemini CLI, GitHub Copilot, Cline, Roo, Trae.
*   **Abstracción de Plataforma Git:** Auto-detección de plataformas Git (GitHub, GitLab, Bitbucket, Gitea) y CLI (gh, glab, bb, tea), con fallback a modo `git_only` si no hay CLI.
*   **Aislamiento de Worktree:** Cada historia se desarrolla en un worktree git aislado (`.worktrees/<story-key>/`) para mantener el trabajo separado de la rama principal.
*   **Enforcement del System Prompt:** Instala archivos de system prompt que hacen que cada sesión de agente AI sea consciente del método BMad desde el primer mensaje, con una arquitectura de tres archivos (`CLAUDE.md`, `AGENTS.md`, `_Sprintpilot/Sprintpilot.md`).

**Mejores Características para Integrar:**
*   **Automatización de Flujo de Trabajo Git:** La capacidad de gestionar automáticamente ramas, commits, PRs y revisiones es fundamental para cualquier proyecto de desarrollo AI.
*   **Perfiles de Complejidad y Escalabilidad:** La adaptabilidad a diferentes tamaños de proyecto y la capacidad de paralelizar tareas son muy valiosas.
*   **Habilidades Multi-Agente Predefinidas:** Las habilidades para análisis de código, auditoría, ingeniería inversa y investigación son directamente aplicables a la exploración y comprensión de nuevos proyectos.
*   **Manejo de Contexto y Recuperación de Sesión:** La persistencia del estado y la capacidad de reanudar sesiones son cruciales para la memoria de los agentes AI.
*   **Abstracción de Plataforma:** La compatibilidad con múltiples herramientas y plataformas Git facilita la integración en diversos entornos.

## 2. IAgentek Framework

**Propósito:** Un framework de desarrollo autónomo asistido por IA para equipos de ingeniería, que fusiona el **Desarrollo Dirigido por Especificaciones (SDD)** con el **Método BMAD** (agentes especializados con roles claros).

**Características Clave:**
*   **Orquestación de Equipos Virtuales de Agentes:** IAgentek orquesta un equipo virtual de agentes (Analista, PM, Arquitecto, Scrum Master, Desarrollador, QA, DevOps, Debugger, Arquitecto de Refactorización) que recorren un ciclo de desarrollo completo.
*   **Artefactos Dirigidos por Especificaciones:** Cada agente produce artefactos SDD (constitución, PRD, especificaciones, planes, tareas, historias) que se convierten en la fuente de verdad del proyecto. Se requiere aprobación humana en puntos de control clave.
*   **Modos de Ejecución:** Soporta `autonomous-with-checkpoints` (por defecto, se detiene en momentos críticos), `fully-autonomous` (de principio a fin sin detenerse) e `interactive` (pregunta en cada paso).
*   **4 Ciclos Completos de Desarrollo:** `greenfield` (producto desde cero), `brownfield` (en codebase existente), `bugfix` (respuesta a incidentes) y `refactor` (reducción de deuda técnica por etapas).
*   **Soporte Multi-Proveedor de IA:** Auto-detecta y soporta 6 proveedores de IA: `claude-cli`, `anthropic`, `openai`, `gemini`, `deepseek` y `ollama`.
*   **Agentes BMAD Especializados:** Nueve agentes con roles definidos para cubrir todo el ciclo de desarrollo.
*   **Generación de Artefactos de Proyecto:** Genera una estructura de proyecto con archivos como `.env`, `.gitignore`, `.iagentek/config.yaml`, `state.json`, `constitution.md`, `project-brief.md`, `PRD.md`, `architecture.md`, `sprint-plan.md`, `DoD.md`, `specs/`, `plans/`, `stories/`, `tasks/`, `qa/`, `deployment.md`, `incidents/`, `debt-audit.md`, `refactor-plans/` y `.transcripts/`.
*   **Fusión SDD + BMAD:** Los agentes BMAD son los ejecutores, y los artefactos SDD son el contrato. Cada agente lee artefactos previos y produce los suyos propios.
*   **Arquitectura Modular:** Monorepo con paquetes npm (`@iagentek/cli`, `@iagentek/core`, `@iagentek/method`) y un plugin complementario para Claude Code.
*   **Seguridad y Recuperación:** Implementa escrituras atómicas de `state.json`, recuperación de fallos, reutilización de transcripciones, validación de flujo, bloqueo de path traversal, neutralización de inyección de prompts, `.gitignore` seguro para brownfield, allowlist de `.env` y depuración de secretos en transcripciones.
*   **Salida Bilingüe:** Soporte para salida en inglés y español.

**Mejores Características para Integrar:**
*   **Orquestación de Agentes y Ciclos de Desarrollo:** La capacidad de guiar un proyecto a través de fases de desarrollo con agentes especializados es muy potente.
*   **Generación de Artefactos SDD:** La creación automática de documentación y especificaciones estructuradas es invaluable para la comprensión y el mantenimiento del proyecto.
*   **Soporte Multi-Proveedor de IA:** La flexibilidad para usar diferentes modelos de IA según la necesidad es una ventaja clave.
*   **Modos de Ejecución Adaptables:** La posibilidad de elegir entre ejecución autónoma, con checkpoints o interactiva permite un control granular.
*   **Mecanismos de Seguridad y Recuperación:** Las características de seguridad y la robustez en la recuperación de sesiones son esenciales para la fiabilidad del sistema.
## 3. Agent Smith CLI

**Propósito:** Transforma cualquier repositorio de GitHub en un ecosistema multi-agente totalmente autónomo para GitHub Copilot, generando una constelación de agentes especializados con habilidades, herramientas y delegación de tareas.

**Características Clave:**
*   **Constelaciones Multi-Agente:** Genera un orquestador raíz y sub-agentes de dominio con delegación `runSubagent`, creando un equipo completo de agentes en lugar de uno solo.
*   **Extracción de Habilidades:** Identifica patrones, convenciones y capacidades reutilizables, creando un `SKILL.md` para cada habilidad con metadatos, disparadores y ejemplos.
*   **Instrucciones para Copilot:** Genera automáticamente `.github/copilot-instructions.md` con información sobre el lenguaje, framework, arquitectura y convenciones de codificación del repositorio.
*   **Grafos de Delegación (Handoff Graphs):** Crea `handoffs.json` para que los agentes puedan delegar tareas entre sí basándose en disparadores de palabras clave.
*   **Pipeline Validado por Zod:** La salida del LLM se valida mediante esquemas Zod, lo que garantiza la calidad y evita la "alucinación" de JSON.
*   **Análisis Remoto:** Puede analizar cualquier repositorio público de GitHub sin necesidad de clonarlo, utilizando la API de GitHub y el SDK de Copilot.
*   **Cliente Asíncrono de GitHub:** Realiza llamadas a la API de forma no bloqueante, con lógica de reintento, manejo de límites de tasa y clases de error tipadas.
*   **Aplicación de Licencias:** Solo asimila repositorios con licencias permisivas de código abierto, detectándolas a partir de archivos `LICENSE`, `package.json` o `pyproject.toml`.
*   **Hooks de Ciclo de Vida:** Genera hooks `pre-commit`, `pre-push` y `post-generate` para automatizar la validación después de la generación.
*   **Registro Buscable:** Un índice JSONL con puntuación, filtrado por tipo y coincidencia basada en disparadores.
*   **Modo de Agente Único:** Para repositorios más simples, puede generar un único `.agent.md` con todas las habilidades y herramientas, sin sub-agentes ni delegaciones.

**Mejores Características para Integrar:**
*   **Generación Automática de Agentes Especializados:** La capacidad de crear un equipo de agentes adaptado a la estructura de un repositorio es excelente para la comprensión y el mantenimiento.
*   **Extracción de Habilidades y Contexto:** La creación de `SKILL.md` y `copilot-instructions.md` proporciona una base sólida de conocimiento para los agentes y para los ingenieros humanos.
*   **Grafos de Delegación:** La gestión de la comunicación y la delegación entre agentes es crucial para proyectos complejos.
*   **Validación de Salida del LLM:** La validación con Zod asegura que las respuestas de los agentes sean estructuradas y fiables.
*   **Análisis Remoto y Abstracción de Repositorio:** La capacidad de analizar repositorios sin clonarlos y la abstracción de la interacción con GitHub son muy útiles para la integración en flujos de trabajo existentes.
## 4. Context Mode

**Propósito:** Un servidor MCP que aborda el problema del contexto en las herramientas de IA, optimizando el uso de tokens, manteniendo la continuidad de la sesión y fomentando un enfoque de "pensar en código" para los LLMs.

**Características Clave:**
*   **Ahorro de Contexto:** Mantiene los datos brutos fuera de la ventana de contexto del LLM, logrando una reducción significativa en el uso de tokens (ej. 315 KB se convierten en 5.4 KB, una reducción del 98%).
*   **Continuidad de Sesión:** Rastrea cada edición de archivo, operación git, tarea, error y decisión del usuario en SQLite. Cuando la conversación se compacta, `context-mode` indexa los eventos en FTS5 y recupera solo lo relevante mediante búsqueda BM25, permitiendo que el modelo retome exactamente donde lo dejó.
*   **"Pensar en Código" para LLMs:** Promueve que el LLM programe el análisis en lugar de computarlo directamente. En lugar de leer muchos archivos, el agente escribe un script que realiza la tarea y solo imprime el resultado, ahorrando contexto.
*   **No Impone Estilo de Prosa:** Se enfoca en cómo se gestionan los datos, no en cómo el modelo formula sus respuestas, evitando la degradación del rendimiento en codificación/razonamiento que pueden causar los prompts de brevedad agresiva.
*   **Instalación Multiplataforma:** Soporta Claude Code (mediante plugin), Gemini CLI, VS Code Copilot y JetBrains Copilot, con diferentes niveles de automatización para la configuración de hooks y routing.
*   **Herramientas MCP:** Proporciona 11 herramientas MCP, incluyendo `ctx_batch_execute`, `ctx_execute`, `ctx_index`, `ctx_search`, `ctx_stats`, `ctx_doctor`, `ctx_upgrade`, `ctx_purge` y `ctx_insight`.
*   **Panel de Análisis Personal:** `ctx_insight` abre una interfaz web local con 90 métricas, 37 patrones de insight y 4 puntuaciones compuestas (productividad, calidad, delegación, salud del contexto) en 23 categorías de eventos.
*   **Hooks de Enrutamiento:** Utiliza hooks (PreToolUse, PostToolUse, PreCompact, SessionStart) para inyectar instrucciones de enrutamiento en tiempo de ejecución, optimizando el uso de herramientas y el flujo de contexto.

**Mejores Características para Integrar:**
*   **Gestión Eficiente del Contexto:** La reducción drástica del tamaño del contexto y la continuidad de la sesión son cruciales para mantener la memoria de los agentes AI y reducir costes.
*   **Filosofía "Pensar en Código":** Fomentar que los LLMs generen scripts para tareas complejas en lugar de procesar grandes volúmenes de datos directamente es una optimización fundamental.
*   **Integración Multiplataforma con Hooks:** La capacidad de integrarse con diversas herramientas de desarrollo y LLMs a través de hooks permite una adopción amplia y un control granular del flujo de trabajo.
*   **Herramientas de Diagnóstico y Análisis:** `ctx_stats`, `ctx_doctor` y `ctx_insight` proporcionan visibilidad sobre el rendimiento del agente y el uso del contexto, lo cual es invaluable para la optimización continua.
*   **Persistencia de Estado con SQLite y FTS5:** El uso de SQLite con búsqueda de texto completo (FTS5) para la persistencia del estado garantiza una recuperación eficiente y relevante de la información de la sesión.
## 5. Graphify

**Propósito:** Una herramienta CLI/skill que transforma código, documentos, PDFs, imágenes y videos en un grafo de conocimiento consultable, generando `graphify-out/graph.html`, `GRAPH_REPORT.md` y `graph.json`.

**Características Clave:**
*   **Creación de Grafos de Conocimiento:** Convierte diversos tipos de archivos (código, docs, PDFs, imágenes, videos) en un grafo de conocimiento que se puede consultar.
*   **Salidas Generadas:** Produce un `graph.html` interactivo para visualización, un `GRAPH_REPORT.md` con los puntos clave y un `graph.json` con el grafo completo.
*   **Soporte Multi-Plataforma:** Compatible con una amplia gama de asistentes de codificación AI, incluyendo Claude Code, Codex, OpenCode, Cursor, Gemini CLI, GitHub Copilot CLI, VS Code Copilot Chat, Aider, Amp, OpenClaw, Factory Droid, Trae, Hermes, Kimi Code, Kiro, Pi y Google Antigravity.
*   **Extras Opcionales:** Permite instalar funcionalidades adicionales para extracción de PDFs, soporte para archivos de Office (`.docx`, `.xlsx`), renderizado de Google Sheets, transcripción de video/audio, servidor MCP, push a Neo4j, exportación SVG, detección de comunidades (Leiden), inferencia local con Ollama, APIs de OpenAI/Gemini/Bedrock y extracción de esquemas SQL.
*   **Patrón "Query-First":** Fomenta que el agente consulte el grafo de conocimiento antes de leer archivos directamente, optimizando el uso del contexto.
*   **Reporte Detallado:** El `GRAPH_REPORT.md` incluye "God nodes" (conceptos más conectados), "Surprising connections" (enlaces inesperados), "The 'why'" (comentarios y justificaciones enlazadas al código) y "Suggested questions" (preguntas que el grafo puede responder).
*   **Confianza en las Relaciones:** Cada relación inferida en el grafo se marca con `EXTRACTED`, `INFERRED` o `AMBIGUOUS`, indicando la fiabilidad de la información.
*   **Extracción Local de Código:** El código se extrae localmente utilizando AST con `tree-sitter`, sin llamadas a la API, mientras que otros tipos de archivos utilizan el modelo del asistente AI.
*   **Comandos Comunes:** Incluye comandos para construir el grafo (`/graphify .`), actualizar (`--update`), consultar (`/graphify query`), encontrar rutas (`/graphify path`), explicar (`/graphify explain`), añadir contenido (`/graphify add`) y exportar diagramas de flujo de llamadas (`graphify export callflow-html`).
*   **Arquitectura Modular:** Una pipeline funcional pura `detect → extract → build_graph → cluster → analyze → report → export` con módulos desacoplados.

**Mejores Características para Integrar:**
*   **Generación de Grafos de Conocimiento:** La capacidad de crear un mapa semántico de un proyecto a partir de diversas fuentes es fundamental para la comprensión rápida y profunda.
*   **Patrón "Query-First":** La estrategia de consultar el grafo antes de acceder a los archivos reduce la carga cognitiva y el uso de tokens para los agentes AI.
*   **Soporte Multi-Formato:** La capacidad de procesar código, documentos, PDFs, imágenes y videos en un solo grafo proporciona una visión holística del proyecto.
*   **Reportes y Visualizaciones:** Los reportes generados y la visualización interactiva del grafo son excelentes para la exploración humana y la comunicación.
*   **Confianza en la Información:** La indicación de la confianza en las relaciones del grafo ayuda a los agentes y humanos a evaluar la fiabilidad de la información.
## 6. AI-First

**Propósito:** Un CLI y servidor MCP que proporciona a los agentes de codificación de IA una comprensión compacta y verificable de un repositorio antes de que lo editen, generando `ai-context/`.

**Características Clave:**
*   **Contexto Verificable para Agentes AI:** Genera una carpeta `ai-context/` con información clave como arquitectura, símbolos, puntos de entrada, pruebas, dependencias, reglas, riesgos, metadatos de frescura y un resumen para el agente.
*   **Enfoque en Frescura y Evidencia:** El contexto generado registra cuándo y desde qué estado de git/archivo fue creado, y las afirmaciones importantes incluyen rutas de origen, referencias de paquetes/configuración, razones y confianza.
*   **Contexto Orientado a Tareas:** Los agentes pueden solicitar contexto para una tarea específica en lugar de cargar todo el repositorio.
*   **Interfaces Compartidas:** Los humanos utilizan la CLI (`af`), mientras que los agentes utilizan MCP, ambos confiando en los mismos servicios centrales.
*   **Puertas de Calidad (Quality Gates):** CI y los agentes pueden verificar si el repositorio y el contexto generado son seguros para confiar.
*   **Comandos CLI Robustos:** Incluye comandos como `af init` (generar contexto), `af verify ai-context` (puntuar la confianza del contexto), `af doctor context` (verificar frescura), `af context --task <task>` (contexto específico de la tarea), `af understand <topic>` (combinar fuentes, pruebas, arquitectura, git, riesgos y comandos para un tema), `af index` (construir índice de símbolos SQLite), `af query` (consultar símbolos/imports/exports indexados), `af map` (construir grafos de repositorio y contexto semántico), `af explore` (explorar dependencias de módulos) y `af git` (analizar actividad reciente de git).
*   **Soporte Multi-Plataforma MCP:** Permite instalar perfiles MCP locales para OpenCode, Codex, Claude Code y Cursor, y soporta servidores MCP stdio y HTTP.
*   **Estructura de `ai-context/`:** La carpeta `ai-context/` contiene archivos como `agent_brief.md`, `ai_context.md`, `context_manifest.json`, `project.json`, `tech_stack.md`, `architecture.md`, `entrypoints.md`, `symbols.json`, `dependencies.json`, `test-mapping.json`, `security-audit.json`, `performance-analysis.json` y `dead-code.json`.
*   **Repositorios Soportados:** Optimizado para repositorios de aplicaciones multi-lenguaje, con detectores y parsers para TypeScript, JavaScript, Python, Go, Rust, Java, PHP, Ruby, C#, Kotlin, Swift, Apex y varios frameworks/herramientas de prueba.

**Mejores Características para Integrar:**
*   **Generación de Contexto Verificable y Estructurado:** La creación de `ai-context/` es fundamental para proporcionar a los agentes AI una base de conocimiento fiable y organizada del proyecto.
*   **Enfoque en Frescura y Evidencia:** La capacidad de verificar la actualidad y la fuente de la información del contexto es crucial para la confianza en las decisiones de los agentes.
*   **Contexto Adaptado a Tareas Específicas:** La funcionalidad de `af context --task` permite a los agentes obtener solo la información relevante para su tarea actual, optimizando el uso del contexto y reduciendo la sobrecarga.
*   **Puertas de Calidad para CI/CD:** La integración de `af doctor --ci` en el pipeline de CI/CD asegura que el contexto y el repositorio estén siempre en un estado confiable.
*   **Indexación de Símbolos y Grafos de Módulos:** Las capacidades de `af index` y `af map` son excelentes para la exploración profunda del código y la comprensión de las interdependencias.
## 7. Engram

**Propósito:** Proporcionar memoria persistente a los agentes de codificación de IA, actuando como un "cerebro" que recuerda sesiones pasadas, decisiones y aprendizajes, siendo agnóstico al agente, un binario único y sin dependencias.

**Características Clave:**
*   **Memoria Persistente para Agentes AI:** Almacena el rastro físico de la memoria de un agente en una base de datos SQLite con búsqueda de texto completo (FTS5).
*   **Binario Único y Sin Dependencias:** Implementado en Go, lo que resulta en un único binario sin dependencias de Node.js, Python o Docker, facilitando la instalación y el despliegue.
*   **Compatibilidad con Cualquier Agente MCP:** Expuesto a través de CLI, API HTTP y un servidor MCP, lo que lo hace compatible con Claude Code, OpenCode, Gemini CLI, Codex, VS Code (Copilot), Antigravity, Cursor, Windsurf y otros.
*   **Ciclo de Memoria:** El agente guarda el trabajo significativo (`mem_save`), Engram lo persiste en SQLite con FTS5, y en sesiones futuras, el agente busca y recupera el contexto relevante (`mem_search`, `mem_context`, `mem_timeline`, `mem_get_observation`).
*   **19 Herramientas MCP:** Ofrece un conjunto completo de herramientas para guardar, actualizar, buscar, recuperar, gestionar el ciclo de vida de la sesión, detectar conflictos y utilidades (ej. `mem_save`, `mem_search`, `mem_session_start`, `mem_judge`, `mem_stats`).
*   **Interfaz de Usuario en Terminal (TUI):** Una interfaz interactiva en terminal para visualizar el dashboard, detalles de observaciones y resultados de búsqueda.
*   **Sincronización Git:** Permite compartir memorias entre máquinas utilizando chunks comprimidos, evitando conflictos de fusión y archivos grandes. La base de datos SQLite local sigue siendo la fuente de verdad, y la integración en la nube es una replicación opcional.
*   **Integración en la Nube (Replicación Opt-In):** Soporte para replicación de memoria en la nube, con un flujo de trabajo de actualización robusto y herramientas de diagnóstico y reparación.
*   **Detección de Conflictos Semánticos (Beta):** Nuevas características beta para detectar conflictos de memoria, incluyendo la sincronización de relaciones de conflicto entre máquinas y un escaneo semántico que utiliza LLMs (Claude Code u OpenCode CLI) para juzgar candidatos de conflicto de FTS5.
*   **Recuperación de Fallos:** Mecanismos para recuperar sesiones y datos de memoria en caso de fallos.

**Mejores Características para Integrar:**
*   **Memoria Persistente y Agnosticismo de Agente:** La capacidad de proporcionar una memoria duradera y accesible para cualquier agente AI es fundamental para mantener el contexto a largo plazo en los proyectos.
*   **Binario Único y Facilidad de Despliegue:** La simplicidad de instalación y la ausencia de dependencias complejas lo hacen ideal para integrar en cualquier entorno de desarrollo.
*   **Herramientas MCP para Gestión de Memoria:** El conjunto de herramientas MCP para guardar, buscar y recuperar observaciones es directamente aplicable para construir la memoria operativa de los agentes.
*   **Sincronización Git y Cloud:** La capacidad de sincronizar memorias entre máquinas y con la nube permite un flujo de trabajo colaborativo y persistente.
*   **Detección de Conflictos Semánticos:** La funcionalidad beta para identificar conflictos en la memoria con la ayuda de LLMs es una característica avanzada para mantener la coherencia y la calidad del conocimiento almacenado.
## 8. OpenCode Model Router

**Propósito:** Un plugin de OpenCode que enruta cada tarea de codificación al nivel de IA con el precio adecuado, de forma automática en cada mensaje, con una sobrecarga mínima de tokens.

**Características Clave:**
*   **Enrutamiento de Modelos por Coste:** Dirige las tareas de codificación al modelo de IA más económico y adecuado para la tarea, optimizando los costes.
*   **Orquestador de Modelo de Nivel Medio:** Utiliza un modelo de coste medio (ej. Sonnet) como orquestador principal, que lee un protocolo de enrutamiento y delega tareas, reservando modelos más caros para cuando son realmente necesarios.
*   **Protocolo de Enrutamiento Comprimido:** Inyecta un protocolo de enrutamiento denso y optimizado para LLMs (~210 tokens) en el system prompt, que el orquestador entiende perfectamente, logrando la misma inteligencia de enrutamiento que un texto más verboso con un 75% menos de tokens.
*   **Taxonomía de Tareas Configurable:** Asigna tareas a niveles de coste (`@fast`, `@medium`, `@heavy`) utilizando una guía de enrutamiento por palabras clave (`R: @fast→search/grep/read`, `@medium→impl/refactor/test`, `@heavy→arch/debug/security`), totalmente personalizable.
*   **Descomposición de Tareas Compuestas:** Prefiere dividir tareas compuestas en fases separables (ej. explorar con un modelo barato, ejecutar con uno de coste medio), logrando ahorros significativos en tareas complejas.
*   **Evita Sobrecarga de Delegación en Tareas Triviales:** Para tareas sencillas (1-2 llamadas a herramientas), el orquestador puede ejecutar directamente sin delegación, eliminando costes y latencia.
*   **Cuatro Modos de Enrutamiento:** Ofrece modos `normal` (equilibrado), `budget` (ahorro agresivo), `quality` (prioriza modelos más potentes) y `deep` (para análisis profundos y largos), que persisten entre reinicios.
*   **Conciencia de Ratios de Coste:** Cada nivel lleva su `costRatio` (ej. fast=1x, medium=5x, heavy=20x) inyectado en el system prompt, permitiendo al orquestador considerar el precio antes de decidir.
*   **Conciencia del Orquestador:** Si el orquestador ya está ejecutándose en un modelo de alto coste (ej. Opus), la regla `self∈opus→never→@heavy` se activa, haciendo que el orquestador realice el trabajo pesado localmente en lugar de delegar a otra instancia de Opus.
*   **Soporte Multi-Proveedor con Fallback Automático:** Soporta presets para Anthropic, OpenAI, GitHub Copilot y Google, con una cadena de fallback que prueba el siguiente proveedor si uno falla.
*   **Anotación de Planes para Tareas Largas:** El comando `/annotate-plan` lee un plan en Markdown y etiqueta cada paso con `[tier:fast]`, `[tier:medium]` o `[tier:heavy]`, eliminando la ambigüedad de enrutamiento en flujos de trabajo multi-paso.
*   **Configurable:** Toda la configuración (niveles, modelos, ratios de coste, reglas, patrones de tareas, modos de enrutamiento, cadenas de fallback) reside en `tiers.json`, sin necesidad de cambios en el código.

**Mejores Características para Integrar:**
*   **Optimización de Costes Mediante Enrutamiento Inteligente:** La capacidad de seleccionar automáticamente el modelo de IA más adecuado y económico para cada subtarea es fundamental para la eficiencia y la sostenibilidad de los proyectos de AI Engineering.
*   **Protocolo de Enrutamiento Comprimido y Taxonomía de Tareas:** La inyección de un protocolo de enrutamiento eficiente y una taxonomía de tareas configurable permite una delegación precisa y optimizada del trabajo a los agentes AI.
*   **Descomposición de Tareas Compuestas:** La estrategia de dividir tareas complejas en fases más pequeñas y asignarlas a diferentes niveles de coste es una técnica poderosa para reducir el consumo de tokens y mejorar la eficiencia.
*   **Modos de Enrutamiento Adaptables:** La flexibilidad para ajustar el comportamiento del enrutador según el presupuesto o la prioridad de calidad es muy valiosa para diferentes escenarios de desarrollo.
*   **Soporte Multi-Proveedor con Fallback:** La capacidad de trabajar con múltiples proveedores de IA y tener un mecanismo de fallback automático garantiza la robustez y la disponibilidad del sistema.

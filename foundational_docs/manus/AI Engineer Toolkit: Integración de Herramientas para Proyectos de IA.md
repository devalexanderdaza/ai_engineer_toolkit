# AI Engineer Toolkit: Integración de Herramientas para Proyectos de IA

Este toolkit es una solución integrada diseñada para **AI Engineers** y **Arquitectos de AI/Software** que buscan optimizar la exploración, comprensión, desarrollo y mantenimiento de proyectos de software asistidos por inteligencia artificial. Combina las mejores características de varias herramientas líderes en el ecosistema de desarrollo de IA para proporcionar un entorno de trabajo coherente, eficiente y con "memoria".

## Propósito

El objetivo principal de este toolkit es:

1.  **Acelerar la comprensión de nuevos proyectos:** Generar rápidamente un contexto verificable y estructurado de cualquier repositorio.
2.  **Mantener la memoria persistente:** Asegurar que los agentes de IA y los ingenieros humanos tengan acceso a un historial de decisiones, aprendizajes y observaciones.
3.  **Optimizar el uso de recursos de IA:** Enrutar tareas a los modelos de IA más adecuados y rentables.
4.  **Automatizar flujos de trabajo de desarrollo:** Orquestar equipos de agentes de IA para gestionar ciclos de desarrollo completos, desde la concepción hasta la implementación.
5.  **Facilitar la colaboración y el traspaso de conocimiento:** Proporcionar artefactos claros y unificados que puedan ser compartidos entre agentes y equipos.

## Componentes Integrados y sus Aportaciones

| Componente Integrado | Herramienta Base | Aportación Clave al Toolkit |
| :------------------- | :--------------- | :-------------------------- |
| **Generación de Contexto Verificable** | AI-First | Proporciona una comprensión compacta y fiable del repositorio (`ai-context/`), incluyendo arquitectura, símbolos, dependencias y puertas de calidad. Esencial para la rápida incorporación a nuevos proyectos y para que los agentes operen con información precisa. |
| **Memoria Persistente y Compartida** | Engram | Ofrece un "cerebro" duradero para los agentes de IA, almacenando observaciones, decisiones y aprendizajes en SQLite con FTS5. Permite la continuidad de la sesión y el traspaso de conocimiento entre agentes y a lo largo del tiempo. |
| **Enrutamiento Inteligente de Modelos** | OpenCode Model Router | Optimiza el coste y la eficiencia al seleccionar automáticamente el modelo de IA más adecuado para cada tarea (ej. `@fast` para exploración, `@heavy` para arquitectura). Reduce el gasto en tokens y mejora la velocidad de ejecución. |
| **Orquestación de Agentes y Flujos de Trabajo** | IAgentek Framework & Sprintpilot | Gestiona ciclos de desarrollo completos con equipos virtuales de agentes especializados (Analista, PM, Dev, QA, etc.) y automatiza flujos de trabajo Git (ramas, commits, PRs, revisiones). Permite la ejecución autónoma con puntos de control humanos. |
| **Generación de Grafos de Conocimiento** | Graphify | Transforma código, documentos, PDFs, imágenes y videos en un grafo de conocimiento consultable. Facilita la exploración "query-first" y la comprensión profunda de las interconexiones del proyecto. |
| **Optimización del Contexto del LLM** | Context Mode | Reduce drásticamente el uso de tokens al mantener los datos brutos fuera de la ventana de contexto del LLM y fomenta el enfoque de "pensar en código". Asegura la continuidad de la sesión y la recuperación de fallos. |
| **Especialización y Delegación de Agentes** | Agent Smith CLI | Genera automáticamente constelaciones de agentes especializados y define grafos de delegación, adaptando los agentes a la estructura específica de cada repositorio. Mejora la eficiencia y la modularidad del trabajo de los agentes. |

## Estructura del Toolkit

```
ai_engineer_toolkit/
├── README.md
├── setup_project.py           # Script de inicialización para nuevos proyectos
├── project_templates/         # Plantillas de configuración para los componentes integrados
│   ├── ai_first_config.json
│   ├── engram_config.json
│   ├── model_router_tiers.json
│   ├── iagentek_config.yaml
│   ├── sprintpilot_config.yaml
│   ├── graphify_config.json
│   └── agentsmith_config.json
├── agents/                    # Configuraciones de agentes base y ejemplos de SKILL.md
│   ├── base_agent.md
│   └── example_skill.md
├── memory/                    # Esquemas de memoria y ejemplos de uso de Engram
│   └── memory_schema.json
└── context/                   # Ejemplos de `ai-context/` y cómo interpretarlo
    └── ai_context_example.md
```

## Cómo Usar el Toolkit

1.  **Inicializar un Nuevo Proyecto:** Ejecuta `python setup_project.py <nombre_del_proyecto>` para configurar la estructura básica y los archivos de configuración iniciales.
2.  **Generar Contexto Inicial:** Navega al directorio del proyecto y ejecuta `af init` para crear el `ai-context/` inicial.
3.  **Configurar Agentes de IA:** Utiliza los comandos de instalación de cada herramienta (ej. `engram setup opencode`, `graphify install --platform opencode`) para integrar los componentes con tus asistentes de codificación AI preferidos.
4.  **Comenzar a Trabajar:** Los agentes de IA ahora tendrán acceso a un contexto enriquecido, memoria persistente y enrutamiento inteligente de modelos para abordar las tareas de desarrollo.

Este `README.md` será el punto de partida para cualquier nuevo proyecto, guiando tanto a los ingenieros humanos como a los agentes de IA a través de la configuración y el uso de las herramientas integradas.

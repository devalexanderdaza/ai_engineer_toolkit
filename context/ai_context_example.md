# Ejemplo de `ai-context/` y su Interpretación

La carpeta `ai-context/` es generada por la herramienta **AI-First** y proporciona una comprensión compacta y verificable de un repositorio. Está diseñada para ser utilizada tanto por ingenieros humanos como por agentes de IA, ofreciendo una fuente de verdad estructurada y actualizada sobre el proyecto.

## Propósito de `ai-context/`

El objetivo principal de `ai-context/` es responder a preguntas clave sobre el repositorio:

*   **¿Qué es este repositorio?** Proporciona un resumen general y la pila tecnológica.
*   **¿Dónde debo trabajar?** Identifica puntos de entrada y la estructura arquitectónica.
*   **¿Qué evidencia respalda esto?** Vincula las afirmaciones a archivos fuente y configuraciones.
*   **¿Cómo verifico mi cambio?** Sugiere pruebas y puertas de calidad.

## Estructura de `ai-context/` (Ejemplo Simplificado)

```
ai-context/
├── agent_brief.md          # Resumen operacional conciso para agentes AI.
├── ai_context.md           # Contexto unificado y legible del repositorio.
├── context_manifest.json   # Metadatos de frescura, estado de git, hashes.
├── project.json            # Resumen del proyecto legible por máquina.
├── tech_stack.md           # Lenguajes, frameworks, herramientas y evidencia.
├── architecture.md         # Estructura del repositorio y roles de los módulos.
├── entrypoints.md          # Puntos de entrada (CLI/API/app/test).
├── symbols.json            # Funciones, clases, interfaces (indexado).
├── dependencies.json       # Relaciones de importación y dependencia.
└── test-mapping.json       # Enlaces de código fuente a pruebas.
```

## Cómo Interpretar `ai-context/`

Cada archivo dentro de `ai-context/` sirve un propósito específico:

*   **`agent_brief.md`**: Es el primer archivo que un agente de IA debería leer. Contiene un resumen ejecutivo del proyecto, sus objetivos y las principales áreas de enfoque. Es ideal para una orientación rápida.

*   **`ai_context.md`**: Ofrece una visión más completa y unificada del repositorio. Aquí se consolidan los hallazgos más importantes de los otros archivos, presentados de manera coherente para una lectura humana o de IA más profunda.

*   **`context_manifest.json`**: Contiene metadatos cruciales para la **frescura** y **confiabilidad** del contexto. Los agentes deben verificar este archivo para asegurarse de que la información no está obsoleta. Incluye hashes de archivos y el estado de Git en el momento de la generación.

*   **`tech_stack.md`**: Detalla las tecnologías utilizadas en el proyecto (lenguajes, frameworks, librerías) y proporciona evidencia de su uso (ej. referencias a `package.json`, `pyproject.toml`).

*   **`architecture.md`**: Describe la estructura de alto nivel del repositorio, cómo se organizan los módulos y sus responsabilidades. Es fundamental para entender la organización del código.

*   **`entrypoints.md`**: Lista los puntos de entrada principales del proyecto, como comandos CLI, rutas de API o el inicio de una aplicación. Ayuda a los agentes a identificar dónde comienza la ejecución o dónde se exponen las funcionalidades.

*   **`symbols.json` y `dependencies.json`**: Estos archivos, legibles por máquina, proporcionan un índice detallado de funciones, clases, interfaces y sus relaciones de dependencia. Son invaluables para la navegación programática del código y para entender cómo interactúan las diferentes partes del sistema.

*   **`test-mapping.json`**: Vincula el código fuente con sus pruebas correspondientes. Esto es esencial para que los agentes puedan sugerir o generar pruebas relevantes para los cambios propuestos, y para verificar la cobertura de pruebas.

## Uso por Agentes de IA

Los agentes de IA deben ser instruidos para:

1.  **Leer `agent_brief.md` primero** para una comprensión inicial.
2.  **Verificar la frescura del contexto** usando `context_manifest.json` o el comando `af doctor context`.
3.  **Utilizar `af context --task "<tarea>"`** para obtener contexto específico y enfocado a la tarea actual, evitando cargar información irrelevante.
4.  **Consultar `symbols.json` y `dependencies.json`** para navegar por el código y entender las interacciones.
5.  **Referenciar `test-mapping.json`** al realizar cambios para asegurar que las pruebas adecuadas se ejecuten o se generen.

Al seguir estas pautas, los agentes de IA pueden operar de manera más eficiente, precisa y con una comprensión profunda del proyecto, reduciendo errores y acelerando el desarrollo.

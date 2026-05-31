# Informe técnico: investigación Cursor — AI Engineer Toolkit

**Autor:** Cursor (investigación integrada)  
**Fecha:** 31 de mayo de 2026  
**Base:** Investigaciones Manus.ai y Gemini + validación upstream + requisitos del mantenedor

## 1. Resumen ejecutivo

El repositorio `ai_engineer_toolkit` consolidaba **documentación y plantillas** de ocho herramientas del ecosistema AI Engineering, pero **no integraba** herramientas en runtime ni soportaba repos brownfield ni perfiles de modelo reales (OpenCode Go/Zen, Copilot Student).

Esta investigación en `foundational_docs/cursor/` entrega:

1. **Arquitectura operativa** por capas L1/L2/L3 con procesos foreground/background.
2. **Ciclo de vida idempotente** (instalar una vez vs vincular proyecto vs sesión).
3. **Modelo de capacidades** agnóstico de proveedor (sin asumir Anthropic).
4. **Agent Smith** documentado para GitHub Copilot y VS Code Copilot Chat.
5. **Contratos** (`AGENTS.md`, `doctor.spec`, manifests) listos para copiar a proyectos.

## 2. Problema del usuario (recap)

Al analizar repos de GitHub y trabajar con múltiples agentes (OpenCode, Cursor, Copilot, etc.) faltaba:

- Contexto verificable y memoria entre sesiones.
- Routing económico de modelos según plan real (Go generoso, Zen caro, Student limitado).
- Orquestación opcional de sprints (Sprintpilot / IAgentek).
- Un init que **no reinstale** Engram en cada proyecto.

## 3. Las ocho herramientas — síntesis

| # | Herramienta | Superpoder | Capa | Install once |
|---|-------------|------------|------|--------------|
| 1 | AI-First | `ai-context/` verificable | L1 | CLI global |
| 2 | Graphify | Grafo query-first | L1 | CLI global |
| 3 | Agent Smith | Copilot agents + instructions | L1 | npx; assimilate por repo |
| 4 | Engram | Memoria SQLite FTS5 | L2 | Binario Go |
| 5 | Context Mode | Hooks + ahorro 98% tokens | L2 | npm global |
| 6 | OpenCode Model Router | Tiers @fast/@medium/@heavy | L2 | Plugin OpenCode |
| 7 | IAgentek | SDD + BMAD artefactos | L3 | CLI |
| 8 | Sprintpilot | Sprint → PR Git | L3 | npx |

Fichas detalladas: [research/](research/).

## 4. Hallazgos críticos vs investigaciones previas

### 4.1 Manus

- Forte en `repository_analysis.md` y plantillas.
- Débil: `setup_project.py` solo greenfield; `model_router_tiers.json` con modelos Anthropic/OpenAI no universales.

### 4.2 Gemini

- Forte: init in-situ (`init-ai-workspace.sh`) y capas L1/L2/L3.
- Débil: script en markdown escapado; no lifecycle idempotente explícito.

### 4.3 Cursor (esta investigación)

- Une brownfield + lifecycle + capability profile + runtime topology.
- Agent Smith como puente Copilot/VS Code → cualquier host vía instructions/SKILL.

## 5. Arquitectura recomendada

Ver [ARCHITECTURE.md](ARCHITECTURE.md) y diagramas en [RUNTIME_TOPOLOGY.md](RUNTIME_TOPOLOGY.md).

**Principios:**

1. Separar tiers **lógicos** de modelos **físicos**.
2. MCP lo inicia el **host**, no scripts de init del repo.
3. L3 solo bajo demanda.
4. `AGENTS.md` unificado referencia `copilot-instructions.md`.

## 6. Stack de referencia: OpenCode Go + Zen + Copilot Student

Documentado en [profiles/opencode-go-zen-copilot-student.yaml](profiles/opencode-go-zen-copilot-student.yaml) y [research/03_opencode_providers.md](research/03_opencode_providers.md).

- **Go:** trabajo diario, tiers fast/medium.
- **Zen:** heavy con confirmación (créditos).
- **Copilot Student:** IDE; BYOK opcional para modelos Go/Zen en VS Code.

## 7. Secuencia de adopción

Ver [INTEGRATION_SEQUENCE.md](INTEGRATION_SEQUENCE.md): Fases 0–4 idempotentes.

## 8. Verificación futura

[specs/doctor.spec.md](specs/doctor.spec.md) define `--global`, `--host`, `--project`, `--runtime`.

## 9. Roadmap implementación (raíz del repo)

Prioridad en [research/05_gaps_roadmap.md](research/05_gaps_roadmap.md):

- P0: `init-brownfield`, `doctor`, tiers lógicos en `project_templates/`
- P1: deprecar o extender `setup_project.py`
- P2: hosts YAML, CI `af doctor`

## 10. Cómo compartir con agentes locales

1. Copiar [AGENTS.md](AGENTS.md) a la raíz del proyecto destino.
2. Copiar `.ai_engineer_toolkit/` desde [templates/](templates/) y [profiles/](profiles/).
3. Ejecutar Fase 2 de [INTEGRATION_SEQUENCE.md](INTEGRATION_SEQUENCE.md).
4. Pegar en Custom Instructions un enlace: “Lee `AGENTS.md` primero”.

## 11. Referencias upstream

| Herramienta | URL |
|-------------|-----|
| Sprintpilot | https://github.com/ikunin/sprintpilot |
| IAgentek | https://github.com/azulls1/iagentek-framework |
| Agent Smith | https://github.com/shyamsridhar123/agentsmith-cli |
| Context Mode | https://github.com/mksglu/context-mode |
| Graphify | https://github.com/safishamsi/graphify |
| AI-First | https://github.com/julianperezpesce/ai-first |
| Engram | https://github.com/Gentleman-Programming/engram |
| Model Router | https://github.com/marco-jardim/opencode-model-router |
| OpenCode | https://opencode.ai/docs/ |

## 12. Documentos de esta carpeta

| Archivo | Propósito |
|---------|-----------|
| [README.md](README.md) | Índice |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Diseño integración |
| [RUNTIME_TOPOLOGY.md](RUNTIME_TOPOLOGY.md) | MCP, hooks, procesos |
| [LIFECYCLE_IDEMPOTENCY.md](LIFECYCLE_IDEMPOTENCY.md) | Install once |
| [PROVIDER_CAPABILITY_MODEL.md](PROVIDER_CAPABILITY_MODEL.md) | Routing agnóstico |
| [INTEGRATION_SEQUENCE.md](INTEGRATION_SEQUENCE.md) | Pasos brownfield |
| [AGENTS.md](AGENTS.md) | Prompt agentes |
| [research/*.md](research/) | Fichas herramientas |
| [profiles/*.yaml](profiles/) | Perfiles capacidad |
| [templates/*](templates/) | Manifests plantilla |
| [specs/doctor.spec.md](specs/doctor.spec.md) | Contrato doctor |

---

*Investigaciones previas preservadas en `foundational_docs/manus/` y `foundational_docs/gemini/`.*

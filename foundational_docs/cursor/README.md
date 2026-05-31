# Investigación Cursor — AI Engineer Toolkit

Investigación profunda que extiende las entregas de **Manus.ai** y **Gemini** con arquitectura de integración real, ciclo de vida idempotente y modelo de capacidades agnóstico (OpenCode Go/Zen, Copilot Student, multi-host).

**Fecha:** 31 mayo 2026

## Empezar aquí

| Si necesitas… | Lee |
|---------------|-----|
| Visión completa | [INVESTIGATION_REPORT.md](INVESTIGATION_REPORT.md) |
| Cómo encajan las 8 tools | [ARCHITECTURE.md](ARCHITECTURE.md) |
| MCP, hooks, background | [RUNTIME_TOPOLOGY.md](RUNTIME_TOPOLOGY.md) |
| Instalar una vez vs por repo | [LIFECYCLE_IDEMPOTENCY.md](LIFECYCLE_IDEMPOTENCY.md) |
| Modelos Go/Zen/Copilot | [PROVIDER_CAPABILITY_MODEL.md](PROVIDER_CAPABILITY_MODEL.md) |
| Pasos en repo clonado | [INTEGRATION_SEQUENCE.md](INTEGRATION_SEQUENCE.md) |
| Copiar a tus proyectos | [AGENTS.md](AGENTS.md) |

## Investigación por herramienta (`research/`)

| Archivo | Contenido |
|---------|-----------|
| [01_runtime_mcp_memory.md](research/01_runtime_mcp_memory.md) | Engram, Context Mode, AI-First, Graphify |
| [02_orchestration_git.md](research/02_orchestration_git.md) | Sprintpilot, IAgentek |
| [03_opencode_providers.md](research/03_opencode_providers.md) | Go, Zen, router, Copilot |
| [04_host_matrix.md](research/04_host_matrix.md) | Cursor, OpenCode, VS Code, … |
| [05_gaps_roadmap.md](research/05_gaps_roadmap.md) | Brechas y PR futuro |
| [06_agentsmith_hosts.md](research/06_agentsmith_hosts.md) | Copilot + VS Code |

## Plantillas y perfiles

- [templates/toolkit.manifest.yaml](templates/toolkit.manifest.yaml) — lifecycle por herramienta
- [templates/model_router_tiers.logical.json](templates/model_router_tiers.logical.json) — tiers sin IDs fijos
- [templates/mcp.manifest.json](templates/mcp.manifest.json) — servidores MCP
- [profiles/opencode-go-zen-copilot-student.yaml](profiles/opencode-go-zen-copilot-student.yaml) — perfil canónico
- [profiles/template-capability-profile.yaml](profiles/template-capability-profile.yaml) — plantilla vacía

## Especificaciones

- [specs/doctor.spec.md](specs/doctor.spec.md) — contrato `ai-toolkit doctor` (implementación futura)

## Histórico

- [../manus/](../manus/) — primera investigación (Manus)
- [../gemini/](../gemini/) — segunda investigación (Gemini)

## Próximo paso (código en raíz del toolkit)

Ver roadmap P0 en [research/05_gaps_roadmap.md](research/05_gaps_roadmap.md): `init-brownfield`, `doctor`, actualizar `project_templates/`.

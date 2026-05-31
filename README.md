# AI Engineer Toolkit

Toolkit integrado para **AI Engineers** y arquitectos: contexto verificable, memoria persistente, enrutamiento de modelos y orquestación de agentes en repos brownfield y greenfield.

**Documentación canónica:** [foundational_docs/cursor/](foundational_docs/cursor/)

| Recurso | Descripción |
|---------|-------------|
| [ARCHITECTURE.md](foundational_docs/cursor/ARCHITECTURE.md) | Capas L1/L2/L3 y runtime |
| [LIFECYCLE_IDEMPOTENCY.md](foundational_docs/cursor/LIFECYCLE_IDEMPOTENCY.md) | Install-once vs bind vs sesión |
| [INTEGRATION_SEQUENCE.md](foundational_docs/cursor/INTEGRATION_SEQUENCE.md) | Orden de integración por herramienta |
| [AGENTS.md](foundational_docs/cursor/AGENTS.md) | Prompt unificado para agentes |

Repositorio oficial: [github.com/devalexanderdaza/ai_engineer_toolkit](https://github.com/devalexanderdaza/ai_engineer_toolkit)

## Quick start — brownfield (repo existente)

Desde la raíz de tu proyecto (sin clonar el toolkit):

```bash
export AI_TOOLKIT_REF="${AI_TOOLKIT_REF:-develop}"

curl -fsSL "https://raw.githubusercontent.com/devalexanderdaza/ai_engineer_toolkit/${AI_TOOLKIT_REF}/scripts/install-toolkit.sh" \
  | bash -s -- bind --host cursor .
```

Luego fases globales y host (una vez por máquina/IDE):

```bash
./scripts/doctor.sh --global    # si clonaste el toolkit; o sigue INTEGRATION_SEQUENCE.md
engram setup cursor
af mcp install --profile cursor
af init
```

## Quick start — local (clone del toolkit)

```bash
git clone https://github.com/devalexanderdaza/ai_engineer_toolkit.git
cd ai_engineer_toolkit

./scripts/install-toolkit.sh bind --local --host opencode /path/to/your/repo
# o brownfield guiado:
./scripts/init-brownfield.sh --host opencode --local /path/to/your/repo
```

## Quick start — greenfield

```bash
./scripts/install-toolkit.sh greenfield my-new-app --host cursor --local
cd my-new-app
# af init, engram setup, etc.
```

> **Legacy:** `python setup_project.py <name>` sigue disponible; preferir `install-toolkit.sh`.

## Verificación

```bash
./scripts/doctor.sh --global
./scripts/doctor.sh --host cursor --project
```

## Componentes integrados

| Capa | Herramientas | Rol |
|------|--------------|-----|
| L1 | AI-First, Graphify, Agent Smith | Contexto, grafo, instructions Copilot/VS Code |
| L2 | Engram, Context Mode, Model Router | Memoria, hooks, tiers lógicos |
| L3 | Sprintpilot, IAgentek | SDD / sprints (opcional) |

Los tiers de modelo usan `model_router_tiers.logical.json` + `capability_profile.yaml` (sin IDs Anthropic fijos). Ver [PROVIDER_CAPABILITY_MODEL.md](foundational_docs/cursor/PROVIDER_CAPABILITY_MODEL.md).

## Estructura del repositorio

```
ai_engineer_toolkit/
├── VERSION
├── README.md
├── scripts/
│   ├── install-toolkit.sh    # bind / greenfield (local o remoto)
│   ├── init-brownfield.sh
│   ├── doctor.sh
│   └── lib/common.sh
├── install/files.manifest
├── project_templates/        # Plantillas → .ai_engineer_toolkit/
├── foundational_docs/cursor/ # Fuente de verdad (investigación + contratos)
├── agents/, memory/, context/ # Ejemplos de referencia
└── setup_project.py          # Legacy greenfield
```

## Contribuir (git-flow)

Este proyecto usa [git-flow-next](https://git-flow.sh/docs/about/):

- `main` — producción
- `develop` — integración
- `feature/*` — trabajo nuevo desde `develop`

```bash
git checkout develop
git flow feature start my-feature
# ... commits (conventional commits en inglés)
git flow feature finish my-feature
git push origin develop
```

## Investigación histórica

- [foundational_docs/manus/](foundational_docs/manus/) — investigación Manus.ai (archivo)
- [foundational_docs/gemini/](foundational_docs/gemini/) — investigación Gemini (archivo)

Versión del toolkit: ver [VERSION](VERSION).

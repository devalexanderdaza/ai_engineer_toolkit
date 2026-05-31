# Secuencia de integración (brownfield idempotente)

## Resumen de fases

| Fase | Nombre | Frecuencia | doctor |
|------|--------|-----------|--------|
| 0 | bootstrap-global | Una vez / máquina | `--global` |
| 1 | bind-host | Una vez / IDE | `--host` |
| 2 | bind-project | Por repo / re-run OK | `--project` |
| 3 | session | Automático | `--runtime` |
| 4 | L3 opcional | Bajo demanda | — |

---

## Fase 0 — Bootstrap global

**Objetivo:** Binarios en PATH. **No re-ejecutar** si `doctor --global` OK.

```bash
# Ejemplos — ajustar según OS
brew install gentleman-programming/tap/engram   # Engram
npm install -g context-mode                   # Context Mode
# AI-First, Graphify, Agent Smith vía npx sin -g también válido
```

Checklist:

- [ ] `command -v engram`
- [ ] `command -v context-mode` (o plugin Claude)
- [ ] `af` o `npx ai-first --help`
- [ ] `graphify --help` o instalar vía uv
- [ ] OpenCode instalado si aplica

---

## Fase 1 — Bind host

**Objetivo:** MCP y hooks en el IDE. Idempotente (merge config).

### OpenCode

```bash
engram setup opencode
context-mode opencode install   # si aplica
graphify install --platform opencode
# Plugin: opencode-model-router según README del plugin
```

Copiar a `~/.config/opencode/` o proyecto:

- Plantillas desde `.ai_engineer_toolkit/`

### Cursor

```bash
engram setup cursor   # ver AGENT-SETUP Engram
# MCP: configurar en Cursor Settings según mcp.manifest.json
# Context Mode: según docs para Cursor si disponible
```

### VS Code + Copilot

```bash
code --add-mcp '{"name":"engram","command":"engram","args":["mcp"]}'
# Copilot: extensión + gh auth para Agent Smith
```

---

## Fase 2 — Bind project

**En el directorio del repo clonado:**

### 2.1 Toolkit layout

```bash
mkdir -p .ai_engineer_toolkit
cp <toolkit>/foundational_docs/cursor/templates/* .ai_engineer_toolkit/
cp <toolkit>/foundational_docs/cursor/AGENTS.md ./AGENTS.md
cp <toolkit>/foundational_docs/cursor/profiles/opencode-go-zen-copilot-student.yaml \
   .ai_engineer_toolkit/capability_profile.yaml
```

### 2.2 L1 — Indexación

```bash
# AI-First — skip si fresco
af init
af doctor context

# Graphify — skip si grafo reciente
graphify . --project

# Agent Smith — requiere Copilot + gh
npx agentsmith assimilate .
npx agentsmith validate
```

**Idempotencia:**

| Comando | skip_if |
|---------|---------|
| `af init` | `af doctor context --ci` pasa |
| `graphify .` | política equipo / `--update` manual |
| `assimilate` | `validate` OK y sin cambio arquitectónico mayor |

### 2.3 L2 — Datos proyecto

```bash
export ENGRAM_DATA_DIR="$PWD/.engram"
mkdir -p .engram
# MCP: no lanzar manual; verificar en IDE tras Fase 1
```

### 2.4 Discovery

- Abrir OpenCode → `/models` → actualizar `capability_profile.yaml` si candidatos difieren.
- `doctor --project` (cuando exista script).

---

## Fase 3 — Sesión

El ingeniero abre Cursor u OpenCode. El IDE:

1. Arranca MCP (Engram, AI-First, …).
2. Activa hooks Context Mode.
3. Agente lee `AGENTS.md` → `copilot-instructions.md` (si existe) → `ai-context/agent_brief.md`.
4. `mem_search` para contexto previo.

**No** repetir Fase 0–2 al abrir nueva sesión.

---

## Fase 4 — L3 (opcional)

```bash
# Sprint BMAD
npx @ikunin/sprintpilot install --tools cursor,github-copilot

# SDD completo
npx @iagentek/cli init
```

Solo cuando hay historia/sprint definido.

---

## Degradación

| Fallo | Acción |
|-------|--------|
| Sin Copilot | Omitir Agent Smith; L1 sin instructions |
| Sin graphify | Solo AI-First + grep |
| MCP no arranca | `doctor --runtime`; revisar Fase 1 |
| Modelo tier missing | Editar capability_profile; mode budget |

---

## Referencias

- [LIFECYCLE_IDEMPOTENCY.md](LIFECYCLE_IDEMPOTENCY.md)
- [templates/toolkit.manifest.yaml](templates/toolkit.manifest.yaml)
- [research/01_runtime_mcp_memory.md](research/01_runtime_mcp_memory.md)

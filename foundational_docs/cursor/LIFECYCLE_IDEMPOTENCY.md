# Ciclo de vida idempotente del AI Engineer Toolkit

**Autor:** Investigación Cursor (síntesis Manus + Gemini + validación upstream)  
**Fecha:** 31 de mayo de 2026  
**Estado:** Contrato de diseño para init/doctor futuros

## Principio

Las herramientas del ecosistema se dividen en **cuatro scopes**. Confundir “instalar” con “ejecutar por proyecto” o “arrancar en cada sesión” rompe la idempotencia y genera scripts que reinstalan Engram o levantan MCP en background sin necesidad.

| Scope | Pregunta que responde | Idempotencia |
|-------|----------------------|--------------|
| `GLOBAL_INSTALL` | ¿Está el binario/CLI en PATH? | Si versión OK → skip |
| `HOST_BIND` | ¿El IDE conoce MCP/hooks/skills? | Merge config; no duplicar entradas |
| `PROJECT_BIND` | ¿El repo tiene artefactos locales? | Re-run seguro con `skip-if-fresh` / `--force` |
| `SESSION_RUNTIME` | ¿Hay proceso vivo ahora? | Health-check; no reinstalar |

## Clasificación por herramienta (8 integradas)

| Herramienta | GLOBAL_INSTALL | HOST_BIND | PROJECT_BIND | SESSION_RUNTIME |
|-------------|----------------|-----------|--------------|-----------------|
| **AI-First** | CLI `af` / npx | `af mcp install` (perfil host) | `af init` → `ai-context/` | MCP stdio por IDE |
| **Graphify** | `uv tool install graphify` / pipx | `graphify install --platform <host>` | `graphify .` → `graphify-out/` | MCP opcional; consultas on-demand |
| **Engram** | Binario Go (`engram`) | `engram setup <platform>` | `.engram/` o `ENGRAM_DATA_DIR` | MCP arrancado por IDE (no `&` en prod) |
| **Context Mode** | `npm i -g context-mode` | `context-mode <host> install` (hooks) | SQLite sesión en ruta del proyecto/host | Hooks en cada turno + `ctx_*` MCP |
| **OpenCode Model Router** | Plugin en OpenCode global | `tiers.json` en proyecto | Taxonomía en `.ai_engineer_toolkit/` | Inyección protocolo en cada mensaje |
| **Agent Smith** | `npx agentsmith-cli` | — | `assimilate` → copilot-instructions, agents, handoffs, SKILL | — |
| **IAgentek** | `@iagentek/cli` global | — | `.iagentek/`, artefactos SDD | Orquestación bajo demanda |
| **Sprintpilot** | `npx @ikunin/sprintpilot` | Skills en paths del host | `_Sprintpilot/`, `_bmad-output/` | `autopilot.js` + worktrees |

## Reglas operativas

### Engram

1. **Una vez:** instalar binario (`curl` / `go install` / release).
2. **Por host:** `engram setup opencode` | `engram setup cursor` escribe entrada MCP en config del host.
3. **Por proyecto:** datos en `<repo>/.engram/` (o variable de entorno); no reinstalar binario.
4. **Sesión:** Cursor/OpenCode spawn `engram mcp`; el ingeniero no debe depender de `engram mcp &` salvo depuración.

### Context Mode

1. **Una vez:** paquete global o plugin.
2. **Por host:** registra hooks (`PreToolUse`, `PostToolUse`, `PreCompact`, `SessionStart`).
3. **Persistencia:** SQLite + FTS5 para continuidad tras compactación del chat.

### Agent Smith

1. **Por proyecto:** `npx agentsmith-cli assimilate` (idempotente con política documentada en `research/06_agentsmith_hosts.md`).
2. Genera `.github/copilot-instructions.md` consumible por **GitHub Copilot** y **VS Code Copilot Chat**.
3. `AGENTS.md` del toolkit **referencia** esas instrucciones; no las duplica.

### AI-First / Graphify

- Re-ejecutar `af init` o `graphify .` solo si `context_manifest` / grafo están **stale** (cambio grande de código o `--force`).

## Fases del init brownfield (contrato)

```
Fase 0: bootstrap-global     → doctor --global
Fase 1: bind-host <cursor|opencode|vscode-copilot>
Fase 2: bind-project          → af init, graphify, agentsmith, .ai_engineer_toolkit/
Fase 3: session               → automático (IDE)
Fase 4: L3 opcional           → iagentek / sprintpilot
```

## Manifest (`templates/toolkit.manifest.yaml`)

Cada herramienta debe declarar en el manifest:

- `scopes: [GLOBAL_INSTALL, ...]`
- `install.check` / `install.cmd`
- `bind.host.cmd` por host
- `bind.project.cmd`
- `skip_if` (archivo/hash que indica frescura)
- `force_flag`

Ver [`templates/toolkit.manifest.yaml`](templates/toolkit.manifest.yaml).

## Anti-patrones

| Anti-patrón | Corrección |
|-------------|------------|
| `engram mcp &` en cada `init` del repo | Solo Fase 1 host bind; sesión la inicia el IDE |
| Reinstalar npm global en cada proyecto | Fase 0 con skip si `doctor` OK |
| Asumir modelos Anthropic en `tiers.json` | Tiers lógicos + `capability_profile.yaml` |
| Omitir Agent Smith porque “uso Cursor” | `copilot-instructions.md` y SKILL benefician a todos los hosts |
| `setup_project.py` solo greenfield | Brownfield: Fase 2 en repo existente |

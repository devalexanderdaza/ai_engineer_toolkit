# Orquestación L3: Sprintpilot, IAgentek, Agent Smith (resumen)

**Capa:** L3 — solo bajo demanda (ticket, sprint, SDD completo)  
**No confundir con L2** (memoria/MCP siempre disponibles)

## Cuándo usar cada capa

| Capa | Herramientas | Trigger |
|------|--------------|---------|
| L1 | AI-First, Graphify, Agent Smith | Clonar repo / cambio arquitectónico mayor |
| L2 | Engram, Context Mode, Model Router | Cada sesión de desarrollo |
| L3 | Sprintpilot, IAgentek | "Implementar historia X", sprint BMAD, greenfield SDD |

---

## Sprintpilot

**Repo:** https://github.com/ikunin/sprintpilot

### Lifecycle

| Scope | Acción |
|-------|--------|
| GLOBAL | `npx @ikunin/sprintpilot@latest` |
| HOST_BIND | `install --tools claude-code,cursor,...` → copia skills |
| PROJECT | `_Sprintpilot/`, `_bmad-output/`, worktrees `.worktrees/<story>/` |
| SESSION | `autopilot.js start|next|record` |

### Estado y Git

- **BMad owned:** `sprint-status.yaml` (Sprintpilot no lo modifica).
- **Addon owned:** `git-status.yaml` (rama, SHA, PR, lint).
- **Worktree por historia:** aislamiento; fallback a rama normal si falla worktree.

### SKILL.md

Skills `sprint-autopilot-*`, `sprintpilot-*` instalados en paths del host. Compatible con Cursor, Claude Code, Copilot, Gemini CLI, etc.

### Idempotencia install

- Additive: no pisa BMad core.
- Re-install: `npx @ikunin/sprintpilot@latest` restaura skills.
- Markers HTML en `AGENTS.md` para actualizar reglas sin tocar contenido usuario.

### Perfiles

`nano` | `small` | `medium` | `large` | `legacy` — escalan proceso, paralelismo, state shards.

---

## IAgentek Framework

**Repo:** https://github.com/azulls1/iagentek-framework

### Lifecycle

| Scope | Acción |
|-------|--------|
| GLOBAL | `@iagentek/cli` |
| PROJECT | `.iagentek/config.yaml`, `state.json`, artefactos SDD |

### Modos

- `autonomous-with-checkpoints` (default)
- `fully-autonomous`
- `interactive`

### Ciclos

`greenfield` | `brownfield` | `bugfix` | `refactor`

### Artefactos

`constitution.md`, `PRD.md`, `architecture.md`, `sprint-plan.md`, `specs/`, `stories/`, `tasks/`, `qa/`, etc.

### Providers

claude-cli, anthropic, openai, gemini, deepseek, ollama (auto-detect).

---

## Agent Smith (breve — ver 06)

- **L1**, no L3: `assimilate` genera ecosistema Copilot/VS Code.
- Complementa Sprintpilot (SKILL.md compartido, distinto propósito).

---

## Matriz L3 vs toolkit diario

| Necesidad | Usar |
|-----------|------|
| Entender repo nuevo | L1 |
| Recordar decisión de ayer | L2 Engram |
| Ahorrar tokens en grep masivo | L2 Context Mode + Graphify |
| PR automático de sprint completo | L3 Sprintpilot |
| PRD → código con checkpoints | L3 IAgentek |

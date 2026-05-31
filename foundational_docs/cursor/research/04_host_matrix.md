# Matriz de integración por host

**Referencia principal:** Cursor + OpenCode  
**Extensible:** Claude Code, Codex, Antigravity, VS Code Copilot, Gemini CLI

## Tabla comparativa

| Host | Reglas / instrucciones | MCP config | Hooks nativos | Agent Smith | Sprintpilot skills |
|------|------------------------|------------|---------------|-------------|-------------------|
| **Cursor** | `AGENTS.md`, `.cursor/rules/`, rules UI | Cursor MCP settings / `.cursor/mcp.json` | Limitado; MCP + rules | Lee `copilot-instructions`, skills copiables | `.cursor/skills/` vía install |
| **OpenCode** | `AGENTS.md`, `.opencode/`, `opencode.json` | `opencode.json` mcp section | Plugin router, hooks según plugin | Misma lectura convenciones | `.opencode/skills/` |
| **Claude Code** | `CLAUDE.md` → `@AGENTS.md` | Plugin Engram, MCP | Claude hooks + Context Mode plugin | copilot-instructions referencia | `.claude/skills/` |
| **Codex** | Según producto OpenAI | MCP stdio | Variable | Referencia | Según install |
| **Antigravity** | Rules del producto | MCP | Variable | Referencia | graphify lista Antigravity |
| **VS Code Copilot** | `.github/copilot-instructions.md` | `code --add-mcp` / settings | Copilot hooks (Agent Smith) | **Nativo** agents + handoffs | `.github/copilot/skills/` |
| **Gemini CLI** | System prompt append | MCP config gemini | Context Mode soportado | Referencia | Gemini skills path |

## Rutas de archivos por host

### Cursor

- `AGENTS.md` (raíz) — prioridad alta para Composer/Agent
- `.cursor/rules/*.mdc` o `.md`
- MCP: configuración en IDE → equivalente proyecto-local si existe

### OpenCode

- `opencode.json` — providers, model, MCP servers
- `.opencode/agents/`, commands, plugins
- Model router: plugin + `tiers.json` / logical tiers en `.ai_engineer_toolkit/`

### VS Code + GitHub Copilot Chat

- `.github/copilot-instructions.md` — **generado por Agent Smith**
- `.github/agents/*.agent.md` — custom agents
- `.github/copilot/handoffs.json`
- Extensión BYOK: modelos OpenCode Go/Zen en picker

### Claude Code

- `CLAUDE.md` include `AGENTS.md`
- `engram setup claude-code` — plugin marketplace

## Lifecycle por host (resumen)

| Fase | Cursor | OpenCode | VS Code Copilot |
|------|--------|----------|-----------------|
| Global | engram, context-mode, af, graphify | igual | igual + Copilot ext |
| Host bind | MCP en Cursor | `engram setup opencode`, router plugin | MCP + Copilot login |
| Project | af init, graphify, agentsmith | + capability_profile | agentsmith crítico |
| Session | IDE spawns MCP | IDE/TUI spawns MCP | Copilot session |

## Agent Smith por host

| Host | Consumo directo |
|------|-----------------|
| VS Code Copilot | **Pleno** — agents, handoffs, instructions |
| Cursor | **Parcial** — leer instructions + skills; no runSubagent nativo |
| OpenCode | **Parcial** — skills en `.opencode/skills` si se sincronizan |

## Sprintpilot install (--tools)

Valores documentados en Manus README: `claude-code`, `cursor`, `windsurf`, `gemini-cli`, `cline`, `roo`, `trae`, `kiro`, `github-copilot`.

```bash
npx @ikunin/sprintpilot install --tools cursor,github-copilot
```

## Recomendación toolkit

Un solo `AGENTS.md` en raíz del proyecto destino + **no duplicar** `copilot-instructions.md`. Host-specific solo para MCP paths en `.ai_engineer_toolkit/hosts/<name>.yaml` (plantilla futura).

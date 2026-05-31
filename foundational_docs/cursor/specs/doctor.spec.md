# Especificación: `ai-toolkit doctor`

**Versión:** 0.1.0-draft  
**Estado:** Contrato para implementación futura en raíz del repo

## Objetivo

Comando único que verifica el estado del toolkit en cuatro scopes, **sin reinstalar** componentes ya válidos.

```bash
ai-toolkit doctor [--global] [--host <name>] [--project] [--runtime] [--json]
```

Default: ejecutar todos los scopes aplicables al directorio actual.

## Salida

| Código | Significado |
|--------|-------------|
| 0 | Todo OK o solo WARN |
| 1 | FAIL en scope crítico |
| 2 | Uso incorrecto |

Por check: `OK` | `WARN` | `FAIL` | `SKIP` + mensaje + `remediation`.

---

## Scope: `--global`

Verifica **GLOBAL_INSTALL** (ver [toolkit.manifest.yaml](../templates/toolkit.manifest.yaml)):

| Check | Comando detección |
|-------|-------------------|
| engram_binary | `command -v engram` |
| context_mode | `command -v context-mode` o plugin Claude |
| ai_first | `af --version` o npx |
| graphify | `graphify --version` |
| node_version | `node -v` ≥ 18 para Agent Smith |

No ejecuta instalación automática salvo flag futuro `--fix` (fuera de v0.1).

---

## Scope: `--host <name>`

Hosts: `opencode`, `cursor`, `vscode-copilot`, `claude-code`, `gemini-cli`, `codex`, `antigravity`.

| Check | Descripción |
|-------|-------------|
| mcp_engram_registered | Entrada en config MCP del host |
| mcp_ai_first_registered | Si L1 usado |
| context_mode_hooks | Hooks instalados si herramienta usada |
| model_router_plugin | Solo opencode: plugin presente |

---

## Scope: `--project`

Ejecutar desde raíz del repo:

| Check | Descripción |
|-------|-------------|
| agents_md | `AGENTS.md` presente |
| ai_engineer_toolkit_dir | `.ai_engineer_toolkit/` |
| ai_context_fresh | `af doctor context` |
| graphify_out | `graphify-out/graph.json` opcional WARN |
| copilot_instructions | `.github/copilot-instructions.md` WARN si Copilot host |
| agentsmith_validate | `npx agentsmith validate` si assets exist |
| engram_data_dir | `.engram/` o env configurado |
| capability_profile | YAML válido vs schema |
| logical_tiers | `model_router_tiers.logical.json` presente |

---

## Scope: `--runtime`

Requiere IDE/sesión activa o probes locales:

| Check | Descripción |
|-------|-------------|
| mcp_engram_ping | Herramienta `mem_stats` responde |
| mcp_ai_first_ping | Si configurado |
| tier_candidates_resolve | Cada candidato en capability_profile existe en host |
| zen_heavy_policy | WARN si mode budget y tier heavy apunta Zen |
| copilot_student_quota | WARN heurístico si solo Student |

---

## Idempotencia con init

| doctor | init |
|--------|------|
| FAIL global | sugerir Fase 0 comandos |
| FAIL host | sugerir Fase 1 |
| FAIL project | sugerir Fase 2 paso específico |
| OK global | init Fase 0 skip |

---

## Relación con upstream

- Reutilizar `engram doctor`, `af doctor context`, `ctx_doctor`, `agentsmith validate` como sub-checks cuando existan.

---

## Implementación sugerida (PR futuro)

- `scripts/doctor.py` en raíz del toolkit.
- Lee `templates/toolkit.manifest.yaml`.
- Salida humana + `--json` para CI.

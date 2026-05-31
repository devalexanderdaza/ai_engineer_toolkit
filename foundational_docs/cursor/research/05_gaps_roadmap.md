# Brechas del toolkit actual y roadmap

**Análisis:** raíz vs `foundational_docs/manus` vs `foundational_docs/gemini`  
**Fecha:** 31 mayo 2026

## Inventario de duplicación

| Contenido | Ubicaciones | Acción post-Cursor |
|-----------|-------------|-------------------|
| Plantillas config (7 archivos) | `project_templates/` + `foundational_docs/manus/` | Unificar tras validar `cursor/templates/` |
| `setup_project.py` | raíz + manus | Reemplazar por brownfield init |
| `README` / informe | raíz + manus + gemini | Raíz apunta a `foundational_docs/cursor/` como fuente de verdad |
| `repository_analysis.md` | solo manus | Mantener histórico; cursor/ es evolución |
| `ARCHITECTURE.md` Sprintpilot | manus (upstream copy) | Referencia L3, no arquitectura toolkit |

## Supuestos falsos detectados

1. **`model_router_tiers.json`** — IDs `anthropic/claude-opus-4-6`, `gpt-4o-plus` no garantizados; usuario puede tener solo OpenCode Go.
2. **`setup_project.py`** — Solo greenfield (carpeta nueva vacía); no sirve para repo GitHub clonado.
3. **Gemini `CANVAS.md`** — Script bash con escapes `\#`, no ejecutable tal cual.
4. **`engram mcp &` en background** — Anti-patrón; MCP lo inicia el IDE.
5. **Agent Smith opcional** — Pierde valor en Cursor-only; instructions y SKILL son cross-host.
6. **Integración “config only”** — Plantillas sin `doctor`, sin manifest lifecycle, sin capability discovery.
7. **Reinstalar globals por proyecto** — No documentado como error hasta `LIFECYCLE_IDEMPOTENCY.md`.

## Qué corrige la investigación Cursor

| Entregable Cursor | Problema que resuelve |
|-------------------|----------------------|
| `LIFECYCLE_IDEMPOTENCY.md` | install-once vs bind vs session |
| `ARCHITECTURE.md` | Capas L1/L2/L3 + runtime real |
| `RUNTIME_TOPOLOGY.md` | Hooks + MCP simultáneos |
| `PROVIDER_CAPABILITY_MODEL.md` | Routing agnóstico |
| `profiles/opencode-go-zen-copilot-student.yaml` | Stack real del mantenedor |
| `templates/model_router_tiers.logical.json` | Sin IDs hardcoded |
| `research/06_agentsmith_hosts.md` | Copilot + VS Code |
| `AGENTS.md` | Prompt unificado para agentes |
| `specs/doctor.spec.md` | Contrato verificación |

## Roadmap priorizado (implementación en raíz)

### P0 — Crítico (completado en `feature/p0-installer-and-templates`)

1. ~~Actualizar `README.md` raíz → enlazar `foundational_docs/cursor/`.~~ **Hecho**
2. ~~Sustituir `project_templates/model_router_tiers.json` por tiers lógicos + `capability_profile` template.~~ **Hecho** (`model_router_tiers.logical.json`, `capability_profile.template.yaml`)
3. ~~`scripts/init-brownfield.sh` (Fases 0–2 idempotentes).~~ **Hecho**
4. ~~`scripts/doctor.sh` (--global, --host, --project, --runtime).~~ **Hecho v0.1**
5. ~~`scripts/install-toolkit.sh` + `install/files.manifest` (remoto/local).~~ **Hecho**
6. ~~`VERSION` + higiene legacy `foundational_docs/manus/`.~~ **Hecho**

### P1 — Alto valor

5. Deprecar `setup_project.py` greenfield o añadir modo `--brownfield`.
6. `templates/mcp.manifest.json` generado por host.
7. Copiar `AGENTS.md` desde cursor/ a plantilla en `project_templates/`.

### P2 — Orquestación

8. Integración documentada Sprintpilot / IAgentek (opt-in L3).
9. Perfiles host en `.ai_engineer_toolkit/hosts/`.

### P3 — Nice to have

10. CI check `af doctor --ci` en repos que adopten toolkit.
11. Sync Engram git chunks documentado en onboarding.

## Separación de responsabilidades

| Ámbito | Contenido |
|--------|-----------|
| `foundational_docs/cursor/` | Investigación, arquitectura, contratos — **estable** |
| Raíz toolkit | Scripts ejecutables, plantillas consumidas — **siguiente PR** |
| `foundational_docs/manus|gemini/` | Archivo histórico investigaciones previas — **no borrar** |

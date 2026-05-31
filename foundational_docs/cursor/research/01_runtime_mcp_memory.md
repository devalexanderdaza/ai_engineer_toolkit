# Runtime: MCP, memoria y contexto (L2)

**Herramientas:** Engram, Context Mode, AI-First, Graphify  
**Verificado:** 31 mayo 2026 (README upstream + análisis Manus)

## Tabla resumen

| Herramienta | GLOBAL | HOST_BIND | PROJECT | SESSION | Datos persistidos |
|-------------|--------|-----------|---------|---------|-------------------|
| Engram | Binario Go | `engram setup <host>` | `.engram/` o `ENGRAM_DATA_DIR` | MCP stdio (IDE) | `~/.engram/engram.db` o proyecto |
| Context Mode | npm global | `context-mode <host> install` | SQLite sesión | Hooks cada turno | SQLite FTS5 |
| AI-First | CLI `af` | MCP profile install | `ai-context/` | MCP stdio | `ai-context/*`, índice SQLite |
| Graphify | uv/pipx CLI | `graphify install --platform` | `graphify-out/` | MCP opcional | graph.json, GRAPH_REPORT.md |

---

## Engram

**Repo:** https://github.com/Gentleman-Programming/engram

### Lifecycle

- **GLOBAL_INSTALL:** `brew install gentleman-programming/tap/engram` (o release Go).
- **HOST_BIND:** `engram setup opencode` | `cursor` | `codex` | `gemini-cli` | VS Code MCP JSON.
- **PROJECT_BIND:** `ENGRAM_DATA_DIR=<repo>/.engram` para aislar memoria por repo.
- **SESSION_RUNTIME:** El host ejecuta `engram mcp [--project NAME]`; **no** lanzar `engram mcp &` en scripts de init de producción.

### Idempotencia

- Re-ejecutar `setup` hace merge de config MCP.
- Tras actualizar binario: `engram setup <host>` + **reiniciar IDE** (MCP subprocess no se recarga solo).
- `mem_save` / `mem_search` idempotentes a nivel de datos (nuevas observaciones = nuevos IDs).

### MCP (19 herramientas, categorías)

| Categoría | Herramientas |
|-----------|--------------|
| Save/Update | `mem_save`, `mem_update`, `mem_delete`, `mem_suggest_topic_key` |
| Search | `mem_search`, `mem_context`, `mem_timeline`, `mem_get_observation` |
| Session | `mem_session_start`, `mem_session_end`, `mem_session_summary` |
| Conflict | `mem_judge`, `mem_compare` |
| Utils | `mem_save_prompt`, `mem_stats`, `mem_capture_passive`, `mem_merge_projects`, `mem_current_project`, `mem_doctor` |

### OpenCode / Cursor

- OpenCode: `engram setup opencode` → entrada en config MCP del proyecto/usuario.
- Cursor: documentado en `docs/AGENT-SETUP.md`; MCP manual o setup si existe comando.

### Foreground vs background

- **Background implícito:** proceso MCP hijo del IDE.
- **Foreground:** `engram tui`, `engram search`, CLI admin.

---

## Context Mode

**Repo:** https://github.com/mksglu/context-mode

### Lifecycle

- **GLOBAL_INSTALL:** paquete npm o plugin Claude.
- **HOST_BIND:** instala hooks por host (`context-mode opencode install`, etc.).
- **SESSION_RUNTIME:** hooks en cada herramienta del agente; MCP `ctx_*`.

### Hooks (tiempo real)

- `PreToolUse`, `PostToolUse`, `PreCompact`, `SessionStart`
- En **PreCompact:** re-indexa eventos → recuperación BM25 tras compactación del chat.

### MCP (11 herramientas)

`ctx_batch_execute`, `ctx_execute`, `ctx_index`, `ctx_search`, `ctx_stats`, `ctx_doctor`, `ctx_upgrade`, `ctx_purge`, `ctx_insight`

### Filosofía

- Datos brutos **fuera** de la ventana del LLM (~98% ahorro en dumps grandes).
- "Pensar en código": scripts que imprimen solo resultado relevante.

### Idempotencia

- Re-instalar hooks: merge; no duplicar entradas si el instalador es bien hecho.
- SQLite por workspace/proyecto según configuración upstream.

---

## AI-First

**Repo:** https://github.com/julianperezpesce/ai-first

### Lifecycle

- **GLOBAL_INSTALL:** CLI `af`.
- **HOST_BIND:** perfiles MCP (`af mcp install` para OpenCode, Cursor, Codex, Claude).
- **PROJECT_BIND:** `af init` → `ai-context/`.
- **SESSION_RUNTIME:** MCP comparte servicios con CLI.

### Comandos clave (project bind)

```bash
af init
af verify ai-context
af doctor context
af context --task "<tarea>"
af index
af query
af map
```

### Idempotencia

- Re-run `af init` si código cambió o `context_manifest` stale.
- `af doctor --ci` en pipeline para bloquear contexto obsoleto.

### Artefactos `ai-context/`

`agent_brief.md`, `ai_context.md`, `context_manifest.json`, `project.json`, `tech_stack.md`, `architecture.md`, `entrypoints.md`, `symbols.json`, `dependencies.json`, `test-mapping.json`, etc.

---

## Graphify

**Repo:** https://github.com/safishamsi/graphify

### Lifecycle

- **GLOBAL_INSTALL:** `uv tool install graphifyy` (nombre paquete según upstream).
- **HOST_BIND:** `graphify install --platform opencode|cursor|...`
- **PROJECT_BIND:** `graphify .` o `/graphify .` en chat.
- **SESSION_RUNTIME:** consultas MCP/query-first.

### Salidas

- `graphify-out/graph.json`, `graph.html`, `GRAPH_REPORT.md`
- Código: AST local (tree-sitter); otros medios vía modelo del asistente.

### Patrón query-first

El agente consulta el grafo **antes** de leer archivos completos.

### Idempotencia

- `--update` para refrescar sin borrar manualmente.
- Skip si grafo reciente y commit base sin cambios estructurales (política del toolkit).

---

## Orden de lectura recomendado (sesión)

1. `AGENTS.md` (toolkit)
2. `.github/copilot-instructions.md` (si Agent Smith corrió)
3. `ai-context/agent_brief.md`
4. `mem_search` (Engram) + `graphify query` / MCP grafo
5. Código fuente acotado

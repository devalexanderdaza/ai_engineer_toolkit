# OpenCode, proveedores y routing económico

**Verificado:** 31 mayo 2026 — docs opencode.ai, análisis Manus, perfil Cursor

## Jerarquía de configuración OpenCode

Orden de precedencia (mayor gana):

1. macOS managed / MDM (si aplica)
2. `OPENCODE_CONFIG_CONTENT` (inline)
3. Proyecto: `opencode.json` en raíz
4. `.opencode/` (agents, commands, plugins)
5. Global: `~/.config/opencode/opencode.json`
6. Remote `.well-known/opencode`

Campos relevantes: `provider`, `model`, `small_model`, `disabled_providers`, `enabled_providers`.

## OpenCode Go vs Zen vs gratis

| Producto | Coste | Modelos | Uso recomendado en toolkit |
|----------|-------|---------|---------------------------|
| **Go** | ~$10/mes ($5 primer mes) | DeepSeek V4 Flash/Pro, Kimi K2.x, GLM, MiniMax, MiMo, Qwen… | Tier `@fast` y `@medium` diario |
| **Zen** | Créditos pay-as-you-go | Premium + algunos free | Tier `@heavy` con confirmación |
| **Free / Big Pickle** | $0 | Limitado | Fallback cuando Go agota ventana 5h |
| **Go → Zen balance** | Opcional en consola | Fallback tras límite Go | Política `budget` del router |

**Importante:** Go y Zen son proveedores **distintos** en OpenCode; no asumir `anthropic/claude-*` como default.

## GitHub Copilot Student + BYOK

| Modo | Comportamiento |
|------|----------------|
| Copilot Student | Model picker limitado por plan educativo |
| VS Code + Copilot Chat | Lee `copilot-instructions.md`, custom agents |
| BYOK (extensiones) | OpenCode Go/Zen como LM Provider en Copilot Chat sin Copilot Pro |

El toolkit debe soportar **tres vías de inferencia** en paralelo:

1. OpenCode TUI/CLI (Go/Zen/router)
2. Cursor (modelo del usuario)
3. VS Code Copilot (Student o BYOK)

## OpenCode Model Router

**Repo:** https://github.com/marco-jardim/opencode-model-router

- Plugin OpenCode; inyecta protocolo ~210 tokens en system prompt.
- `tiers.json` define taxonomía `@fast` | `@medium` | `@heavy`.
- Modos: `normal`, `budget`, `quality`, `deep`.
- **Conflicto con Manus:** [`model_router_tiers.json`](../../manus/model_router_tiers.json) hardcodea `anthropic/claude-haiku-4-5` etc.

### Corrección del toolkit

1. Usar `model_router_tiers.logical.json` (solo patrones y modos).
2. Mapear tiers → modelos reales en `capability_profile.yaml`.
3. Discovery al inicio de sesión (`/models` en TUI o inspección `opencode.json`).

## Capability profile (stack canónico)

Ver [`../profiles/opencode-go-zen-copilot-student.yaml`](../profiles/opencode-go-zen-copilot-student.yaml).

## Políticas de routing recomendadas

```text
budget:     default @fast (Go Flash/MiniMax); Zen bloqueado salvo fallo x2
normal:     @medium Go; @heavy con confirmación o Zen
quality:    @medium/@heavy liberal
deep:       explore@fast luego execute@heavy; no delegar trivial
```

## Multi-host desconocido

Para Claude Code / Codex / Antigravity:

- No hardcodear provider IDs.
- `capability_profile.yaml` por máquina (gitignored o en `~/.config/ai_engineer_toolkit/`).
- `doctor --runtime` valida que cada candidato del tier resuelve.

## Referencias

- https://opencode.ai/docs/config/
- https://opencode.ai/docs/go/
- Plugin: marco-jardim/opencode-model-router

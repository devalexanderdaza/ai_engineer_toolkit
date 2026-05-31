# LEGACY / READ-ONLY — Investigación Gemini

> **No usar como fuente operativa.** La documentación canónica del toolkit está en [`../cursor/README.md`](../cursor/README.md).

## Contenido

| Archivo | Descripción |
|---------|-------------|
| `CANVAS.md` | Canvas/script de integración generado por Gemini (histórico) |
| `RESPONSE.md` | Respuesta estructurada de la investigación |

## Errata conocida (`CANVAS.md`)

- Comandos bash con escapes `\#` no ejecutables tal cual.
- Typo `graphifyy` en lugar de `graphify` en algunos pasos.
- Patrón `engram mcp &` en background — **no usar**; el MCP lo inicia el IDE (ver [`../cursor/LIFECYCLE_IDEMPOTENCY.md`](../cursor/LIFECYCLE_IDEMPOTENCY.md)).

Para procedimientos actuales, seguir [`../cursor/INTEGRATION_SEQUENCE.md`](../cursor/INTEGRATION_SEQUENCE.md).

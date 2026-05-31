# Instrucciones para agentes — AI Engineer Toolkit

> Copia este archivo a la **raíz de cada proyecto** que integre el toolkit.  
> Los hosts (Cursor, OpenCode, Copilot, Claude Code) deben leerlo al inicio de sesión.

## Contexto

Este repositorio usa el **AI Engineer Toolkit**: capas L1 (indexación), L2 (memoria y contexto), L3 (sprints SDD, opcional).

Documentación completa: `.ai_engineer_toolkit/` o el repo del toolkit en `foundational_docs/cursor/`.

## Orden de lectura obligatorio

1. **Este archivo** (`AGENTS.md`) — reglas de operación.
2. **`.github/copilot-instructions.md`** — si existe (generado por Agent Smith). Contiene convenciones de código, stack y arquitectura del repo. **No dupliques** su contenido; aplícalo al escribir código.
3. **`ai-context/agent_brief.md`** — resumen verificable (AI-First). Comprueba frescura con `context_manifest.json` o `af doctor context`.
4. **Memoria** — usa herramientas MCP Engram: `mem_search`, `mem_context` antes de explorar a ciegas.
5. **Grafo** — si existe `graphify-out/`, consulta el grafo (query-first) antes de leer muchos archivos.
6. **Código fuente** — solo tras los pasos anteriores.

## Reglas de eficiencia

- **Pensar en código:** para análisis pesados, escribe un script y muestra solo la salida relevante (Context Mode).
- **Tiers de modelo:** tareas triviales (grep, listar) no requieren modelo pesado. En OpenCode respeta `capability_profile.yaml` y modo `budget` si está activo.
- **Memoria:** al cerrar trabajo significativo, `mem_save` con tipo (architecture, decision, bugfix) y What/Why/Where/Learned.
- **No reinstalar:** Engram y Context Mode ya están instalados globalmente; no ejecutes instaladores en cada sesión.

## Herramientas por capa

| Capa | Herramientas | Cuándo |
|------|--------------|--------|
| L1 | AI-First, Graphify, Agent Smith | Contexto/grafo/instructions ya generados en el repo |
| L2 | Engram, Context Mode, Model Router | Siempre en sesión |
| L3 | Sprintpilot, IAgentek | Solo si el usuario pide sprint o flujo SDD |

## Agent Smith y Copilot

Si existen `.github/agents/*.agent.md` y `.github/copilot/handoffs.json`:

- Delega por dominio usando `@agent` / `runSubagent` **solo si el host lo soporta** (VS Code Copilot Chat).
- En Cursor/OpenCode, usa las instructions y SKILL como referencia, no como API de subagente obligatoria.

## Desarrollo guiado

Si el usuario pide implementar una **historia** o **sprint**:

1. Confirmar especificación (IAgentek/Sprintpilot si L3 activo).
2. Validar contra `ai-context/` y tests mapeados.
3. Ejecutar cambios; `mem_save` de decisiones clave.
4. No abrir PR automático salvo que L3 Sprintpilot esté explícitamente invocado.

## Modo de trabajo

Eres un **ingeniero principal** colaborando con el humano. Prioriza evidencia (`ai-context`, memoria, grafo) sobre suposiciones. Pregunta si el `capability_profile` bloquea un tier heavy (coste Zen/Copilot).

# Agent Smith CLI — Copilot, VS Code y ecosistema multi-agente

**Fuente validada:** [README upstream](https://github.com/shyamsridhar123/agentsmith-cli) (mayo 2026)  
**Repo:** https://github.com/shyamsridhar123/agentsmith-cli

## Propósito en el toolkit

Agent Smith convierte un repositorio en un **ecosistema multi-agente** orientado a **GitHub Copilot** y **VS Code Copilot Chat**. No sustituye a `AGENTS.md` del toolkit: lo **complementa** con convenciones y agentes de dominio.

## Lifecycle scopes

| Scope | Acción |
|-------|--------|
| GLOBAL_INSTALL | `npm install` / `npx agentsmith-cli` (Node 18+) |
| PROJECT_BIND | `npx agentsmith assimilate <path\|url>` |
| HOST_BIND | Implícito: VS Code/Copilot leen `.github/` al abrir el repo |
| SESSION_RUNTIME | Copilot SDK durante `assimilate` (análisis); no daemon permanente |

**Idempotencia:** Re-ejecutar `assimilate` regenera assets. Usar `--dry-run` para preview. Validar con `agentsmith validate`. Para evitar sorpresas, versionar en git y usar política de re-assimilate tras cambios arquitectónicos grandes.

## Artefactos generados

```
.github/
├── skills/<skill-name>/SKILL.md
├── agents/
│   ├── <repo>-root.agent.md    # Orquestador (runSubagent)
│   └── <domain>.agent.md       # Especialistas
├── copilot/handoffs.json       # Delegación por keywords
├── copilot-instructions.md     # Convenciones repo-wide
└── hooks/
    ├── pre-commit-quality.yaml
    ├── pre-push-tests.yaml
    └── post-generate-validate.yaml
skills-registry.jsonl
```

### Consumidores por host

| Artefacto | GitHub Copilot (web/PR) | VS Code Copilot Chat | Cursor | OpenCode |
|-----------|-------------------------|----------------------|--------|----------|
| `copilot-instructions.md` | Sí (nativo) | Sí (nativo) | Referencia manual / rules | Convenciones |
| `.github/agents/*.agent.md` | Custom agents | @agents en chat | Adaptable vía rules | Skills path si se copia |
| `handoffs.json` | Delegación Copilot | runSubagent | Documentación | Parcial |
| `SKILL.md` | Skills Copilot | Skills | `.cursor/skills` posible | `.opencode/skills` |
| Hooks YAML | Lifecycle Copilot | Lifecycle | No automático | No automático |

## Comandos clave

```bash
npx agentsmith assimilate .              # Local
npx agentsmith assimilate <github-url>   # Remoto sin clone
npx agentsmith assimilate . --dry-run --verbose
npx agentsmith assimilate . --single-agent
npx agentsmith search "routing"
npx agentsmith validate
```

**Nota:** El README upstream no documenta un flag `--tools` como Sprintpilot; la salida es siempre estructura `.github/` para Copilot. El toolkit debe tratar Agent Smith como **generador de artefactos Copilot-compatibles** reutilizables por otros hosts vía `SKILL.md` y lectura de instrucciones.

## Requisitos upstream

- Node.js 18+
- **Suscripción GitHub Copilot** (SDK de análisis)
- `gh auth login`

Sin Copilot activo, `assimilate` puede fallar en análisis remoto/SDK. Degradación: omitir Agent Smith en Fase 2 y documentar en `doctor --project`.

## Integración con AGENTS.md unificado

Reglas para el `AGENTS.md` del toolkit (raíz del proyecto destino):

1. **Leer primero** `AGENTS.md` del toolkit (flujo L1/L2/L3, MCP, memoria).
2. **Si existe** `.github/copilot-instructions.md`, tratarlo como **fuente de convenciones de código** (estilo, stack, arquitectura) — no duplicar su contenido en `AGENTS.md`.
3. **Delegación:** Si el host soporta custom agents, usar `handoffs.json` y `@domain` según Agent Smith.
4. **Skills:** Preferir `.github/skills/**/SKILL.md` para patrones extraídos del repo.

## Jerarquía multi-agente

```
repo-root (orchestrator, runSubagent)
├── backend
│   └── auth
├── frontend
├── infrastructure
└── data
```

Modo `--single-agent`: un solo `.agent.md` (comportamiento v0.3).

## Relación con otras herramientas del toolkit

| Herramienta | Relación |
|-------------|----------|
| AI-First | `ai-context/` = evidencia verificable; Agent Smith = convenciones y agentes |
| Graphify | Grafo semántico; Agent Smith = dominios y handoffs |
| Sprintpilot | Ambos usan `SKILL.md`; Sprintpilot instala skills BMAD, Agent Smith genera skills de dominio |
| Engram | Memoria de sesiones; Agent Smith no persiste memoria entre sesiones |

## Anti-patrones

- Omitir Agent Smith en proyectos Cursor-only → se pierden `copilot-instructions` útiles para cualquier host.
- Duplicar en `AGENTS.md` todo el contenido de `copilot-instructions.md`.
- Asumir `--tools github-copilot` sin verificar CLI actual (no en README principal).

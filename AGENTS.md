# Instrucciones para agentes — AI Engineer Toolkit (repositorio)

Este repositorio **no es una aplicación web** ni un monorepo con servicios HTTP. Es el kit de integración (plantillas, documentación y `setup_project.py`) para orquestar herramientas externas (AI-First, Engram, Graphify, etc.) en proyectos destino.

Para reglas de operación en **proyectos que ya integraron el toolkit**, copia o consulta `foundational_docs/cursor/AGENTS.md` en la raíz del proyecto cliente.

## Cursor Cloud specific instructions

### Qué hay que ejecutar aquí

| Acción | Comando | Notas |
|--------|---------|--------|
| Inicializar proyecto de prueba | `python3 setup_project.py <nombre>` | Crea `<nombre>/` y `.ai_engineer_toolkit/` con plantillas desde `project_templates/` |
| Comprobar sintaxis Python | `python3 -m py_compile setup_project.py` | No hay `requirements.txt` ni entorno virtual en el repo |
| Lint opcional | `ruff check setup_project.py` | Ruff no está en el repo; instalar con `pip install ruff` solo si hace falta en la sesión |
| Validar JSON de plantillas | `python3 -c "import json,glob; [json.load(open(p)) for p in glob.glob('project_templates/*.json')]"` | Las plantillas YAML se validan al copiarse en un scaffold |

### Qué **no** arrancar en esta VM

- No hay `docker-compose`, `package.json` en la raíz ni servidor de desarrollo (`npm run dev`, etc.).
- Las herramientas L1/L2/L3 (Engram MCP, `af`, Graphify, Sprintpilot) son **binarios/npm globales** instalados fuera de este repo; el IDE las lanza por stdio MCP. No ejecutes `engram mcp` en background manualmente.
- `ai-toolkit doctor` está especificado en `foundational_docs/cursor/specs/doctor.spec.md` pero **no implementado** en la raíz del repo.

### Flujo “hello world” en Cloud

1. Desde `/workspace`: `python3 setup_project.py e2e-smoke-test`
2. Verificar: `ls e2e-smoke-test/.ai_engineer_toolkit/` (7 plantillas + README copiado)
3. Opcional: `python3 setup_project.py e2e-smoke-test` debe fallar con código 1 (directorio existente)
4. Borrar el scaffold de prueba si no debe quedar en git: `rm -rf e2e-smoke-test`

### Documentación útil

- README principal: `README.md`
- Secuencia de integración completa: `foundational_docs/cursor/INTEGRATION_SEQUENCE.md`
- Manifiesto MCP mínimo: `foundational_docs/cursor/templates/mcp.manifest.json`

### Update script (VM startup)

No hay dependencias Python/npm versionadas en este repositorio. El script de actualización de la VM es un no-op (`true`); Python 3.12+ del sistema es suficiente.

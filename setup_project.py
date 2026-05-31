"""
Legacy greenfield initializer for AI Engineer Toolkit.

Prefer: scripts/install-toolkit.sh greenfield <name> --local
See README.md and foundational_docs/cursor/LIFECYCLE_IDEMPOTENCY.md
"""
import os
import shutil
import sys

def setup_project(project_name):
    project_path = os.path.join(os.getcwd(), project_name)
    toolkit_config_path = os.path.join(project_path, ".ai_engineer_toolkit")

    if os.path.exists(project_path):
        print(f"Error: El directorio '{project_name}' ya existe. Por favor, elige otro nombre o elimina el existente.")
        sys.exit(1)

    os.makedirs(project_path)
    os.makedirs(toolkit_config_path)

    # Copiar plantillas de configuración
    config_templates_source = os.path.join(os.path.dirname(__file__), "project_templates")
    if os.path.exists(config_templates_source):
        for item_name in os.listdir(config_templates_source):
            if item_name.endswith(".deprecated") or item_name == "AGENTS.template.md":
                continue
            source_item_path = os.path.join(config_templates_source, item_name)
            dest_name = item_name.replace(".template.", ".")
            if item_name == "capability_profile.template.yaml":
                dest_name = "capability_profile.yaml"
            destination_item_path = os.path.join(toolkit_config_path, dest_name)
            if os.path.isfile(source_item_path):
                with open(source_item_path, "r", encoding="utf-8") as f_src:
                    content = f_src.read()
                content = content.replace("{{project_name}}", project_name)
                with open(destination_item_path, "w", encoding="utf-8") as f_dst:
                    f_dst.write(content)
            elif os.path.isdir(source_item_path):
                shutil.copytree(source_item_path, destination_item_path)

    agents_template = os.path.join(config_templates_source, "AGENTS.template.md")
    if os.path.isfile(agents_template):
        with open(agents_template, "r", encoding="utf-8") as f_src:
            content = f_src.read().replace("{{project_name}}", project_name)
        with open(os.path.join(project_path, "AGENTS.md"), "w", encoding="utf-8") as f_dst:
            f_dst.write(content)

    version_file = os.path.join(os.path.dirname(__file__), "VERSION")
    if os.path.isfile(version_file):
        with open(version_file, "r", encoding="utf-8") as vf:
            ver = vf.read().strip()
        with open(os.path.join(toolkit_config_path, ".toolkit-version"), "w", encoding="utf-8") as f:
            f.write(ver)

    shutil.copy2(os.path.join(os.path.dirname(__file__), "README.md"), os.path.join(toolkit_config_path, "README.md"))

    with open(os.path.join(project_path, "README.md"), "w", encoding="utf-8") as f:
        f.write(f"# Proyecto: {project_name}\n\nInicializado con AI Engineer Toolkit.\n\nVer `.ai_engineer_toolkit/` y `AGENTS.md`.\n")

    print(f"\nProyecto '{project_name}' inicializado en '{project_path}'")
    print("\nRecomendado: usar scripts/install-toolkit.sh para brownfield y binds idempotentes.")
    print("\nPasos siguientes:")
    print(f"1. cd {project_name}")
    print("2. af init")
    print("3. engram setup <host>; graphify install --platform <host>")
    print("4. foundational_docs/cursor/INTEGRATION_SEQUENCE.md")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python setup_project.py <nombre_del_proyecto>")
        print("Prefer: ./scripts/install-toolkit.sh greenfield <nombre> --local")
        sys.exit(1)
    setup_project(sys.argv[1])

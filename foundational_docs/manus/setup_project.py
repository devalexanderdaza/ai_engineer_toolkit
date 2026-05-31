import os
import shutil
import sys

def setup_project(project_name):
    project_path = os.path.join(os.getcwd(), project_name)
    toolkit_config_path = os.path.join(project_path, ".ai_engineer_toolkit")

    if os.path.exists(project_path):
        print(f"Error: El directorio \'{project_name}\' ya existe. Por favor, elige otro nombre o elimina el existente.")
        sys.exit(1)

    os.makedirs(project_path)
    os.makedirs(toolkit_config_path)

    # Copiar plantillas de configuración
    config_templates_source = os.path.join(os.path.dirname(__file__), "project_templates")
    if os.path.exists(config_templates_source):
        for item_name in os.listdir(config_templates_source):
            source_item_path = os.path.join(config_templates_source, item_name)
            destination_item_path = os.path.join(toolkit_config_path, item_name)
            if os.path.isfile(source_item_path):
                # Leer el contenido, reemplazar placeholders y escribirlo en el destino
                with open(source_item_path, "r") as f_src:
                    content = f_src.read()
                content = content.replace("{{project_name}}", project_name)
                with open(destination_item_path, "w") as f_dst:
                    f_dst.write(content)
            elif os.path.isdir(source_item_path):
                shutil.copytree(source_item_path, destination_item_path)

    # Copiar el README.md principal del toolkit al directorio .ai_engineer_toolkit/ del nuevo proyecto
    shutil.copy2(os.path.join(os.path.dirname(__file__), "README.md"), os.path.join(toolkit_config_path, "README.md"))
    
    # Crear un README.md básico para el nuevo proyecto
    with open(os.path.join(project_path, "README.md"), "w") as f:
        f.write(f"# Proyecto: {project_name}\n\nEste es un nuevo proyecto inicializado con el AI Engineer Toolkit.\n\nPara empezar, consulta la documentación en `.ai_engineer_toolkit/README.md` y sigue los pasos de configuración.\n")

    print(f"\nProyecto \'{project_name}\' inicializado exitosamente en \'{project_path}\'")
    print("\nPasos siguientes:")
    print(f"1. Navega al directorio del proyecto: `cd {project_name}`")
    print("2. Genera el contexto inicial con AI-First: `af init`")
    print("3. Configura tus agentes de IA usando las plantillas en `.ai_engineer_toolkit/` y los comandos de instalación de cada herramienta (ej. `engram setup opencode`, `graphify install --platform opencode`).")
    print("4. ¡Comienza a desarrollar con el apoyo de tus agentes de IA!")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python setup_project.py <nombre_del_proyecto>")
        sys.exit(1)
    project_name = sys.argv[1]
    setup_project(project_name)

#!/usr/bin/env python3
"""
SQL Lab - Go!
El script más simple posible. Instala todo y arranca.
"""

import os
import sys
import subprocess
import json
from pathlib import Path
from datetime import datetime

def run(cmd, desc=""):
    """Ejecuta comando y muestra output"""
    if desc:
        print(f"\n{desc}...")
    print(f"> {cmd}\n")
    result = subprocess.run(cmd, shell=True)
    if result.returncode != 0:
        print(f"ERROR ejecutando: {cmd}")
        sys.exit(1)

def main():
    root = Path(__file__).parent
    os.chdir(root)

    print("\n" + "="*50)
    print("SQL Lab - Inicialización Completa")
    print("="*50 + "\n")

    # 1. Node.js
    print("1. Instalando Node.js...")
    run("apt-get update")
    run("apt-get install -y nodejs npm")

    # 2. SQLite
    print("\n2. Instalando SQLite...")
    run("apt-get install -y sqlite3")

    # 3. Directorios
    print("\n3. Creando directorios...")
    Path("/workspace/data").mkdir(parents=True, exist_ok=True)
    print("   OK: /workspace/data")

    # 4. npm install
    print("\n4. Instalando dependencias npm...")
    os.chdir("web")
    run("npm install")
    os.chdir("..")

    # 5. BDs
    print("\n5. Inicializando bases de datos...")
    for lab in ["01-basics", "02-joins", "03-aggregates"]:
        db_path = f"/workspace/data/{lab}.db"
        init_sql = f"labs/{lab}/init.sql"
        print(f"   Creando {db_path}...")
        run(f"sqlite3 {db_path} < {init_sql}")

    # 6. Progress file
    print("\n6. Creando progress file...")
    progress = {
        "started": datetime.utcnow().isoformat() + "Z",
        "labs": {}
    }
    with open("/workspace/.progress.json", "w") as f:
        json.dump(progress, f, indent=2)
    print("   OK: /workspace/.progress.json")

    # 7. Verificar
    print("\n7. Verificando instalación...")
    os.chdir("web")
    result = subprocess.run("npm list 2>/dev/null | head -5", shell=True)
    os.chdir("..")

    # 8. Listo
    print("\n" + "="*50)
    print("LISTO!")
    print("="*50 + "\n")
    print("Inicializacion completada correctamente.")
    print("El servidor se arrancara automaticamente.\n")
    print("Abre en el navegador: http://localhost:3000\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nDetenido por usuario.")
        sys.exit(0)
    except Exception as e:
        print(f"\nERROR: {e}")
        sys.exit(1)

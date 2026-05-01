#!/usr/bin/env python3
"""
SQL Lab Setup - Instalación completa de un comando
Funciona en Linux, macOS y Windows
"""

import os
import sys
import json
import sqlite3
import subprocess
from pathlib import Path
from datetime import datetime

class Colors:
    GREEN = '\033[0;32m'
    RED = '\033[0;31m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'

class SQLLabSetup:
    def __init__(self):
        self.root = Path(__file__).parent
        self.errors = 0
        self.warnings = 0
        self.workspace = Path(os.environ.get('WORKSPACE', '/workspace'))

    def print_header(self, text):
        print(f"\n{Colors.BLUE}=== {text} ==={Colors.NC}\n")

    def ok(self, msg):
        print(f"{Colors.GREEN}✓{Colors.NC} {msg}")

    def error(self, msg):
        print(f"{Colors.RED}✗{Colors.NC} {msg}")
        self.errors += 1

    def warn(self, msg):
        print(f"{Colors.YELLOW}!{Colors.NC} {msg}")
        self.warnings += 1

    def run(self, cmd, silent=True):
        """Ejecuta comando, retorna True si success"""
        try:
            if silent:
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
            else:
                result = subprocess.run(cmd, shell=True, timeout=30)
            return result.returncode == 0
        except Exception:
            return False

    def cmd_exists(self, cmd):
        """Verifica si comando existe"""
        return self.run(f"command -v {cmd} > /dev/null 2>&1")

    def setup_all(self):
        print(f"\n{Colors.BLUE}SQL Lab - Setup Completo{Colors.NC}\n")

        self.check_structure()
        self.install_nodejs()
        self.install_sqlite()
        self.install_npm_deps()
        self.create_directories()
        self.init_databases()
        self.create_progress()
        self.print_summary()

        return self.errors == 0

    def check_structure(self):
        self.print_header("1. Estructura")

        dirs = ['labs', '.devcontainer', 'web', 'web/public']
        for d in dirs:
            if (self.root / d).exists():
                self.ok(f"Carpeta '{d}'")
            else:
                self.error(f"Carpeta '{d}' NO existe")

    def install_nodejs(self):
        self.print_header("2. Node.js")

        if self.cmd_exists('node'):
            try:
                result = subprocess.run(['node', '--version'], capture_output=True, text=True)
                version = result.stdout.strip()
                self.ok(f"Node.js instalado: {version}")
                return
            except:
                pass

        self.warn("Node.js no encontrado")
        self.warn("Instala desde: https://nodejs.org/")

    def install_sqlite(self):
        self.print_header("3. SQLite")

        if self.cmd_exists('sqlite3'):
            try:
                result = subprocess.run(['sqlite3', '--version'], capture_output=True, text=True)
                version = result.stdout.strip().split()[0]
                self.ok(f"SQLite instalado: {version}")
                return
            except:
                pass

        self.warn("SQLite no encontrado")
        self.warn("Instala desde: https://www.sqlite.org/")

    def install_npm_deps(self):
        self.print_header("4. Dependencias npm")

        node_modules = self.root / 'web' / 'node_modules'
        package_json = self.root / 'web' / 'package.json'

        if not package_json.exists():
            self.error("web/package.json NO existe")
            return

        if node_modules.exists():
            self.ok("node_modules existe")
            return

        self.warn("Instalando dependencias npm...")
        os.chdir(self.root / 'web')

        if self.run('npm install'):
            self.ok("Dependencias instaladas")
        else:
            self.error("Error instalando npm")

        os.chdir(self.root)

    def create_directories(self):
        self.print_header("5. Directorios")

        data_dir = self.workspace / 'data'
        data_dir.mkdir(parents=True, exist_ok=True)
        self.ok(f"Directorio {data_dir}")

    def init_databases(self):
        self.print_header("6. Bases de Datos")

        data_dir = self.workspace / 'data'
        labs = ['01-basics', '02-joins', '03-aggregates']

        for lab in labs:
            self.init_lab(lab, data_dir)

    def init_lab(self, lab_id, data_dir):
        db_path = data_dir / f"{lab_id}.db"
        init_sql = self.root / 'labs' / lab_id / 'init.sql'

        if not init_sql.exists():
            self.warn(f"{lab_id}: init.sql no existe")
            return

        # Verificar si BD existe y tiene tablas
        if db_path.exists():
            try:
                conn = sqlite3.connect(str(db_path))
                cursor = conn.cursor()
                cursor.execute("SELECT COUNT(*) FROM sqlite_master WHERE type='table'")
                table_count = cursor.fetchone()[0]
                conn.close()

                if table_count > 0:
                    self.ok(f"{lab_id}.db ($table_count tablas)")
                    return
                else:
                    # BD vacía, borrar y recrear
                    db_path.unlink()
            except:
                pass

        # Crear BD
        try:
            conn = sqlite3.connect(str(db_path))
            with open(init_sql, 'r') as f:
                conn.executescript(f.read())
            conn.commit()
            conn.close()
            self.ok(f"{lab_id}.db creado")
        except Exception as e:
            self.error(f"{lab_id}: {e}")

    def create_progress(self):
        self.print_header("7. Progreso")

        progress_file = self.workspace / '.progress.json'
        if progress_file.exists():
            self.ok(".progress.json existe")
            return

        progress_file.parent.mkdir(parents=True, exist_ok=True)
        data = {
            'started': datetime.utcnow().isoformat() + 'Z',
            'labs': {}
        }

        try:
            with open(progress_file, 'w') as f:
                json.dump(data, f, indent=2)
            self.ok(".progress.json creado")
        except Exception as e:
            self.error(f"Error creando progress: {e}")

    def print_summary(self):
        self.print_header("RESUMEN")

        if self.errors == 0:
            print(f"{Colors.GREEN}Setup completado correctamente{Colors.NC}\n")
            print("Para arrancar:")
            print("  cd web")
            print("  npm start")
            print("")
            print("Luego abre: http://localhost:3000")
            print("")
            return True
        else:
            print(f"{Colors.RED}Setup con {self.errors} errores{Colors.NC}")
            print(f"Advertencias: {self.warnings}\n")
            return False

if __name__ == '__main__':
    setup = SQLLabSetup()
    success = setup.setup_all()
    sys.exit(0 if success else 1)

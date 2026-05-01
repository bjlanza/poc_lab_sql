#!/usr/bin/env python3
"""
SQL Lab Setup Checker - Verifica y diagnóstica problemas
"""

import os
import sys
import json
import subprocess
from pathlib import Path

class Colors:
    GREEN = '\033[0;32m'
    RED = '\033[0;31m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'

def print_header(text):
    print(f"\n{Colors.BLUE}=== {text} ==={Colors.NC}\n")

def print_ok(text):
    print(f"{Colors.GREEN}✓{Colors.NC} {text}")

def print_error(text):
    print(f"{Colors.RED}✗{Colors.NC} {text}")

def print_warn(text):
    print(f"{Colors.YELLOW}!{Colors.NC} {text}")

class LabChecker:
    def __init__(self):
        self.errors = 0
        self.warnings = 0
        self.root = Path(__file__).parent

    def check_all(self):
        print(f"{Colors.BLUE}SQL Lab Setup Checker{Colors.NC}\n")

        self.check_structure()
        self.check_labs()
        self.check_web()
        self.check_node()
        self.check_sqlite()
        self.check_json_files()
        self.check_node_modules()
        self.check_databases()

        self.print_summary()
        return self.errors == 0

    def check_structure(self):
        print_header("1. Estructura de Carpetas")

        dirs = ['labs', '.devcontainer', 'web', 'web/public', 'web/public/css', 'web/public/js']
        for d in dirs:
            path = self.root / d
            if path.exists():
                print_ok(f"Carpeta '{d}' existe")
            else:
                print_error(f"Carpeta '{d}' NO existe")
                self.errors += 1

    def check_labs(self):
        print_header("2. Laboratorios")

        labs = ['01-basics', '02-joins', '03-aggregates']
        required_files = ['instructions.md', 'init.sql', 'check.sh', 'hints.json']

        for lab in labs:
            lab_path = self.root / 'labs' / lab
            if lab_path.exists():
                print_ok(f"Lab '{lab}' existe")
                for file in required_files:
                    file_path = lab_path / file
                    if file_path.exists():
                        print_ok(f"  - {file}")
                    else:
                        print_error(f"  - {file} NO existe")
                        self.errors += 1
            else:
                print_error(f"Lab '{lab}' NO existe")
                self.errors += 1

    def check_json_files(self):
        print_header("3. Validez de JSON")

        json_files = [
            'labs/01-basics/hints.json',
            'labs/02-joins/hints.json',
            'labs/03-aggregates/hints.json',
            'web/package.json',
        ]

        for json_file in json_files:
            path = self.root / json_file
            if not path.exists():
                print_error(f"{json_file} NO existe")
                self.errors += 1
                continue

            try:
                with open(path, 'r') as f:
                    json.load(f)
                print_ok(f"{json_file} es JSON válido")
            except json.JSONDecodeError as e:
                print_error(f"{json_file} JSON inválido: {e}")
                self.errors += 1

    def check_web(self):
        print_header("4. Archivos Web")

        web_files = [
            'web/server.js',
            'web/public/index.html',
            'web/public/css/app.css',
            'web/public/js/app.js',
            'web/public/js/ui.js',
            'web/public/js/editor.js',
        ]

        for file in web_files:
            path = self.root / file
            if path.exists():
                print_ok(f"{file}")
            else:
                print_error(f"{file} NO existe")
                self.errors += 1

    def check_node(self):
        print_header("5. Node.js")

        try:
            result = subprocess.run(['node', '--version'], capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                version = result.stdout.strip()
                print_ok(f"Node.js instalado: {version}")
            else:
                print_error("Node.js no funciona correctamente")
                self.errors += 1
        except FileNotFoundError:
            print_error("Node.js NO instalado")
            self.errors += 1
        except Exception as e:
            print_error(f"Error verificando Node.js: {e}")
            self.errors += 1

    def check_node_modules(self):
        print_header("6. Dependencias npm")

        node_modules = self.root / 'web' / 'node_modules'
        package_json = self.root / 'web' / 'package.json'

        if not package_json.exists():
            print_error("web/package.json NO existe")
            self.errors += 1
            return

        if node_modules.exists():
            print_ok("node_modules existe (dependencias instaladas)")
        else:
            print_warn("node_modules NO existe")
            print_warn("Ejecuta: cd web && npm install")
            self.warnings += 1

    def check_sqlite(self):
        print_header("7. SQLite")

        try:
            result = subprocess.run(['sqlite3', '--version'], capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                version = result.stdout.strip().split()[0]
                print_ok(f"SQLite instalado: {version}")
            else:
                print_error("SQLite no funciona correctamente")
                self.errors += 1
        except FileNotFoundError:
            print_error("SQLite NO instalado")
            self.errors += 1
        except Exception as e:
            print_error(f"Error verificando SQLite: {e}")
            self.errors += 1

    def check_databases(self):
        print_header("8. Bases de Datos")

        data_dir = Path('/workspace/data')
        if not data_dir.exists():
            print_warn("Directorio /workspace/data NO existe")
            print_warn("Ejecuta: bash reset-dbs.sh")
            self.warnings += 1
            return

        print_ok("/workspace/data existe")

        labs = ['01-basics', '02-joins', '03-aggregates']
        for lab in labs:
            db_path = data_dir / f"{lab}.db"
            if db_path.exists():
                print_ok(f"{lab}.db existe")

                # Verificar que tiene tablas
                try:
                    import sqlite3
                    conn = sqlite3.connect(str(db_path))
                    cursor = conn.cursor()
                    cursor.execute("SELECT COUNT(*) FROM sqlite_master WHERE type='table'")
                    table_count = cursor.fetchone()[0]
                    conn.close()

                    if table_count > 0:
                        print_ok(f"  - {table_count} tabla(s) en {lab}.db")
                    else:
                        print_error(f"  - {lab}.db está vacía (sin tablas)")
                        print_warn("  Ejecuta: bash reset-dbs.sh")
                        self.warnings += 1
                except Exception as e:
                    print_error(f"  - Error verificando {lab}.db: {e}")
                    self.errors += 1
            else:
                print_warn(f"{lab}.db NO existe")
                print_warn("Ejecuta: bash reset-dbs.sh")
                self.warnings += 1

    def print_summary(self):
        print_header("RESUMEN")

        if self.errors == 0 and self.warnings == 0:
            print(f"{Colors.GREEN}Todo correcto - Puedes arrancar con: bash start.sh{Colors.NC}")
            return True

        if self.errors > 0:
            print(f"{Colors.RED}Errores encontrados: {self.errors}{Colors.NC}")

        if self.warnings > 0:
            print(f"{Colors.YELLOW}Advertencias: {self.warnings}{Colors.NC}")

        print("\nPasos para arreglar:")
        if self.errors > 0:
            print("1. Revisa los errores arriba")
            print("2. Crea carpetas/archivos faltantes")

        if self.warnings > 0:
            print("\nPara instalar dependencias:")
            print("  cd web")
            print("  npm install")
            print("  cd ..")

        print("\nPara inicializar BDs:")
        print("  bash .devcontainer/setup.sh")

        print("\nPara arrancar:")
        print("  bash start.sh")

if __name__ == '__main__':
    checker = LabChecker()
    success = checker.check_all()
    sys.exit(0 if success else 1)

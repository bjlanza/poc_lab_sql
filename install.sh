#!/bin/bash

# SQL Lab - Complete Installation Script
# Instala todo lo necesario y arranca el servidor

set -e

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

print_header() {
  echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

print_ok() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
  ((ERRORS++))
}

print_warn() {
  echo -e "${YELLOW}!${NC} $1"
  ((WARNINGS++))
}

# ============ INICIO ============

print_header "SQL Lab Installation"

# ============ 1. DETECTAR SISTEMA ============

print_header "1. Detectando Sistema"

OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
  print_ok "Linux detectado"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
  print_ok "macOS detectado"
else
  OS="other"
  print_warn "Sistema: $OSTYPE (puede que falle algo)"
fi

# ============ 2. INSTALAR NODE.JS ============

print_header "2. Verificando Node.js"

if command -v node &> /dev/null; then
  NODE_VERSION=$(node -v)
  print_ok "Node.js ya instalado: $NODE_VERSION"
else
  print_warn "Node.js no encontrado, instalando..."

  if [ "$OS" = "linux" ]; then
    apt-get update -y > /dev/null 2>&1 || true
    apt-get install -y nodejs npm > /dev/null 2>&1
    print_ok "Node.js instalado (apt)"
  elif [ "$OS" = "macos" ]; then
    print_error "Node.js no instalado. Ejecuta: brew install node"
  else
    print_error "No se pudo instalar Node.js automáticamente"
    print_warn "Instala manualmente desde: https://nodejs.org/"
  fi
fi

# Verificar npm
if command -v npm &> /dev/null; then
  NPM_VERSION=$(npm -v)
  print_ok "npm $NPM_VERSION"
else
  print_error "npm no encontrado"
  exit 1
fi

# ============ 3. INSTALAR SQLITE ============

print_header "3. Verificando SQLite"

if command -v sqlite3 &> /dev/null; then
  SQLITE_VERSION=$(sqlite3 --version | awk '{print $1}')
  print_ok "SQLite ya instalado: $SQLITE_VERSION"
else
  print_warn "SQLite no encontrado, instalando..."

  if [ "$OS" = "linux" ]; then
    apt-get update -y > /dev/null 2>&1 || true
    apt-get install -y sqlite3 > /dev/null 2>&1
    print_ok "SQLite instalado (apt)"
  elif [ "$OS" = "macos" ]; then
    print_error "SQLite no instalado. Ejecuta: brew install sqlite"
  else
    print_error "No se pudo instalar SQLite automáticamente"
  fi
fi

# ============ 4. INSTALAR DEPENDENCIAS NPM ============

print_header "4. Instalando Dependencias npm"

if [ ! -d "web/node_modules" ]; then
  print_warn "node_modules no existe, instalando..."
  cd web

  if npm install > /dev/null 2>&1; then
    print_ok "Dependencias instaladas"
  else
    print_error "Error instalando dependencias npm"
    print_warn "Intenta manualmente: cd web && npm install"
    ((ERRORS++))
  fi

  cd ..
else
  print_ok "node_modules ya existe"
fi

# ============ 5. CREAR DIRECTORIOS ============

print_header "5. Preparando Directorios"

WORKSPACE=${WORKSPACE:-/workspace}
DATA_DIR="$WORKSPACE/data"

mkdir -p "$DATA_DIR" 2>/dev/null || true
print_ok "Directorio $DATA_DIR"

# ============ 6. INICIALIZAR BDS ============

print_header "6. Inicializando Bases de Datos"

init_db() {
  local lab_id=$1
  local db_path="$DATA_DIR/$lab_id.db"
  local init_sql="labs/$lab_id/init.sql"

  if [ ! -f "$init_sql" ]; then
    print_warn "$init_sql no encontrado"
    return 1
  fi

  # Borrar BD anterior si existe pero está vacía
  if [ -f "$db_path" ]; then
    TABLE_COUNT=$(sqlite3 "$db_path" "SELECT COUNT(*) FROM sqlite_master WHERE type='table';" 2>/dev/null || echo "0")
    if [ "$TABLE_COUNT" -eq 0 ]; then
      rm "$db_path"
    fi
  fi

  # Crear BD
  if [ ! -f "$db_path" ]; then
    if sqlite3 "$db_path" < "$init_sql" 2>/dev/null; then
      print_ok "$lab_id inicializado"
      return 0
    else
      print_error "$lab_id fallo al inicializar"
      return 1
    fi
  else
    print_ok "$lab_id ya existe"
    return 0
  fi
}

init_db "01-basics" || ((ERRORS++))
init_db "02-joins" || ((ERRORS++))
init_db "03-aggregates" || ((ERRORS++))

# ============ 7. VERIFICAR INSTALACION ============

print_header "7. Verificando Instalación"

CHECKS_OK=0
CHECKS_FAIL=0

# Verificar structure
for dir in "labs" ".devcontainer" "web"; do
  if [ -d "$dir" ]; then
    print_ok "Carpeta $dir"
    ((CHECKS_OK++))
  else
    print_error "Carpeta $dir no existe"
    ((CHECKS_FAIL++))
  fi
done

# Verificar archivo key
for file in "web/server.js" "web/public/index.html"; do
  if [ -f "$file" ]; then
    print_ok "$file"
    ((CHECKS_OK++))
  else
    print_error "$file no existe"
    ((CHECKS_FAIL++))
  fi
done

# Verificar BDs
for lab in "01-basics" "02-joins" "03-aggregates"; do
  db_path="$DATA_DIR/$lab.db"
  if [ -f "$db_path" ]; then
    TABLE_COUNT=$(sqlite3 "$db_path" "SELECT COUNT(*) FROM sqlite_master WHERE type='table';" 2>/dev/null || echo "0")
    if [ "$TABLE_COUNT" -gt 0 ]; then
      print_ok "$lab.db ($TABLE_COUNT tablas)"
      ((CHECKS_OK++))
    else
      print_warn "$lab.db vacía"
      ((CHECKS_FAIL++))
    fi
  else
    print_warn "$lab.db no existe"
    ((CHECKS_FAIL++))
  fi
done

# ============ 8. CREAR .progress.json ============

print_header "8. Inicializando Progreso"

PROGRESS_FILE="$WORKSPACE/.progress.json"
if [ ! -f "$PROGRESS_FILE" ]; then
  mkdir -p "$(dirname "$PROGRESS_FILE")" 2>/dev/null || true
  echo '{"started": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'", "labs": {}}' > "$PROGRESS_FILE"
  print_ok "Progreso inicializado"
else
  print_ok "Progreso ya existe"
fi

# ============ 9. CREAR .env (opcional) ============

print_header "9. Configuración"

if [ ! -f "web/.env" ]; then
  echo "WORKSPACE=$WORKSPACE" > "web/.env"
  echo "PORT=3000" >> "web/.env"
  print_ok "web/.env creado"
else
  print_ok "web/.env ya existe"
fi

# ============ RESUMEN ============

print_header "RESUMEN"

echo "Instalación completada:"
echo "  Sistema: $OS"
echo "  Node.js: $(node -v 2>/dev/null || echo 'no encontrado')"
echo "  npm: $(npm -v 2>/dev/null || echo 'no encontrado')"
echo "  SQLite: $(sqlite3 --version 2>/dev/null | awk '{print $1}' || echo 'no encontrado')"
echo "  Verificaciones OK: $CHECKS_OK"
echo "  Verificaciones Fallo: $CHECKS_FAIL"
echo "  Errores: $ERRORS"
echo "  Advertencias: $WARNINGS"

# ============ RESULTADO FINAL ============

if [ $ERRORS -eq 0 ]; then
  echo -e "\n${GREEN}Listo. Puedes arrancar con:${NC}"
  echo ""
  echo "  cd web"
  echo "  npm start"
  echo ""
  echo "Luego abre: http://localhost:3000"
  echo ""
  exit 0
else
  echo -e "\n${RED}Hay $ERRORS errores. Revisa arriba.${NC}"
  echo ""
  echo "Intenta:"
  echo "  1. Instala Node.js manualmente"
  echo "  2. Instala SQLite manualmente"
  echo "  3. Ejecuta este script nuevamente"
  echo ""
  exit 1
fi

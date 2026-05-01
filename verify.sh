#!/bin/bash

set -e

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== SQL Lab Verification Script ===${NC}\n"

ERRORS=0
WARNINGS=0

# Helper functions
check_pass() {
  echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
  echo -e "${RED}✗${NC} $1"
  ((ERRORS++))
}

check_warn() {
  echo -e "${YELLOW}!${NC} $1"
  ((WARNINGS++))
}

# 1. Verificar estructura de carpetas
echo -e "${BLUE}1. Estructura de carpetas${NC}"
if [ -d "labs" ]; then
  check_pass "Carpeta 'labs' existe"
else
  check_fail "Carpeta 'labs' no encontrada"
fi

if [ -d ".devcontainer" ]; then
  check_pass "Carpeta '.devcontainer' existe"
else
  check_fail "Carpeta '.devcontainer' no encontrada"
fi

if [ -d "web" ]; then
  check_pass "Carpeta 'web' existe"
else
  check_fail "Carpeta 'web' no encontrada"
fi

# 2. Verificar labs
echo -e "\n${BLUE}2. Labs${NC}"
for lab_id in 01-basics 02-joins 03-aggregates; do
  if [ -d "labs/$lab_id" ]; then
    check_pass "Lab '$lab_id' existe"

    # Verificar archivos del lab
    files=("instructions.md" "init.sql" "check.sh" "hints.json")
    for file in "${files[@]}"; do
      if [ -f "labs/$lab_id/$file" ]; then
        check_pass "  - $file existe"
      else
        check_fail "  - $file NO existe"
      fi
    done
  else
    check_fail "Lab '$lab_id' no encontrado"
  fi
done

# 3. Verificar JSON validity
echo -e "\n${BLUE}3. Validez de JSON${NC}"
for hints_file in labs/*/hints.json; do
  if [ -f "$hints_file" ]; then
    if python3 -m json.tool "$hints_file" > /dev/null 2>&1; then
      check_pass "$hints_file es JSON válido"
    else
      check_fail "$hints_file tiene JSON inválido"
    fi
  fi
done

# 4. Verificar Node.js
echo -e "\n${BLUE}4. Node.js y dependencias${NC}"
if command -v node &> /dev/null; then
  NODE_VERSION=$(node -v)
  check_pass "Node.js instalado: $NODE_VERSION"
else
  check_fail "Node.js NO instalado"
fi

if [ -f "web/package.json" ]; then
  check_pass "web/package.json existe"
else
  check_fail "web/package.json NO existe"
fi

if [ -d "web/node_modules" ]; then
  check_pass "web/node_modules existe (dependencias instaladas)"
else
  check_warn "web/node_modules NO existe - ejecuta: cd web && npm install"
fi

# 5. Verificar servidor web
echo -e "\n${BLUE}5. Servidor web${NC}"
if [ -f "web/server.js" ]; then
  check_pass "web/server.js existe"

  # Verificar syntax de JavaScript
  if node -c web/server.js 2>/dev/null; then
    check_pass "web/server.js tiene sintaxis válida"
  else
    check_fail "web/server.js tiene errores de sintaxis"
  fi
else
  check_fail "web/server.js NO existe"
fi

# 6. Verificar archivos públicos
echo -e "\n${BLUE}6. Archivos públicos (web/public)${NC}"
PUBLIC_FILES=("index.html" "css/app.css" "js/app.js" "js/ui.js" "js/editor.js")
for file in "${PUBLIC_FILES[@]}"; do
  if [ -f "web/public/$file" ]; then
    check_pass "$file existe"
  else
    check_fail "$file NO existe"
  fi
done

# 7. Verificar puerto 3000
echo -e "\n${BLUE}7. Puerto 3000${NC}"
if command -v lsof &> /dev/null; then
  if lsof -i :3000 > /dev/null 2>&1; then
    check_warn "Puerto 3000 ya está en uso"
  else
    check_pass "Puerto 3000 está disponible"
  fi
elif command -v netstat &> /dev/null; then
  if netstat -tuln | grep -q ":3000 "; then
    check_warn "Puerto 3000 ya está en uso"
  else
    check_pass "Puerto 3000 está disponible"
  fi
else
  check_warn "No se pudo verificar puerto 3000 (lsof/netstat no disponibles)"
fi

# 8. Verificar SQLite
echo -e "\n${BLUE}8. SQLite${NC}"
if command -v sqlite3 &> /dev/null; then
  SQLITE_VERSION=$(sqlite3 --version | awk '{print $1}')
  check_pass "SQLite instalado: $SQLITE_VERSION"
else
  check_fail "SQLite NO instalado"
fi

# 9. Verificar BDs
echo -e "\n${BLUE}9. Bases de datos${NC}"
DATA_DIR="/workspace/data"
if [ -d "$DATA_DIR" ]; then
  check_pass "Directorio $DATA_DIR existe"
  for lab_id in 01-basics 02-joins 03-aggregates; do
    if [ -f "$DATA_DIR/$lab_id.db" ]; then
      check_pass "$lab_id.db existe"
    else
      check_warn "$lab_id.db NO existe - ejecuta: bash .devcontainer/setup.sh"
    fi
  done
else
  check_warn "Directorio $DATA_DIR NO existe - ejecuta: bash .devcontainer/setup.sh"
fi

# 10. Verificar .gitignore
echo -e "\n${BLUE}10. Configuración (.gitignore)${NC}"
if [ -f ".gitignore" ]; then
  check_pass ".gitignore existe"
  if grep -q "CLAUDE.md" .gitignore; then
    check_pass "CLAUDE.md está en .gitignore"
  else
    check_fail "CLAUDE.md NO está en .gitignore"
  fi
  if grep -q "*.db" .gitignore; then
    check_pass "*.db está en .gitignore"
  else
    check_fail "*.db NO está en .gitignore"
  fi
else
  check_fail ".gitignore NO existe"
fi

# Resumen
echo -e "\n${BLUE}=== RESUMEN ===${NC}"
echo -e "Errores: ${RED}$ERRORS${NC}"
echo -e "Advertencias: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}Verificación OK - Todo correcto${NC}"
  exit 0
else
  echo -e "${RED}Se encontraron $ERRORS errores - Revisa arriba${NC}"
  exit 1
fi

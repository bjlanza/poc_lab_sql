#!/bin/bash

DB="/workspace/data/01-basics.db"
PASS=0
FAIL=0

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check() {
  local desc="$1"
  local result="$2"
  local expected="$3"
  local hint="$4"

  if [ "$result" = "$expected" ]; then
    echo -e "${GREEN}✅ PASS${NC}: $desc"
    ((PASS++))
  else
    echo -e "${RED}❌ FAIL${NC}: $desc"
    echo "   Esperado: $expected"
    echo "   Obtenido: $result"
    if [ -n "$hint" ]; then
      echo -e "   ${YELLOW}💡 Pista${NC}: $hint"
    fi
    ((FAIL++))
  fi
}

echo "🧪 Validando Lab 01..."
echo ""

# Tarea 2: existe la tabla departments
TABLE=$(sqlite3 $DB "SELECT name FROM sqlite_master WHERE type='table' AND name='departments';")
check "Tabla 'departments' existe" "$TABLE" "departments" "Usa CREATE TABLE departments (...)"

# Tarea 3: tiene 3 registros
COUNT=$(sqlite3 $DB "SELECT COUNT(*) FROM departments;")
check "departments tiene 3 registros" "$COUNT" "3" "Deberías tener 3 INSERT INTO statements"

# Tarea 3: contiene Engineering
ENG=$(sqlite3 $DB "SELECT COUNT(*) FROM departments WHERE name='Engineering';")
check "departments contiene 'Engineering'" "$ENG" "1" "Verifica la ortografía: 'Engineering'"

# Tarea 3: contiene Marketing
MKT=$(sqlite3 $DB "SELECT COUNT(*) FROM departments WHERE name='Marketing';")
check "departments contiene 'Marketing'" "$MKT" "1" "Verifica la ortografía: 'Marketing'"

# Tarea 3: contiene HR
HR=$(sqlite3 $DB "SELECT COUNT(*) FROM departments WHERE name='HR';")
check "departments contiene 'HR'" "$HR" "1" "Verifica la ortografía: 'HR'"

echo ""
echo "────────────────────────────────────────"
echo "Resultado: $PASS pasadas, $FAIL falladas"
echo "────────────────────────────────────────"

if [ $FAIL -eq 0 ]; then
  echo ""
  echo -e "${GREEN}🎉 ¡Lab completado!${NC}"
  exit 0
else
  echo ""
  echo -e "${YELLOW}📝 Aún hay tareas pendientes. Revisa los errores arriba.${NC}"
  exit 1
fi

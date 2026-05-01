#!/bin/bash

DB="/workspace/data/02-joins.db"
PASS=0
FAIL=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

echo "🧪 Validando Lab 02..."
echo ""

# Tarea 3: existe la vista employee_report
VIEW=$(sqlite3 $DB "SELECT name FROM sqlite_master WHERE type='view' AND name='employee_report';")
check "Vista 'employee_report' existe" "$VIEW" "employee_report" "Usa CREATE VIEW employee_report AS ..."

# Validar estructura: debe tener 3 columnas
COLS=$(sqlite3 $DB "PRAGMA table_info(employee_report);" | wc -l)
check "Vista tiene 3 columnas" "$COLS" "3" "Deberías seleccionar: name, dept, salary"

echo ""
echo "────────────────────────────────────────"
echo "Resultado: $PASS pasadas, $FAIL falladas"
echo "────────────────────────────────────────"

if [ $FAIL -eq 0 ]; then
  echo ""
  echo -e "${GREEN}🎉 ¡Lab 02 completado!${NC}"
  exit 0
else
  echo ""
  echo -e "${YELLOW}📝 Aún hay tareas pendientes.${NC}"
  exit 1
fi

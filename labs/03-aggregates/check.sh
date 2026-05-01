#!/bin/bash

DB="/workspace/data/03-aggregates.db"
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

echo "🧪 Validando Lab 03..."
echo ""

# Tarea 4: existe la tabla dept_summary
TABLE=$(sqlite3 $DB "SELECT name FROM sqlite_master WHERE type='table' AND name='dept_summary';")
check "Tabla 'dept_summary' existe" "$TABLE" "dept_summary" "Usa CREATE TABLE dept_summary AS ..."

# Validar estructura: debe tener 4 columnas
COLS=$(sqlite3 $DB "PRAGMA table_info(dept_summary);" | grep -c "^")
check "dept_summary tiene 4 columnas" "$COLS" "4" "Columnas: dept_id, total_employees, avg_salary, max_salary"

# Validar datos: debe tener un registro por departamento (4 depts)
ROWS=$(sqlite3 $DB "SELECT COUNT(*) FROM dept_summary;")
check "dept_summary tiene 4 registros (un por dept)" "$ROWS" "4" "Agrupa por departamento correctamente"

# Validar que Engineering tiene 3 empleados
ENG_COUNT=$(sqlite3 $DB "SELECT total_employees FROM dept_summary WHERE dept_id=1;")
check "Engineering tiene 3 empleados" "$ENG_COUNT" "3" "Verifica el GROUP BY"

echo ""
echo "────────────────────────────────────────"
echo "Resultado: $PASS pasadas, $FAIL falladas"
echo "────────────────────────────────────────"

if [ $FAIL -eq 0 ]; then
  echo ""
  echo -e "${GREEN}🎉 ¡Lab 03 completado!${NC}"
  exit 0
else
  echo ""
  echo -e "${YELLOW}📝 Aún hay tareas pendientes.${NC}"
  exit 1
fi

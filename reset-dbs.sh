#!/bin/bash

# Reset DBs - Reinicializa todas las bases de datos

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

WORKSPACE=${WORKSPACE:-/workspace}
DATA_DIR="$WORKSPACE/data"
LABS_DIR="$(pwd)/labs"

echo -e "${BLUE}=== Reinicializando Bases de Datos ===${NC}\n"

# Crear directorio si no existe
mkdir -p "$DATA_DIR"
echo -e "${GREEN}OK${NC} Directorio $DATA_DIR existe\n"

# Reinicializar cada lab
for lab_dir in "$LABS_DIR"/*/; do
  lab_name=$(basename "$lab_dir")
  db_path="$DATA_DIR/$lab_name.db"

  if [ -f "${lab_dir}init.sql" ]; then
    echo "Inicializando: $lab_name"

    # Borrar BD anterior si existe
    if [ -f "$db_path" ]; then
      rm "$db_path"
      echo "  - BD anterior eliminada"
    fi

    # Crear nueva BD con datos iniciales
    sqlite3 "$db_path" < "${lab_dir}init.sql"
    echo -e "  ${GREEN}OK${NC} $db_path creada\n"
  else
    echo -e "${RED}SKIP${NC} $lab_name (no tiene init.sql)\n"
  fi
done

# Verificar que se crearon
echo "Verificando..."
for lab in 01-basics 02-joins 03-aggregates; do
  if [ -f "$DATA_DIR/$lab.db" ]; then
    echo -e "${GREEN}✓${NC} $lab.db"
  else
    echo -e "${RED}✗${NC} $lab.db NO existe"
  fi
done

echo -e "\n${GREEN}Listo. Bases de datos reinicializadas.${NC}"

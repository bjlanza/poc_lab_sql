#!/bin/bash

# Lab Runner - Navega entre labs y gestiona progreso

DATA_DIR="/workspace/data"
PROGRESS_FILE="/workspace/.progress.json"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_menu() {
  clear
  echo -e "${BLUE}╔═══════════════════════════════════╗${NC}"
  echo -e "${BLUE}║     SQL LAB - LABORATORIO SQL     ║${NC}"
  echo -e "${BLUE}╚═══════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}Laboratorios Disponibles:${NC}"
  echo ""
  echo "  1) ${GREEN}01-basics${NC}      - SELECT, WHERE, CREATE TABLE (Principiante, 10 min)"
  echo "  2) ${GREEN}02-joins${NC}       - JOINS, VIEWS (Intermedio, 15 min)"
  echo "  3) ${GREEN}03-aggregates${NC}  - GROUP BY, COUNT, SUM, AVG (Intermedio, 20 min)"
  echo ""
  echo -e "${YELLOW}Opciones:${NC}"
  echo "  4) Ver progreso"
  echo "  5) Resetear todas las BDs"
  echo "  6) Salir"
  echo ""
  echo -n "Selecciona una opción [1-6]: "
}

run_lab() {
  local lab_name=$1
  local lab_dir="labs/$lab_name"
  local db_path="$DATA_DIR/$lab_name.db"

  if [ ! -f "$lab_dir/instructions.md" ]; then
    echo -e "${RED}❌ Lab no encontrado: $lab_dir${NC}"
    sleep 2
    return
  fi

  clear
  echo -e "${BLUE}╔═══════════════════════════════════╗${NC}"
  echo -e "${BLUE}║     LAB: $lab_name${NC}"
  echo -e "${BLUE}╚═══════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}Instrucciones:${NC}"
  echo ""
  cat "$lab_dir/instructions.md"
  echo ""
  echo "────────────────────────────────────"
  echo ""
  echo -e "${YELLOW}Próximos pasos:${NC}"
  echo "1. Abre otra terminal (Ctrl + \` nuevamente)"
  echo "2. Ejecuta: sqlite3 $db_path"
  echo "3. Escribe tus consultas SQL"
  echo "4. Cuando termines: bash $lab_dir/check.sh"
  echo ""
  echo -n "Presiona Enter para continuar..."
  read
}

show_progress() {
  clear
  echo -e "${BLUE}╔═══════════════════════════════════╗${NC}"
  echo -e "${BLUE}║            PROGRESO              ║${NC}"
  echo -e "${BLUE}╚═══════════════════════════════════╝${NC}"
  echo ""

  if [ -f "$PROGRESS_FILE" ]; then
    cat "$PROGRESS_FILE" | python3 -m json.tool 2>/dev/null || cat "$PROGRESS_FILE"
  else
    echo -e "${YELLOW}No hay progreso aún. Completa un lab para registrar progreso.${NC}"
  fi

  echo ""
  echo -n "Presiona Enter para volver..."
  read
}

reset_labs() {
  echo ""
  echo -e "${YELLOW}⚠️  Esto va a resetear todas las bases de datos.${NC}"
  echo -n "¿Estás seguro? (s/n): "
  read response

  if [ "$response" = "s" ] || [ "$response" = "S" ]; then
    echo -e "${YELLOW}Reseteando...${NC}"
    bash .devcontainer/setup.sh
    echo -e "${GREEN}✅ BDs reseteadas${NC}"
  else
    echo -e "${YELLOW}Cancelado${NC}"
  fi

  sleep 2
}

# Main loop
while true; do
  show_menu
  read choice

  case $choice in
    1)
      run_lab "01-basics"
      ;;
    2)
      run_lab "02-joins"
      ;;
    3)
      run_lab "03-aggregates"
      ;;
    4)
      show_progress
      ;;
    5)
      reset_labs
      ;;
    6)
      echo -e "${GREEN}¡Hasta pronto! 👋${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Opción no válida${NC}"
      sleep 1
      ;;
  esac
done

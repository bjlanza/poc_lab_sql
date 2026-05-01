#!/bin/bash

# Script de inicio para SQL Lab Web UI

set -e

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== SQL Lab Startup ===${NC}\n"

# 1. Verificar estructura básica
echo "Verificando estructura..."

if [ ! -d "web" ]; then
  echo -e "${RED}Error: Carpeta 'web' no encontrada${NC}"
  exit 1
fi

if [ ! -d "labs" ]; then
  echo -e "${RED}Error: Carpeta 'labs' no encontrada${NC}"
  exit 1
fi

echo -e "${GREEN}OK${NC} Estructura encontrada\n"

# 2. Instalar dependencias si es necesario
if [ ! -d "web/node_modules" ]; then
  echo "Instalando dependencias npm..."
  cd web
  npm install
  cd ..
  echo -e "${GREEN}OK${NC} Dependencias instaladas\n"
else
  echo -e "${GREEN}OK${NC} Dependencias ya instaladas\n"
fi

# 3. Verificar/crear BDs
echo "Verificando bases de datos..."
if [ ! -d "/workspace/data" ] || [ ! -f "/workspace/data/01-basics.db" ]; then
  echo "Inicializando bases de datos..."
  bash reset-dbs.sh
  echo -e "${GREEN}OK${NC} BDs inicializadas\n"
else
  # Verificar que 01-basics tiene tabla employees
  TABLE_COUNT=$(sqlite3 /workspace/data/01-basics.db "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='employees';" 2>/dev/null || echo "0")
  if [ "$TABLE_COUNT" -eq 0 ]; then
    echo "Reinicializando bases de datos (tablas faltantes)..."
    bash reset-dbs.sh
    echo -e "${GREEN}OK${NC} BDs reinicializadas\n"
  else
    echo -e "${GREEN}OK${NC} BDs ya existen y están inicializadas\n"
  fi
fi

# 4. Verificar puerto
PORT=${PORT:-3000}
if command -v lsof &> /dev/null; then
  if lsof -i :$PORT > /dev/null 2>&1; then
    echo -e "${YELLOW}Advertencia${NC}: Puerto $PORT ya está en uso"
    echo "Usa: PORT=3001 bash start.sh para cambiar puerto"
    exit 1
  fi
fi

# 5. Iniciar servidor
echo -e "${BLUE}=== Iniciando SQL Lab ===${NC}\n"
echo "Servidor en http://localhost:$PORT"
echo "Presiona Ctrl+C para detener\n"

cd web
PORT=$PORT npm start

#!/bin/bash

# SQL Lab - Inicialización Directa
# Instala Node.js, SQLite, dependencias y arranca

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== SQL Lab Init ===${NC}\n"

# 1. Instalar Node.js
echo "Instalando Node.js..."
apt-get update
apt-get install -y nodejs npm
echo -e "${GREEN}OK${NC} Node.js instalado\n"

# 2. Instalar SQLite
echo "Instalando SQLite..."
apt-get install -y sqlite3
echo -e "${GREEN}OK${NC} SQLite instalado\n"

# 3. Crear directorios
echo "Creando directorios..."
mkdir -p /workspace/data
mkdir -p /workspace/labs
echo -e "${GREEN}OK${NC} Directorios creados\n"

# 4. Instalar dependencias npm
echo "Instalando npm dependencies..."
cd web
npm install
cd ..
echo -e "${GREEN}OK${NC} Dependencias instaladas\n"

# 5. Inicializar BDs
echo "Inicializando bases de datos..."
sqlite3 /workspace/data/01-basics.db < labs/01-basics/init.sql
sqlite3 /workspace/data/02-joins.db < labs/02-joins/init.sql
sqlite3 /workspace/data/03-aggregates.db < labs/03-aggregates/init.sql
echo -e "${GREEN}OK${NC} BDs inicializadas\n"

# 6. Crear progress file
echo "Creando progress file..."
echo '{"started": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'", "labs": {}}' > /workspace/.progress.json
echo -e "${GREEN}OK${NC} Progress file creado\n"

# 7. Arrancar
echo -e "${BLUE}=== Iniciando SQL Lab ===${NC}\n"
echo "Servidor en http://localhost:3000"
echo "Presiona Ctrl+C para detener\n"

cd web
npm start

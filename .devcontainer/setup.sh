#!/bin/bash
set -e

echo "🔧 Configurando SQL Lab..."

# Actualizar repositorios e instalar SQLite + Node.js
apt-get update -y
apt-get install -y sqlite3 nodejs npm

# Crear carpeta de datos
mkdir -p /workspace/data

# Instalar dependencias del servidor web
echo "📦 Instalando dependencias de la web UI..."
cd /workspace/web && npm install

# Inicializar cada lab
echo "📚 Inicializando laboratorios..."

for lab_dir in /workspace/labs/*/; do
  lab_name=$(basename "$lab_dir")
  if [ -f "${lab_dir}init.sql" ]; then
    echo "  ⚙️  Lab: $lab_name"
    sqlite3 "/workspace/data/${lab_name}.db" < "${lab_dir}init.sql"
  fi
done

# Crear .progress.json si no existe
if [ ! -f "/workspace/.progress.json" ]; then
  echo '{"started": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'", "labs": {}}' > /workspace/.progress.json
fi

echo ""
echo "✅ Setup completado!"
echo "👉 Para comenzar, lee: README.md"

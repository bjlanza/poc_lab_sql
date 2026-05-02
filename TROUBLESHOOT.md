# SQL Lab - Troubleshooting

## "No aparecen los laboratorios"

Si la web abre pero la sidebar está vacía ("Selecciona un lab"), es que falta inicialización.

### Solución Rápida

Abre terminal y ejecuta:

```bash
python3 init.py
```

Esto instala todo desde cero.

Luego en otra terminal:

```bash
cd web
npm start
```

Abre http://localhost:3000

---

## Diagnóstico

Para saber qué está mal:

```bash
python3 diagnose.py
```

Mostrará exactamente qué falta y cómo arreglarlo.

---

## Problemas Comunes

### 1. "npm: command not found"

Node.js no está instalado.

```bash
python3 init.py
```

Instala Node.js automáticamente.

### 2. "Cannot find module 'express'"

npm dependencies no se instalaron.

```bash
cd web
npm install
cd ..
```

### 3. "Parse error: no such table"

BDs no fueron inicializadas.

```bash
python3 init.py
```

Crea e inicializa todas las BDs.

### 4. "Port 3000 already in use"

Otra aplicación usa el puerto.

```bash
PORT=3001 npm start
```

O mata el proceso:

```bash
lsof -i :3000
kill -9 <PID>
npm start
```

### 5. "Selecciona un lab" (Web abre pero sin labs)

El servidor no está sirviendo bien los labs.

```bash
# 1. Diagnóstico
python3 diagnose.py

# 2. Si dice "node_modules NO existe"
cd web
npm install
cd ..

# 3. Si dice "BDs NO existen"
python3 init.py

# 4. Reinicia servidor
cd web
npm start
```

---

## En Codespaces

Si postCreateCommand falló, soluciona manualmente:

```bash
# 1. Terminal nueva
python3 init.py

# 2. Espera a que termine
# Debe ver: "Instalación Completada"

# 3. En otra terminal:
cd web
npm start

# 4. Abre http://localhost:3000
```

---

## Paso a Paso para Arreglarlo

### Opción A: Automático (Recomendado)

```bash
python3 init.py
```

Listo. Instala todo.

### Opción B: Paso a Paso Manual

```bash
# 1. Instalar Node.js
sudo apt-get install nodejs npm

# 2. Instalar SQLite
sudo apt-get install sqlite3

# 3. Instalar npm dependencies
cd web
npm install
cd ..

# 4. Inicializar BDs
sqlite3 /workspace/data/01-basics.db < labs/01-basics/init.sql
sqlite3 /workspace/data/02-joins.db < labs/02-joins/init.sql
sqlite3 /workspace/data/03-aggregates.db < labs/03-aggregates/init.sql

# 5. Crear progress
echo '{"started": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'", "labs": {}}' > /workspace/.progress.json

# 6. Arrancar
cd web
npm start
```

---

## Verificar que Está Bien

```bash
# Todos estos comandos deben funcionar:

node --version
npm --version
sqlite3 --version

# BDs deben tener tablas:
sqlite3 /workspace/data/01-basics.db "SELECT COUNT(*) FROM sqlite_master WHERE type='table';"
# Debe mostrar: 1 (la tabla employees)

# Verificar que server.js no tiene errores:
node -c web/server.js
# Debe mostrar: OK
```

---

## Ver Logs

Si algo falla durante init.py:

```bash
# Ver último setup
cat /tmp/setup.log

# O reinicia y captura output:
python3 init.py 2>&1 | tee setup.log
```

---

## Reset Completo

Si todo está roto:

```bash
# 1. Borrar BDs
rm -f /workspace/data/*.db

# 2. Borrar npm dependencies
rm -rf web/node_modules

# 3. Reinicializar
python3 init.py

# 4. Arrancar
cd web
npm start
```

---

## Información Útil

**Logs del servidor:**

Cuando corre `npm start`, verás:

```
> npm start

> sql-lab-web@1.0.0 start
> node server.js

✓ SQL Lab Web UI corriendo en http://localhost:3000
📁 Data directory: /workspace/data
  📚 Labs disponibles:
     - 01-basics: SELECT y WHERE
     - 02-joins: JOINS y VIEWS
     - 03-aggregates: Funciones de Agregación
```

Si no ves esto, algo falló.

**DevTools del navegador:**

- Abre F12
- Mira Console (errores JavaScript)
- Mira Network (errores de API)

---

## Última Opción: Empezar de Cero

```bash
# En Codespaces: Recrear
Click: ... → Rebuild container

# Local:
python3 init.py
```

Eso reinstala todo desde cero.

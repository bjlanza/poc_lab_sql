# SQL Lab - Quick Fix

Si la web no funciona o no aparecen los labs:

## Paso 1: Diagnóstico

```bash
python3 diagnose.py
```

Mostrará exactamente qué falta.

## Paso 2: Arreglarlo

Opción A (Automático):

```bash
python3 init.py
```

Opción B (Manual):

```bash
# Instalar dependencias
cd web
npm install
cd ..

# Inicializar BDs
sqlite3 /workspace/data/01-basics.db < labs/01-basics/init.sql
sqlite3 /workspace/data/02-joins.db < labs/02-joins/init.sql
sqlite3 /workspace/data/03-aggregates.db < labs/03-aggregates/init.sql
```

## Paso 3: Arrancar

```bash
cd web
npm start
```

Abre http://localhost:3000

---

## Errores Específicos

| Error | Solución |
|-------|----------|
| "npm: command not found" | `python3 init.py` |
| "sqlite3: command not found" | `python3 init.py` |
| "Cannot find module" | `cd web && npm install` |
| "no such table" | `python3 init.py` |
| "Port 3000 in use" | `PORT=3001 npm start` |
| "No aparecen labs" | `python3 diagnose.py` luego `python3 init.py` |

---

## Reset Total

```bash
# Borrar todo
rm -rf web/node_modules /workspace/data/*.db /workspace/.progress.json

# Reinstalar
python3 init.py

# Arrancar
cd web
npm start
```

---

Más detalles: `TROUBLESHOOT.md`

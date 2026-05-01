# Web UI - Guía Rápida

## En GitHub Codespaces (Recomendado)

```
✅ Automatizado completamente
```

1. Abre el repositorio en Codespaces
2. Espera a ver: `✅ SQL Lab Web UI corriendo en http://localhost:3000`
3. Click en el puerto 3000 → abre navegador automáticamente
4. ¡Listo! Comienza a resolver labs

---

## En Local (Linux/Mac)

```bash
# 1. Clonar repo
git clone <repo>
cd sql-lab/web

# 2. Instalar dependencias
npm install

# 3. Inicializar BDs (desde raíz del repo)
cd ..
bash .devcontainer/setup.sh
cd web

# 4. Iniciar servidor
npm start

# 5. Abre navegador
http://localhost:3000
```

---

## En Local (Windows + PowerShell)

```powershell
# Similar a Linux, pero:
# - Node.js debe estar instalado (nodejs.org)
# - SQLite debe estar en PATH

npm install
# ... desde raíz del repo ...
bash .devcontainer/setup.sh
# ... volver a web ...
npm start
```

---

## Troubleshooting

**Puerto 3000 en uso:**
```bash
PORT=3001 npm start
```

**Error de BDs:**
```bash
# Desde raíz:
bash .devcontainer/setup.sh

# Verifica que existen:
ls -la /workspace/data/
# Debería mostrar: 01-basics.db, 02-joins.db, 03-aggregates.db
```

**Error de dependencias:**
```bash
npm install
npm start
```

---

## Features de la Web UI

| Feature | Acceso |
|---------|--------|
| Instrucciones Markdown | Panel izquierdo (scrollable) |
| Editor SQL | Panel derecho superior + Ctrl+Enter |
| Resultados en tabla | Panel derecho intermedio |
| Validación (PASS/FAIL) | Panel derecho inferior, click "Verificar ✓" |
| Cambiar lab | Click en sidebar izquierdo o nav superior |
| Resetear BDs | Click 🔄 en header |

---

## Stack

- **Backend**: Node.js + Express.js + better-sqlite3
- **Frontend**: HTML + CSS + JavaScript vanilla (sin frameworks)
- **Editor**: Monaco Editor (VSCode) vía CDN
- **Markdown**: marked.js vía CDN

**Sin build step**, todo funciona directo en navegador + servidor.

---

Más detalles en [README.md](README.md)

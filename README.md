# SQL Lab - Laboratorio de SQL Interactivo

Bienvenido a **SQL Lab**, un entorno de laboratorio interactivo para aprender SQL con validación automática.

## 🚀 Inicio Rápido

### Opción 1: Web UI (Recomendado) 🎨

1. **Abre en Codespaces**: El setup se ejecuta automáticamente
2. **Espera a que se inicie**: Verás en la terminal `✅ SQL Lab Web UI corriendo en http://localhost:3000`
3. **Abre el navegador**: Ve a `http://localhost:3000`
4. **Selecciona un lab**: Haz click en la sidebar
5. **Escribe SQL**: En el editor central
6. **Verifica**: Click en "Verificar ✓"

### Opción 2: Terminal (CLI Tradicional) 💻

1. **Abre en Codespaces**: El setup se ejecuta automáticamente
2. **Lee las instrucciones**: `cat labs/01-basics/instructions.md`
3. **Abre la terminal**: `Ctrl + `` (o View > Terminal)
4. **Abre la BD**: `sqlite3 /workspace/data/01-basics.db`
5. **Escribe consultas SQL**: `SELECT ...`
6. **Valida tu trabajo**: `bash labs/01-basics/check.sh`

---

## 🎨 Interfaz Web (LabEx-style)

La **Web UI** está disponible en `http://localhost:3000` en Codespaces.

**Características:**
- 📝 **Split View**: Instrucciones a la izquierda, editor a la derecha
- 📊 **Resultados en tiempo real**: Tablas renderizadas automáticamente
- ✅ **Validación interactiva**: Hints y feedback instantáneo
- 🎯 **Progreso guardado**: Se persiste en `.progress.json`
- 🔄 **Editor integrado**: Monaco (el mismo de VSCode)

**Layout:**
```
┌─ Header (nav entre labs) ────────────┐
├─ Sidebar │ Instrucciones │ Editor ──┤
│   Labs   │   (Markdown)  │  SQL    │
│  ├─01 ✅ │               │ + Botones
│  ├─02 🔵 │               ├─ Resultados
│  └─03 ⬜ │               │  (Tabla)
│          │               ├─ Validación
│          │               │  (PASS/FAIL)
└──────────┴───────────────┴──────────┘
```

Para más detalles, ver [web/README.md](web/README.md).

---

## 📚 Laboratorios Disponibles

| Lab | Tema | Nivel | Duración |
|-----|------|-------|----------|
| **01-basics** | SELECT, WHERE, CREATE TABLE | Principiante | 10 min |
| **02-joins** | INNER JOIN, LEFT JOIN, VIEWS | Intermedio | 15 min |
| **03-aggregates** | GROUP BY, COUNT, SUM, AVG | Intermedio | 20 min |

---

## 🧪 Flujo de Trabajo

### Para cada laboratorio:

```bash
# 1. Lee las instrucciones
cat labs/01-basics/instructions.md

# 2. Abre la base de datos correspondiente
sqlite3 /workspace/data/01-basics.db

# 3. En sqlite3, escribe tus consultas
sqlite> SELECT * FROM employees;
sqlite> CREATE TABLE departments (...);
sqlite> .tables          # Ver todas las tablas
sqlite> .quit            # Salir

# 4. Valida tu trabajo
bash labs/01-basics/check.sh

# 5. Si todo está OK, pasas al siguiente
bash labs/02-joins/check.sh
```

---

## 🎯 Estructura del Repositorio

```
sql-lab/
├── .devcontainer/
│   ├── devcontainer.json    # Configuración de Codespaces
│   └── setup.sh             # Script de inicialización
├── labs/
│   ├── 01-basics/
│   │   ├── instructions.md  # Enunciados de las tareas
│   │   ├── init.sql         # Datos iniciales
│   │   └── check.sh         # Validador automático
│   ├── 02-joins/
│   ├── 03-aggregates/
│   └── ...
├── .vscode/
│   └── tasks.json           # Botones para ejecutar tasks
├── CLAUDE.md                # Documentación interna (no subir)
└── README.md                # Este archivo
```

---

## 🛠️ Comandos Útiles

### En la terminal (bash)

```bash
# Ver todos los labs disponibles
ls labs/

# Ejecutar validación de un lab
bash labs/01-basics/check.sh

# Abrir la BD de un lab
sqlite3 /workspace/data/01-basics.db

# Ver si hay un .progress.json (rastreo)
cat .progress.json
```

### En sqlite3

```sql
-- Ver todas las tablas
.tables

-- Ver estructura de una tabla
PRAGMA table_info(employees);

-- Ver contenido de una tabla
SELECT * FROM employees;

-- Limpiar pantalla
.mode line

-- Salir
.quit
```

---

## 📊 Validación Automática

Cada lab tiene un script `check.sh` que valida automáticamente:

- ✅ Si existen las tablas/vistas requeridas
- ✅ Si los datos son correctos
- ✅ Si las consultas producen resultados esperados

**Ejemplo de output:**

```
🧪 Validando Lab 01...

✅ PASS: Tabla 'departments' existe
✅ PASS: departments tiene 3 registros
✅ PASS: departments contiene Engineering
✅ PASS: departments contiene Marketing
✅ PASS: departments contiene HR

────────────────────────────────────────
Resultado: 5 pasadas, 0 falladas
────────────────────────────────────────

🎉 ¡Lab completado!
```

---

## 💡 Tips

- **Leo rápido**: Las instrucciones tienen ejemplos de código comentados
- **Me atasco**: Mira la sección "💡 Ayuda" en las instrucciones de cada lab
- **Quiero resetear**: Ejecuta el setup nuevamente: `bash .devcontainer/setup.sh`
- **Error de BD**: Revisa que usas la ruta correcta: `/workspace/data/XX-lab.db`

---

## 📈 Progreso

Tu progreso se guarda en `.progress.json` (no subido a git).

```json
{
  "started": "2026-05-01T10:30:00Z",
  "labs": {
    "01-basics": {
      "status": "completed",
      "attempts": 3,
      "duration_min": 12
    }
  }
}
```

---

## ❓ Ayuda

Si tienes problemas:

1. **Lee las instrucciones nuevamente**: Siempre tienen pistas
2. **Revisa el output de `check.sh`**: Dice exactamente qué está mal
3. **Resetea la BD**: `bash .devcontainer/setup.sh`
4. **Abre un issue** en el repositorio

---

## 📝 Notas

- Las BDs se crean automáticamente en `/workspace/data/`
- Cada lab tiene su propia BD independiente
- Puedes resetear cualquier momento ejecutando setup.sh nuevamente

**Happy learning! 🚀**

# Lab 01: SELECT y WHERE - Lo Básico

## 📋 Introducción

En este laboratorio aprenderás a escribir consultas SQL básicas usando `SELECT` y `WHERE`. La base de datos contiene una tabla `employees` con información de empleados.

### Datos Disponibles

```
Tabla: employees
├── id      (INTEGER) - Identificador único
├── name    (TEXT)    - Nombre del empleado
├── dept    (TEXT)    - Departamento
└── salary  (INTEGER) - Salario anual
```

**Empleados en la BD:**
- Ana García (Engineering, 55000)
- Luis Martínez (Marketing, 42000)
- Sara López (Engineering, 61000)
- Pedro Ruiz (HR, 38000)
- Marta Díaz (Marketing, 45000)

---

## 🎯 Tareas

### Tarea 1: Obtener todos los empleados

**Enunciado**: Escribe una consulta que devuelva todos los empleados (todas las columnas).

**Pista**: Usa `SELECT *` para obtener todas las columnas.

```sql
-- Escribe tu consulta aquí
SELECT * FROM employees;
```

---

### Tarea 2: Filtrar por departamento

**Enunciado**: Obtén todos los empleados del departamento `Engineering`.

**Pista**: Usa `WHERE` para filtrar por `dept`.

```sql
-- Escribe tu consulta aquí
SELECT * FROM employees WHERE dept = 'Engineering';
```

---

### Tarea 3: Crear tabla de departamentos

**Enunciado**: Crea una tabla `departments` con la siguiente estructura:

```
Columnas:
- id     (INTEGER PRIMARY KEY)
- name   (TEXT)
```

```sql
-- Escribe tu consulta aquí
CREATE TABLE departments (
    id   INTEGER PRIMARY KEY,
    name TEXT
);
```

---

### Tarea 4: Insertar departamentos

**Enunciado**: Inserta los 3 departamentos en la tabla `departments`:
- Engineering
- Marketing
- HR

```sql
-- Escribe tu consulta aquí
INSERT INTO departments (id, name) VALUES (1, 'Engineering');
INSERT INTO departments (id, name) VALUES (2, 'Marketing');
INSERT INTO departments (id, name) VALUES (3, 'HR');
```

---

## ✅ Validación

Cuando hayas completado todas las tareas, ejecuta:

```bash
bash check.sh
```

Si todo es correcto, verás:

```
✅ PASS: Tabla 'departments' existe
✅ PASS: departments tiene 3 registros
✅ PASS: departments contiene Engineering
✅ PASS: departments contiene Marketing
✅ PASS: departments contiene HR

🎉 ¡Lab completado! (5/5 pasadas)
```

---

## 💡 Ayuda

- **¿Cómo abro la BD?** → `sqlite3 /workspace/data/01-basics.db`
- **¿Cómo ejecuto una consulta?** → Escribe la consulta en `sqlite3` y presiona Enter
- **¿Cómo veo todas las tablas?** → `.tables`
- **¿Cómo salgo de sqlite3?** → `.quit`

---

**Duración estimada**: 10 minutos

**Nivel**: Principiante

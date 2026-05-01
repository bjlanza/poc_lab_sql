# Lab 02: JOINS - Combinando Tablas

## 📋 Introducción

En este laboratorio aprenderás a combinar datos de múltiples tablas usando `JOIN`. La base de datos contiene dos tablas relacionadas: `employees` y `departments`.

### Estructura de Datos

```
Tabla: departments
├── id   (INTEGER PRIMARY KEY)
└── name (TEXT)

Tabla: employees
├── id      (INTEGER PRIMARY KEY)
├── name    (TEXT)
├── dept_id (INTEGER) - Referencia a departments.id
└── salary  (INTEGER)
```

---

## 🎯 Tareas

### Tarea 1: INNER JOIN - Empleados y Departamentos

**Enunciado**: Escribe un `INNER JOIN` que muestre el nombre del empleado, nombre del departamento y salario.

**Pista**: Usa `INNER JOIN` con la condición `employees.dept_id = departments.id`

```sql
SELECT employees.name, departments.name AS dept, employees.salary
FROM employees
INNER JOIN departments ON employees.dept_id = departments.id;
```

---

### Tarea 2: LEFT JOIN - Todos los departamentos

**Enunciado**: Usa `LEFT JOIN` para mostrar todos los departamentos y sus empleados (si los tienen).

```sql
SELECT departments.name AS dept, employees.name AS emp
FROM departments
LEFT JOIN employees ON departments.id = employees.dept_id;
```

---

### Tarea 3: Crear vista de reporte

**Enunciado**: Crea una `VIEW` llamada `employee_report` que muestre:
- nombre del empleado
- departamento
- salario

```sql
CREATE VIEW employee_report AS
SELECT employees.name, departments.name AS dept, employees.salary
FROM employees
INNER JOIN departments ON employees.dept_id = departments.id;
```

---

## ✅ Validación

Cuando hayas completado todas las tareas, ejecuta:

```bash
bash check.sh
```

---

## 💡 Ayuda

- **¿Cómo abro la BD?** → `sqlite3 /workspace/data/02-joins.db`
- **¿Cómo veo las vistas?** → `.tables` y luego verás `employee_report`
- **Sintaxis básica de JOIN**:
  ```sql
  SELECT *
  FROM table1
  JOIN table2 ON table1.id = table2.fk_id
  ```

---

**Duración estimada**: 15 minutos

**Nivel**: Intermedio

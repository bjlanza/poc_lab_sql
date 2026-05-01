# Lab 03: Funciones de Agregación - GROUP BY y Cálculos

## 📋 Introducción

En este laboratorio aprenderás a usar funciones de agregación como `COUNT()`, `SUM()`, `AVG()`, `MAX()` y `MIN()`, combinadas con `GROUP BY`.

### Datos Disponibles

- 8 empleados distribuidos en 4 departamentos
- Puedes usar agregaciones para resumir datos por departamento

---

## 🎯 Tareas

### Tarea 1: Contar empleados por departamento

**Enunciado**: Usa `GROUP BY` con `COUNT()` para contar cuántos empleados hay en cada departamento.

**Esperado**: Una tabla con dos columnas: `dept` (nombre) y `count` (cantidad de empleados)

```sql
SELECT departments.name AS dept, COUNT(employees.id) AS count
FROM employees
JOIN departments ON employees.dept_id = departments.id
GROUP BY departments.id;
```

---

### Tarea 2: Salario promedio por departamento

**Enunciado**: Calcula el salario promedio (`AVG()`) para cada departamento.

**Esperado**: Columnas: `dept`, `avg_salary`

```sql
SELECT departments.name AS dept, AVG(employees.salary) AS avg_salary
FROM employees
JOIN departments ON employees.dept_id = departments.id
GROUP BY departments.id;
```

---

### Tarea 3: Salario máximo y mínimo

**Enunciado**: Obtén el salario máximo y mínimo de toda la empresa.

**Esperado**: Dos valores numéricos (max_salary y min_salary)

```sql
SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM employees;
```

---

### Tarea 4: Crear tabla de resumen de departamentos

**Enunciado**: Crea una tabla `dept_summary` con:
- dept_id
- total_employees (COUNT)
- avg_salary (AVG)
- max_salary (MAX)

```sql
CREATE TABLE dept_summary AS
SELECT 
  departments.id AS dept_id,
  COUNT(employees.id) AS total_employees,
  AVG(employees.salary) AS avg_salary,
  MAX(employees.salary) AS max_salary
FROM employees
JOIN departments ON employees.dept_id = departments.id
GROUP BY departments.id;
```

---

## ✅ Validación

```bash
bash check.sh
```

---

## 💡 Ayuda

- **Funciones de agregación comunes**:
  - `COUNT(*)` - contar filas
  - `SUM(columna)` - suma
  - `AVG(columna)` - promedio
  - `MAX(columna)` - máximo
  - `MIN(columna)` - mínimo

- **GROUP BY**: Agrupa resultados por una columna antes de aplicar agregaciones

- **Sintaxis básica**:
  ```sql
  SELECT columna, COUNT(*) AS cantidad
  FROM tabla
  GROUP BY columna;
  ```

---

**Duración estimada**: 20 minutos

**Nivel**: Intermedio-Avanzado

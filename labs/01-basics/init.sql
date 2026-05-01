-- Lab 01: SQL Básico
-- Base de datos inicial

CREATE TABLE IF NOT EXISTS employees (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL,
    dept    TEXT NOT NULL,
    salary  INTEGER NOT NULL
);

INSERT INTO employees (name, dept, salary) VALUES
    ('Ana García',    'Engineering', 55000),
    ('Luis Martínez', 'Marketing',   42000),
    ('Sara López',    'Engineering', 61000),
    ('Pedro Ruiz',    'HR',          38000),
    ('Marta Díaz',    'Marketing',   45000);

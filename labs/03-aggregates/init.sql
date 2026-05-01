-- Lab 03: Aggregate Functions (GROUP BY, COUNT, SUM, AVG, etc)

CREATE TABLE IF NOT EXISTS departments (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL,
    dept_id INTEGER NOT NULL,
    salary  INTEGER NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(id)
);

INSERT INTO departments (id, name) VALUES
    (1, 'Engineering'),
    (2, 'Marketing'),
    (3, 'HR'),
    (4, 'Sales');

INSERT INTO employees (name, dept_id, salary) VALUES
    ('Ana García',    1, 55000),
    ('Luis Martínez', 2, 42000),
    ('Sara López',    1, 61000),
    ('Pedro Ruiz',    3, 38000),
    ('Marta Díaz',    2, 45000),
    ('Carlos Gómez',  1, 58000),
    ('Elena Rodríguez', 4, 50000),
    ('Juan López',    4, 48000);

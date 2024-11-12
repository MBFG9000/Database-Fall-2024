
--1
CREATE INDEX idx_countries_name ON countries (name);

--2
CREATE INDEX idx_employees_name_surname ON employees (name, surname);

--3
CREATE UNIQUE INDEX idx_employees_salary_range ON employees (salary);

--4
CREATE INDEX idx_employees_name_substring ON employees (substring(name FROM 1 FOR 4));

--5
CREATE INDEX idx_employees_departments_budget_salary ON employees (department_id, salary);
CREATE INDEX idx_departments_budget ON departments (budget);

--1. Index for SELECT * FROM countries WHERE name = 'string';
--2. Index for SELECT * FROM employees WHERE name = 'string' AND surname = 'string';
--3. Unique index for SELECT * FROM employees WHERE salary < value1 AND salary > value2;
--4. Index for SELECT * FROM employees WHERE substring(name from 1 for 4) = 'abcd';
--5. Index for SELECT * FROM employees e JOIN departments d
--    ON d.department_id = e.department_id WHERE d.budget > value2 AND e.salary < value2;
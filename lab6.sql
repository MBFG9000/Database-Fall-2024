CREATE DATABASE Lab6;

CREATE TABLE locations(
    location_id SERIAL PRIMARY KEY,
    street_address VARCHAR(25),
    postal_code VARCHAR(12),
    city VARCHAR(30),
    state_province VARCHAR(12)
);

CREATE TABLE departments(
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE,
    budget INTEGER,
    location_id INTEGER REFERENCES locations
);

CREATE TABLE employees(
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    salary INTEGER,
    department_id INTEGER REFERENCES departments
);

INSERT INTO locations (street_address, postal_code, city, state_province)
VALUES
    ('123 Main St', '12345', 'New York', 'NY'),
    ('456 Elm St', '54321', 'Los Angeles', 'CA'),
    ('789 Oak St', '67890', 'Chicago', 'IL');

INSERT INTO departments (department_name, budget, location_id)
VALUES
    ('Sales', 1000000, 1),
    ('Engineering', 2000000, 2),
    ('Marketing', 1500000, 3),
    ('HR', 500000, 1),
    ('Finance', 100000, 5);

INSERT INTO employees (first_name, last_name, email, phone_number, salary, department_id)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890', 60000, 1),
    ('Jane', 'Smith', 'jane.smith@example.com', '123-555-7890', 70000, 2),
    ('Emily', 'Johnson', 'emily.johnson@example.com', '123-555-1111', 75000, 3),
    ('Michael', 'Brown', 'michael.brown@example.com', '123-555-2222', 50000, 4),
    ('Chris', 'Davis', 'chris.davis@example.com', '123-555-3333', 65000, 1),
    ('Alina', 'Kim', 'alinakim.@example.com', '777-123-1234', null, null);

--3--

SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

--4--

SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = 40 OR e.department_id = 80;

--5--

SELECT e.first_name, e.last_name, d.department_name, l.city, l.state_province
FROM employees e
JOIN departments d on e.department_id = d.department_id
JOIN locations l on d.location_id = l.location_id;

--6--

SELECT l.department_name
FROM departments l
LEFT JOIN employees e on l.department_id = e.department_id;

--7--

SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e
LEFT JOIN departments d on e.department_id = d.department_id


-- 3 Select the first name, last name, department id, and
-- department name for each employee.
-- 4 Select the first name, last name, department id and department
-- name, for all employees for departments 80 or 40
-- 5 Select the first and last name, department, city, and state
-- province for each employee.
-- 6 Select all departments including those where does not have
-- any employee.
-- 7 Select the first name, last name, department id and name, for
-- all employees who have or have not any department=
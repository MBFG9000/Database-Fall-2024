--1--
CREATE DATABASE lab6;

--2--
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(100),
    state_province VARCHAR(100)
);

CREATE TABLE department_locations (
    department_id INT,
    location_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

--3--
SELECT 
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id;

--4--
SELECT 
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
WHERE 
    e.department_id IN (80, 40);

--5--
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    l.city,
    l.state_province
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    department_locations dl ON d.department_id = dl.department_id
JOIN 
    locations l ON dl.location_id = l.location_id;

--6--
SELECT 
    d.department_id,
    d.department_name,
    e.first_name,
    e.last_name
FROM 
    departments d
LEFT JOIN 
    employees e ON d.department_id = e.department_id;

--7--
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM 
    employees e
LEFT JOIN 
    departments d ON e.department_id = d.department_id;
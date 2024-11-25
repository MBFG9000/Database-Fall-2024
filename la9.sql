-- i want to cry, pls help me 

--1

CREATE OR REPLACE PROCEDURE increase_value(parameter INTEGER, OUT increased INTEGER)
    LANGUAGE plpgsql AS
    $$
        BEGIN
        increased = parameter + 10;
        END;
    $$;

CALL increase_value(10, 0); --actually this is logically confusing variant

--another variant

CREATE OR REPLACE PROCEDURE increase_value(parameter INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
    RAISE NOTICE 'Result: %', parameter + 10;
END;
$$;

DROP PROCEDURE increase_value;
DROP FUNCTION  increase_value;
--if you use function instead of procedure

CREATE OR REPLACE FUNCTION increase_value(IN parameter INTEGER)
    RETURNS INTEGER LANGUAGE  plpgsql
        AS
    $$
    BEGIN
        return parameter + 10;
    END;
    $$;

SELECT increase_value(10);

--2

CREATE OR REPLACE PROCEDURE compare_numbers (IN a INTEGER, IN b INTEGER, OUT MESSAGE VARCHAR(10))
    LANGUAGE plpgsql AS
    $$
    BEGIN
        IF a = b THEN
            MESSAGE = 'EQUAL';
        ELSIF a > b THEN
            MESSAGE = 'GREATER';
        ELSE
            MESSAGE = 'LESSER';
    END IF;
    END;
    $$;

CALL compare_numbers(3,4,'');
CALL compare_numbers(3,3,'');
CALL compare_numbers(4,3,'');

--3

CREATE OR REPLACE PROCEDURE number_series (IN n INTEGER, OUT series VARCHAR)
    LANGUAGE plpgsql AS
    $$
    DECLARE
        i INTEGER := 1;
    BEGIN
        series = '';

        WHILE i <= n LOOP
            series = series || i || CASE WHEN i = n THEN ' ;' ELSE ' , ' END;
            i := i+1;
            END LOOP;

    END;
    $$;

CALL number_series(10,'');

--4

    CREATE TABLE employees (
        id SERIAL PRIMARY KEY,              -- Уникальный идентификатор сотрудника
        name TEXT NOT NULL,                 -- Имя сотрудника
        department TEXT NOT NULL,           -- Отдел, в котором работает сотрудник
        position TEXT NOT NULL,             -- Должность
        hire_date DATE NOT NULL,            -- Дата найма
        salary NUMERIC(10, 2) NOT NULL,     -- Зарплата
        email TEXT UNIQUE,                  -- Email сотрудника
        phone_number TEXT,                  -- Номер телефона
        address TEXT,                       -- Адрес сотрудника
        is_active BOOLEAN DEFAULT TRUE      -- Статус сотрудника (активный/неактивный)
);

INSERT INTO employees (name, department, position, hire_date, salary, email, phone_number, address, is_active)
VALUES
('John Doe', 'Sales', 'Sales Manager', '2018-03-15', 75000.00, 'john.doe@example.com', '123-456-7890', '123 Elm Street', TRUE),
('Jane Smith', 'IT', 'Software Engineer', '2020-07-01', 90000.00, 'jane.smith@example.com', '234-567-8901', '456 Oak Avenue', TRUE),
('Emily Johnson', 'HR', 'HR Specialist', '2015-09-20', 60000.00, 'emily.johnson@example.com', '345-678-9012', '789 Pine Boulevard', TRUE),
('Michael Brown', 'Finance', 'Accountant', '2012-01-10', 65000.00, 'michael.brown@example.com', '456-789-0123', '101 Maple Lane', FALSE),
('Sophia Davis', 'Marketing', 'Marketing Analyst', '2021-06-25', 55000.00, 'sophia.davis@example.com', '567-890-1234', '202 Birch Way', TRUE);

CREATE OR REPLACE FUNCTION find_employee(emp_name TEXT)
RETURNS SETOF employees AS
$$
BEGIN
    -- Возвращаем результат запроса
    RETURN QUERY
    SELECT *
    FROM employees
    WHERE name = emp_name;

    -- Если записи не найдены
    IF NOT FOUND THEN
        RAISE NOTICE 'No employee found with name: %', emp_name;
    END IF;
END;
$$ LANGUAGE plpgsql;



SELECT find_employee('Jane Smith');

SELECT * FROM employees;

--5

CREATE TABLE products (
    id SERIAL PRIMARY KEY,           -- Уникальный идентификатор продукта
    name TEXT NOT NULL,              -- Название продукта
    category TEXT NOT NULL,          -- Категория продукта
    price NUMERIC(10, 2) NOT NULL,   -- Цена продукта
    stock_quantity INTEGER NOT NULL, -- Количество на складе
    description TEXT                 -- Описание продукта
);

INSERT INTO products (name, category, price, stock_quantity, description) VALUES
('Laptop', 'Electronics', 1500.00, 10, 'High-performance laptop'),
('Smartphone', 'Electronics', 800.00, 25, 'Latest model smartphone'),
('Desk Chair', 'Furniture', 120.00, 50, 'Ergonomic desk chair'),
('Dining Table', 'Furniture', 300.00, 15, 'Wooden dining table'),
('Refrigerator', 'Appliances', 1000.00, 5, 'Energy-efficient refrigerator'),
('Microwave Oven', 'Appliances', 200.00, 20, 'Compact microwave oven'),
('Blender', 'Appliances', 50.00, 100, 'Powerful blender for smoothies'),
('Office Desk', 'Furniture', 250.00, 10, 'Spacious office desk'),
('Tablet', 'Electronics', 400.00, 30, '10-inch tablet with HD display');

CREATE OR REPLACE FUNCTION list_products(category_name TEXT)
RETURNS TABLE(
    id INTEGER,
    name TEXT,
    category TEXT,
    price NUMERIC,
    stock_quantity INTEGER,
    description TEXT
) AS
$$
BEGIN
    -- Используем алиас p для таблицы products
    RETURN QUERY
    SELECT p.id, p.name, p.category, p.price, p.stock_quantity, p.description
    FROM products p
    WHERE p.category = category_name;

    -- Если ничего не найдено
    IF NOT FOUND THEN
        RAISE NOTICE 'No products found in category: %', category_name;
    END IF;
END;
$$ LANGUAGE plpgsql;


SELECT list_products('Electronics');

--6

CREATE TABLE company_staff (
    id SERIAL PRIMARY KEY,           -- Уникальный идентификатор сотрудника
    name TEXT NOT NULL,              -- Имя сотрудника
    salary NUMERIC(10, 2) NOT NULL   -- Зарплата
);

INSERT INTO company_staff (name, salary) VALUES
('John Doe', 50000),
('Jane Smith', 60000),
('Emily Johnson', 55000);

CREATE OR REPLACE PROCEDURE calculate_bonus(emp_id INTEGER, OUT bonus NUMERIC)
LANGUAGE plpgsql AS
$$
BEGIN
    -- Вычисляем бонус как 10% от зарплаты
    SELECT salary * 0.1 INTO bonus
    FROM company_staff
    WHERE id = emp_id;

    -- Если сотрудник не найден, выводим сообщение
    IF NOT FOUND THEN
        RAISE NOTICE 'Employee with ID % not found.', emp_id;
        bonus := 0;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE update_salary(emp_id INTEGER)
LANGUAGE plpgsql AS
$$
DECLARE
    bonus NUMERIC; -- Переменная для хранения бонуса
BEGIN
    -- Вызываем процедуру calculate_bonus для вычисления бонуса
    CALL calculate_bonus(emp_id, bonus);

    -- Обновляем зарплату сотрудника
    UPDATE company_staff
    SET salary = salary + bonus
    WHERE id = emp_id;

    -- Выводим сообщение о завершении обновления
    RAISE NOTICE 'Salary updated for employee ID % with bonus %.', emp_id, bonus;
END;
$$;

SELECT * FROM company_staff WHERE id = 1;

CALL update_salary(1);

--7

CREATE OR REPLACE PROCEDURE calculate_triangle_angles(
    IN side_a NUMERIC,
    IN side_b NUMERIC,
    IN side_c NUMERIC,
    OUT result_description TEXT
)
LANGUAGE plpgsql AS
$$
DECLARE
    cos_alpha NUMERIC;
    cos_beta NUMERIC;
    cos_gamma NUMERIC;
BEGIN
    <<alpha_block>>
    BEGIN
        cos_alpha := (side_b^2 + side_c^2 - side_a^2) / (2 * side_b * side_c);
    END alpha_block;

    <<beta_block>>
    BEGIN
        cos_beta := (side_a^2 + side_c^2 - side_b^2) / (2 * side_a * side_c);
    END beta_block;

    <<gamma_block>>
    BEGIN
        cos_gamma := (side_a^2 + side_b^2 - side_c^2) / (2 * side_a * side_b);
    END gamma_block;

    <<result_block>>
    BEGIN
        result_description :=
            'Cosine of Alpha: ' || cos_alpha || ', ' ||
            'Cosine of Beta: ' || cos_beta || ', ' ||
            'Cosine of Gamma: ' || cos_gamma;
    END result_block;
END;
$$;

CALL calculate_triangle_angles(4,3,5,'');



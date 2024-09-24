-- 1 --

CREATE DATABASE lab2;

-- 2 --

CREATE TABLE  countries(
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR,
    region_id INTEGER,
    population INTEGER
);

-- 3 --

INSERT INTO countries(country_name, region_id, population)
VALUES  ('Russian', 121, 143666931),
        ('USA', 78, 331002651),
        ('China', 121, 1439323776),
        ('India', 95, 1380004385),
        ('Germany', 64, 83783942),
        ('Brazil', 112, 212559417),
        ('Japan', 45, 126476461),
        ('Canada', 58, 37742154)
;

-- 4 --

INSERT INTO countries (country_id,country_name) VALUES (12, 'Uzbekistan');

-- 5 --

SELECT constraint_name FROM information_schema.table_constraints
WHERE table_name = 'countries' and constraint_type = 'PRIMARY KEY';

ALTER TABLE countries DROP CONSTRAINT countries_pkey;

ALTER TABLE countries
ALTER COLUMN country_id DROP NOT NULL;

INSERT INTO countries (country_id) VALUES (NULL);

--6--

INSERT INTO countries (country_name, region_id, population) VALUES
        ('Australia', 76, 25499884),
        ('France', 102, 65273511),
        ('UK', 67, 67886011)
;

--7--

ALTER TABLE countries ALTER COLUMN country_name SET DEFAULT 'Kazakhstan';

--8--

INSERT INTO countries(country_name, region_id, population) VALUES
    (DEFAULT, 876 , 2000000);

--9--

INSERT INTO countries DEFAULT VALUES;

--10--

CREATE TABLE countries_new (LIKE countries INCLUDING ALL);

--11--

INSERT INTO countries_new
SELECT * FROM countries;

--12--

UPDATE countries
SET region_id = 1
WHERE region_id IS NULL;

--13--

SELECT country_name, population * 1.10 AS "New Population"
FROM countries;

--14--

DELETE FROM countries
WHERE population < 100000;

--15--

DELETE FROM countries_new
WHERE country_id IN (SELECT country_id FROM countries)
RETURNING *;

-- 16 --

DELETE FROM countries
RETURNING *;



DROP TABLE countries;

SELECT * from countries;

SELECT * from countries_new;

DROP TABLE countries_new;



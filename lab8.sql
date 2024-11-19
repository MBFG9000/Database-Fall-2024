--1
CREATE DATABASE lab8;

--2
CREATE TABLE salesman(
    salesman_id INTEGER PRIMARY KEY ,
    name VARCHAR(50),
    city VARCHAR(40),
    commission REAL
);

INSERT INTO salesman
VALUES (5001, 'James Hoog', 'New York' ,0.15),
       (5002, 'Nail Knite', 'Paris',0.13),
       (5005, 'Pit Alex', 'London',0.11),
       (5006, 'Mc Lyon', 'Paris',0.14),
       (5003, 'Lauson Hen', null, 0.12),
       (5007, 'Paul Adam', 'Rome', 0.13);

CREATE TABLE customers(
    customer_id INTEGER PRIMARY KEY ,
    cust_name VARCHAR(50),
    city VARCHAR(40),
    grade INTEGER,
    salesman_id INTEGER REFERENCES salesman(salesman_id)
);

INSERT INTO customers
VALUES (3002,'Nick Rimando','New York',100,5001),
(3005,'Graham Zusi','California',200,5002),
(3001,'Brad Guzan','London',null,5005),
(3004,'Fabian Johns','Paris',300,5006),
(3007,'Brad Davis','New York',200,5001),
(3009,'Geoff Camero','Berlin',100,5003),
(3008,'Julian Green','London',300,5002);

CREATE TABLE orders(
    ord_no INTEGER PRIMARY KEY ,
    purch_amt REAL,
    ord_date DATE,
    customer_id INTEGER REFERENCES customers(customer_id),
    salesman_id INTEGER REFERENCES salesman(salesman_id)
);

INSERT INTO orders
VALUES
    (70001,150.5,'2012-10-05',3005,5002),
    (70009,270.65,'2012-09-10',3001,5005),
    (70002,65.26,'2012-10-05',3002,5001),
    (70004,110.5,'2012-08-17',3009,5003),
    (70007,948.5,'2012-09-10',3005,5002),
    (70005,2400.6,'2012-07-27',3007,5001),
    (70008,5760,'2012-09-10',3002,5001);

--3
CREATE ROLE junior_dev LOGIN;

--4
CREATE VIEW salesman_from_newyork AS
    SELECT * FROM salesman
    WHERE city = 'New York';
--SELECT * FROM salesman_from_newyork;

--5
CREATE OR REPLACE VIEW foreach_order_sman_cust AS
    SELECT o.ord_no,c.cust_name,s.name AS salesman_name FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN salesman s on o.salesman_id = s.salesman_id;
--SELECT * FROM foreach_order_sman_cust;
GRANT ALL PRIVILEGES ON foreach_order_sman_cust TO junior_dev;

--6
CREATE VIEW cust_with_highest_grade AS
    SELECT * FROM customers
WHERE grade = (SELECT max(grade) FROM customers);
--SELECT * FROM cust_with_highest_grade;
GRANT SELECT ON cust_with_highest_grade TO junior_dev;

--7
CREATE OR REPLACE VIEW num_salesman_in_city AS
    SELECT count(*), city FROM salesman
GROUP BY city;
--SELECT * FROM num_salesman_in_city;

--8
CREATE OR REPLACE VIEW salesman_atleast_2_cust AS
    SELECT s.name, count(c.salesman_id) FROM salesman s
JOIN customers c on s.salesman_id = c.salesman_id
GROUP BY c.salesman_id,s.name
HAVING count(c.salesman_id)>1;
--SELECT * FROM salesman_atleast_2_cust;

--9
CREATE ROLE intern ;
GRANT junior_dev TO intern;

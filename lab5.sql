--1--
CREATE DATABASE lab5;

--2--

CREATE TABLE salesman(
	salesman_id INTEGER PRIMARY KEY,
	name varchar(250),
	city varchar (250),
	commission numeric(10,5)
);

CREATE TABLE cust_info(
	customer_id  INTEGER PRIMARY KEY,
	cust_name varchar(250),
	city varchar(250),
	grade INTEGER,
	salesman_id INTEGER REFERENCES salesman(salesman_id) ON DELETE RESTRICT 
);

CREATE TABLE ord_no(
	ord_id INTEGER PRIMARY KEY,
	purch_amt NUMERIC(10,5),
	ord_date date,
	customer_id INTEGER REFERENCES cust_info(customer_id),
	salesman_id INTEGER REFERENCES salesman(salesman_id)	
);

INSERT INTO salesman VALUES 
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', ' ', 0.12),
(5007, 'Paul Adam', 'Rome', 0.13); 

INSERT INTO cust_info (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', null, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002);

INSERT INTO ord_no (ord_id, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001);


--3--

SELECT SUM(purch_amt) FROM ord_no;

--4--

SELECT AVG(purch_amt) FROM ord_no;

--5--

SELECT COUNT(cust_name) FROM cust_info WHERE cust_name IS NOT NULL;

--6--

SELECT MIN(purch_amt) FROM ord_no;

--7--

SELECT * FROM cust_info WHERE RIGHT(cust_name, 1)  = 'b';

SELECT * FROM cust_info WHERE cust_name LIKE '%b';

--8--

SELECT * FROM ord_no WHERE customer_id IN 
	(SELECT customer_id FROM cust_info WHERE city = 'New York');

SELECT ord_no.* FROM ord_no
JOIN cust_info ON ord_no.customer_id = cust_info.customer_id
WHERE cust_info.city = 'New York';


--9--

SELECT cust_info.* FROM cust_info 
JOIN ord_no ON ord_no.customer_id = cust_info.customer_id 
WHERE ord_no.purch_amt > 10;

--10--

SELECT SUM(grade) FROM cust_info;

--11--

SELECT cust_name FROM cust_info WHERE cust_name IS NOT NULL;

--12--

SELECT MAX(grade) FROM cust_info;

SELECT * FROM cust_info;



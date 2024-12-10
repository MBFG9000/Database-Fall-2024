-- Создание таблицы Books
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL
);

-- Создание таблицы Customers
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Создание таблицы Orders
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES Books(book_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    quantity INT NOT NULL
);

-- Заполнение таблицы Books
INSERT INTO Books (title, author, price, quantity) VALUES
('Database 101', 'A. Smith', 40.00, 10),
('Learn SQL', 'B. Johnson', 35.00, 15),
('Advanced DB', 'C. Lee', 50.00, 5);

-- Заполнение таблицы Customers
INSERT INTO Customers (name, email) VALUES
('John Doe', 'johndoe@example.com'),
('Jane Doe', 'janedoe@example.com');


-- Task 1: Transaction for Placing an Order

BEGIN;

-- Insert a new order for customer 101 ordering 2 quantities of book_id 1
INSERT INTO Orders (book_id, customer_id, order_date, quantity) 
VALUES (1, 101, CURRENT_DATE, 2);

-- Update the Books table, reduce quantity of book_id 1 by 2
UPDATE Books 
SET quantity = quantity - 2 
WHERE book_id = 1;

COMMIT;

-- Task 2: Transaction with Rollback

BEGIN;

-- Check if sufficient quantity is available in the Books table for book_id 3
-- If not, the transaction will be rolled back
DO $$
BEGIN
    IF (SELECT quantity FROM Books WHERE book_id = 3) < 10 THEN
        RAISE EXCEPTION 'Not enough stock';
    ELSE
        -- Insert the order into the Orders table for customer 102 ordering 10 quantities of book_id 3
        INSERT INTO Orders (book_id, customer_id, order_date, quantity) 
        VALUES (3, 102, CURRENT_DATE, 10);

        -- Update the Books table, reduce quantity of book_id 3 by 10
        UPDATE Books 
        SET quantity = quantity - 10 
        WHERE book_id = 3;
    END IF;
END $$;

-- Rollback if insufficient stock
ROLLBACK;

-- Task 3: Isolation Level Demonstration

-- Session 1 (Start a transaction and update the price of a book)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Update price for book_id 1
UPDATE Books 
SET price = 45.00 
WHERE book_id = 1;

-- Commit the transaction in session 1
COMMIT;

-- Session 2 (Start another transaction to read the price of the same book)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Read price for book_id 1
SELECT price FROM Books WHERE book_id = 1;

-- Commit the transaction in session 2
COMMIT;

-- Task 4: Durability Check

BEGIN;

-- Update the email address of customer 101
UPDATE Customers 
SET email = 'john.doe.new@example.com' 
WHERE customer_id = 101;

-- Commit the transaction
COMMIT;

-- Now, restart the database server. After restart, the new email should persist.

-- Check the Customers table to ensure the update persists after the restart
SELECT * FROM Customers WHERE customer_id = 101;

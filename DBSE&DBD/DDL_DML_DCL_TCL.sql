DROP DATABASE IF EXISTS bank_management;

CREATE DATABASE bank_management;

USE bank_management;

CREATE TABLE bank_transactions (
    txn_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    branch_name VARCHAR(50),
    transaction_type VARCHAR(20),
    amount DECIMAL(10,2),
    transaction_date DATE
);

ALTER TABLE bank_transactions
ADD account_no VARCHAR(20);

ALTER TABLE bank_transactions
MODIFY customer_name VARCHAR(100);

INSERT INTO bank_transactions VALUES
(101,'Ravi','Hyderabad','Deposit',5000,'2024-01-05','ACC101'),
(102,'Sita','Hyderabad','Withdrawal',2000,'2024-01-06','ACC102'),
(103,'Kiran','Vijayawada','Deposit',12000,'2024-01-08','ACC103'),
(104,'Anil','Vizag','Deposit',8000,'2024-01-10','ACC104'),
(105,'Priya','Hyderabad','Withdrawal',3500,'2024-01-11','ACC105'),
(106,'Ramesh','Vizag','Deposit',15000,'2024-01-12','ACC106'),
(107,'Keerthi','Vijayawada','Withdrawal',1000,'2024-01-13','ACC107'),
(108,'Rahul','Hyderabad','Deposit',9000,'2024-01-14','ACC108'),
(109,'Sneha','Vizag','Withdrawal',4000,'2024-01-15','ACC109'),
(110,'Madhu','Vijayawada','Deposit',11000,'2024-01-16','ACC110');

INSERT INTO bank_transactions
VALUES
(111,'Venu','Vizag','Deposit',7000,'2024-01-18','ACC111');

UPDATE bank_transactions
SET amount = 5000
WHERE txn_id = 105;

DELETE FROM bank_transactions
WHERE txn_id = 111;

SELECT *
FROM bank_transactions;

SELECT *
FROM bank_transactions
WHERE transaction_type = 'Deposit';

SELECT *
FROM bank_transactions
ORDER BY amount DESC;

CREATE USER IF NOT EXISTS 'Auditor1'@'localhost'
IDENTIFIED BY 'password123';

CREATE USER IF NOT EXISTS 'BranchManager'@'localhost'
IDENTIFIED BY 'password123';

GRANT SELECT
ON bank_management.bank_transactions
TO 'Auditor1'@'localhost';

GRANT ALL PRIVILEGES
ON bank_management.bank_transactions
TO 'BranchManager'@'localhost';

REVOKE SELECT
ON bank_management.bank_transactions
FROM 'Auditor1'@'localhost';

REVOKE ALL PRIVILEGES
ON bank_management.bank_transactions
FROM 'BranchManager'@'localhost';

START TRANSACTION;

UPDATE bank_transactions
SET amount = 6000
WHERE txn_id = 101;

COMMIT;

START TRANSACTION;

SAVEPOINT Before_Update;

UPDATE bank_transactions
SET amount = 99999
WHERE txn_id = 102;

ROLLBACK TO Before_Update;

COMMIT;

START TRANSACTION;

UPDATE bank_transactions
SET amount = 7000
WHERE txn_id = 101;

SAVEPOINT SP1;

UPDATE bank_transactions
SET amount = 9000
WHERE txn_id = 102;

ROLLBACK TO SP1;

COMMIT;
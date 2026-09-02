DROP DATABASE BankDB6;
CREATE DATABASE BankDB6;
USE BankDB6;
# Pranav (2520030207)

CREATE TABLE Customer(
Customer_ID INT PRIMARY KEY,
Customer_Name VARCHAR(100), Phone VARCHAR(15),
Email VARCHAR(100), City VARCHAR(50));

CREATE TABLE Account(
Account_No INT PRIMARY KEY,
Customer_ID INT, Account_Type VARCHAR(20),
Balance DECIMAL(12,2), Branch VARCHAR(50),
FOREIGN KEY(Customer_ID) REFERENCES Customer(Customer_ID));

CREATE TABLE Bank_Transaction(
Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
Account_No INT, Transaction_Type VARCHAR(20),
Amount DECIMAL(12,2),
Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(Account_No) REFERENCES Account(Account_No));

CREATE TABLE Loan(
Loan_ID INT PRIMARY KEY,
Customer_ID INT, Loan_Type VARCHAR(30),
Loan_Amount DECIMAL(12,2), Interest_Rate DECIMAL(5,2),
FOREIGN KEY(Customer_ID) REFERENCES Customer(Customer_ID));

INSERT INTO Customer VALUES
(101,'Pranav','9154286521','vsk@gmail.com','Hyderabad'),
(102,'Priya Sharma','9876543211','priya@gmail.com','Vijayawada'),
(103,'Arjun Reddy','9876543212','arjun@gmail.com','Bangalore'),
(104,'Sneha Rao','9876543213','sneha@gmail.com','Chennai'),
(105,'Kiran Kumar','9876543214','kiran@gmail.com','Hyderabad');

INSERT INTO Account VALUES
(10001,101,'Savings',50000,'Hyderabad'),
(10002,102,'Savings',75000,'Vijayawada'),
(10003,103,'Current',120000,'Bangalore'),
(10004,104,'Savings',45000,'Chennai'),
(10005,105,'Current',90000,'Hyderabad');

INSERT INTO Bank_Transaction(Account_No,Transaction_Type,Amount) VALUES
(10001,'DEPOSIT',10000),(10002,'DEPOSIT',15000),
(10003,'WITHDRAW',20000),(10004,'DEPOSIT',5000),
(10005,'WITHDRAW',10000);

INSERT INTO Loan VALUES
(501,101,'Home Loan',5000000,7.5),
(502,102,'Education Loan',1000000,6.5),
(503,103,'Car Loan',800000,8.2),
(504,104,'Personal Loan',500000,10.5);

DELIMITER //
# Pranav (2520030207)
CREATE PROCEDURE GetAllCustomers()
BEGIN SELECT * FROM Customer; END //

CREATE PROCEDURE GetAccountDetails(IN a INT)
BEGIN SELECT * FROM Account WHERE Account_No=a; END //

CREATE PROCEDURE DepositMoney(IN a INT,IN amt DECIMAL(12,2))
BEGIN UPDATE Account SET Balance=Balance+amt WHERE Account_No=a; END //

CREATE PROCEDURE WithdrawMoney(IN a INT,IN amt DECIMAL(12,2))
BEGIN UPDATE Account SET Balance=Balance-amt WHERE Account_No=a; END //
DELIMITER //
CREATE TRIGGER CheckBalance
BEFORE UPDATE ON Account FOR EACH ROW
BEGIN
IF NEW.Balance<0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insufficient Balance';
END IF;
END //
DELIMITER //
CREATE TRIGGER CheckAmount
BEFORE INSERT ON Bank_Transaction FOR EACH ROW
BEGIN
IF NEW.Amount<=0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid Amount';
END IF;
END //

CREATE TABLE Transaction_Audit(
Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
Transaction_ID INT,Account_No INT,
Transaction_Type VARCHAR(20),Amount DECIMAL(12,2),
Audit_Date DATETIME DEFAULT CURRENT_TIMESTAMP);
DELIMITER //
CREATE TRIGGER AuditTransaction
AFTER INSERT ON Bank_Transaction FOR EACH ROW
BEGIN
INSERT INTO Transaction_Audit(Transaction_ID,Account_No,Transaction_Type,Amount)
VALUES(NEW.Transaction_ID,NEW.Account_No,NEW.Transaction_Type,NEW.Amount);
END //
DELIMITER //
CREATE TRIGGER UpdateBalance
AFTER INSERT ON Bank_Transaction FOR EACH ROW
BEGIN
IF NEW.Transaction_Type='DEPOSIT' THEN
UPDATE Account SET Balance=Balance+NEW.Amount WHERE Account_No=NEW.Account_No;
ELSEIF NEW.Transaction_Type='WITHDRAW' THEN
UPDATE Account SET Balance=Balance-NEW.Amount WHERE Account_No=NEW.Account_No;
END IF;
END //
DELIMITER //
CREATE TRIGGER PreventWithdraw
BEFORE INSERT ON Bank_Transaction FOR EACH ROW
BEGIN
DECLARE bal DECIMAL(12,2);
SELECT Balance INTO bal FROM Account WHERE Account_No=NEW.Account_No;
IF NEW.Transaction_Type='WITHDRAW' AND NEW.Amount>bal THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insufficient Balance';
END IF;
END //
DELIMITER //
CREATE PROCEDURE TransferMoney(IN s INT,IN r INT,IN amt DECIMAL(12,2))
BEGIN
DECLARE bal DECIMAL(12,2);
SELECT Balance INTO bal FROM Account WHERE Account_No=s;
IF bal<amt THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transfer Failed';
ELSE
UPDATE Account SET Balance=Balance-amt WHERE Account_No=s;
UPDATE Account SET Balance=Balance+amt WHERE Account_No=r;
END IF;
END //

DELIMITER ;

CALL GetAllCustomers();
CALL GetAccountDetails(10001);
CALL DepositMoney(10001,5000);
CALL WithdrawMoney(10001,3000);
CALL TransferMoney(10001,10002,5000);
# Pranav (2520030207)
SELECT * FROM Customer;

# Pranav (2520030207)
SELECT * FROM Account;

# Pranav (2520030207)
SELECT * FROM Bank_Transaction;

# Pranav (2520030207)
SELECT * FROM Loan;

SELECT * FROM Transaction_Audit;
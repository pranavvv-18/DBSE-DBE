CREATE DATABASE BankDB7;
USE BankDB7;
# Pranav (2520030207)
CREATE TABLE Customer(
Customer_ID INT PRIMARY KEY,
Customer_Name VARCHAR(100),
Phone VARCHAR(15),
Email VARCHAR(100),
City VARCHAR(50));

CREATE TABLE Account(
Account_No INT PRIMARY KEY,
Customer_ID INT,
Account_Type VARCHAR(20),
Balance DECIMAL(12,2),
Branch VARCHAR(50),
FOREIGN KEY(Customer_ID) REFERENCES Customer(Customer_ID));

CREATE TABLE Bank_Transaction(
Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
Account_No INT,
Transaction_Type VARCHAR(20),
Amount DECIMAL(12,2),
Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(Account_No) REFERENCES Account(Account_No));

CREATE TABLE Loan(
Loan_ID INT PRIMARY KEY,
Customer_ID INT,
Loan_Type VARCHAR(30),
Loan_Amount DECIMAL(12,2),
Interest_Rate DECIMAL(5,2),
FOREIGN KEY(Customer_ID) REFERENCES Customer(Customer_ID));

INSERT INTO Customer VALUES
(101,'Pranav','8008117765','vsk@gmail.com','Hyderabad'),
(102,'Priya','9876543211','priya@gmail.com','Vijayawada'),
(103,'Arjun','9876543212','arjun@gmail.com','Bangalore'),
(104,'Sneha','9876543213','sneha@gmail.com','Chennai'),
(105,'Kiran','9876543214','kiran@gmail.com','Hyderabad');

INSERT INTO Account VALUES
(10001,101,'Savings',50000,'Hyderabad'),
(10002,102,'Savings',75000,'Vijayawada'),
(10003,103,'Current',120000,'Bangalore'),
(10004,104,'Savings',45000,'Chennai'),
(10005,105,'Current',90000,'Hyderabad');

INSERT INTO Loan VALUES
(501,101,'Home Loan',5000000,7.5),
(502,102,'Education Loan',1000000,6.5),
(503,103,'Car Loan',800000,8.2);

CREATE VIEW Customer_View AS SELECT * FROM Customer;

CREATE VIEW Savings_View AS SELECT * FROM Account WHERE Account_Type='Savings';

CREATE VIEW High_Balance_View AS SELECT * FROM Account WHERE Balance>100000;

CREATE VIEW Customer_Account_View AS
SELECT C.Customer_Name,A.Account_No,A.Account_Type,A.Balance,A.Branch
FROM Customer C JOIN Account A
ON C.Customer_ID=A.Customer_ID;

CREATE VIEW Customer_Loan_View AS
SELECT C.Customer_Name,L.Loan_Type,L.Loan_Amount
FROM Customer C JOIN Loan L
ON C.Customer_ID=L.Customer_ID;

CREATE VIEW Branch_Balance_View AS
SELECT Branch,SUM(Balance) Total_Balance
FROM Account GROUP BY Branch;

CREATE VIEW Account_Type_View AS
SELECT Account_Type,AVG(Balance) Average_Balance
FROM Account GROUP BY Account_Type;

CREATE VIEW Deposit_View AS
SELECT * FROM Bank_Transaction
WHERE Transaction_Type='DEPOSIT';

CREATE VIEW Loan_Interest_View AS
SELECT Loan_ID,Loan_Amount,Interest_Rate,
(Loan_Amount*Interest_Rate/100) Annual_Interest
FROM Loan;

SELECT * FROM Customer_View;
SELECT * FROM Savings_View;
SELECT * FROM High_Balance_View;
SELECT * FROM Customer_Account_View;
SELECT * FROM Customer_Loan_View;
SELECT * FROM Branch_Balance_View;
SELECT * FROM Account_Type_View;
SELECT * FROM Deposit_View;
SELECT * FROM Loan_Interest_View;

SHOW FULL TABLES WHERE TABLE_TYPE='VIEW';
SHOW CREATE VIEW Customer_Account_View;
DESCRIBE Customer_Account_View;
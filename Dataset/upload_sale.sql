
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
 SalesID,
 SalesPersonID,
 CustomerID,
 ProductID,
 Quantity,
 Discount,
 TotalPrice,
 @SalesDate,
 TransactionNumber
)
SET SalesDate = NULLIF(@SalesDate, '');
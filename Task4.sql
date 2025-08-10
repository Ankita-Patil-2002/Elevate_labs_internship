create database ecommerce;
use ecommerce;
create table Ecommerce(
Customer_ID char,
Age	int,
Gender varchar(10),	
Income_Level varchar(20),	
Location varchar(100),	
Purchase_Category varchar(100),	
Purchase_Amount	float,
Frequency_of_Purchase int,	
Purchase_Channel varchar(100),	
Product_Rating int,
Time_Spent_on_Product_Research float,	
Social_Media_Influence varchar(20),	
Return_Rate	int,
Customer_Satisfaction int,	
Engagement_with_Ads	varchar(20),
Device_Used_for_Shopping varchar(100),	
Payment_Method	varchar(20),
Time_of_Purchase date,	
Discount_Used bool,	
Purchase_Intent	varchar(100),
Shipping_Preference varchar(100));
alter table ecommerce
modify Customer_ID varchar(50);
alter table Ecommerce
modify Time_of_Purchase varchar(100);
ALTER TABLE Ecommerce MODIFY Discount_Used VARCHAR(5);
alter table ecommerce
modify Gender varchar(50);
ALTER TABLE Ecommerce MODIFY Purchase_Amount VARCHAR(50);
SET sql_mode = '';

show variables like "secure_file_priv";
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce.csv" into table Ecommerce
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

select * from Ecommerce;
SET SQL_SAFE_UPDATES = 0;
UPDATE Ecommerce
SET Time_of_Purchase = STR_TO_DATE(Time_of_Purchase, '%d-%m-%Y');
SET SQL_SAFE_UPDATES = 1;  -- turn it back on after update

UPDATE Ecommerce
SET Purchase_Amount = REPLACE(REPLACE(Purchase_Amount, '$', ''), ',', '');
ALTER TABLE Ecommerce MODIFY Purchase_Amount DECIMAL(10,2);



#Q1. Find the high-income customers who made large purchases.
SELECT Customer_ID, Purchase_Category, Purchase_Amount, Time_of_Purchase
FROM Ecommerce
WHERE Income_Level = 'High' 
  AND Purchase_Amount > 400
ORDER BY Purchase_Amount DESC;

#Q2. Which purchase category generates the most revenue?
SELECT Purchase_Category,
       COUNT(*) AS Total_Orders,
       AVG(Purchase_Amount) AS Avg_Amount,
       SUM(Purchase_Amount) AS Total_Revenue
FROM Ecommerce
GROUP BY Purchase_Category
ORDER BY Total_Revenue DESC;

#Q3. Which customers spend above the average purchase amount?
SELECT Customer_ID, Purchase_Amount
FROM Ecommerce
WHERE Purchase_Amount > (
    SELECT AVG(Purchase_Amount)
    FROM Ecommerce
);

#Q4. Who are the frequent buyers and how much have they spent?
CREATE VIEW frequent_buyers AS
SELECT Customer_ID, 
       COUNT(*) AS Purchase_Count,
       SUM(Purchase_Amount) AS Total_Spent
FROM Ecommerce
GROUP BY Customer_ID;
select * from frequent_buyers;

#Q5. What is the monthly sales trend?
SELECT DATE_FORMAT(Time_of_Purchase, '%Y-%m') AS Month,
       SUM(Purchase_Amount) AS Monthly_Sales
FROM Ecommerce
GROUP BY Month
ORDER BY Month;

#Q6. Which device type generates the highest sales?
SELECT Device_Used_for_Shopping,
       SUM(Purchase_Amount) AS Total_Sales
FROM Ecommerce
GROUP BY Device_Used_for_Shopping
ORDER BY Total_Sales DESC;

#Q7. Improve query performance for frequent analysis.
CREATE INDEX idx_purchase_category ON Ecommerce(Purchase_Category);
CREATE INDEX idx_time_of_purchase ON Ecommerce(Time_of_Purchase);

#Q8. Which payment method is most popular and generates the most revenue?
SELECT Payment_Method,
       COUNT(*) AS Total_Transactions,
       SUM(Purchase_Amount) AS Total_Revenue
FROM Ecommerce
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;

#Q9. Which purchase channel has the highest customer satisfaction?
SELECT Purchase_Channel,
       AVG(Customer_Satisfaction) AS Avg_Satisfaction,
       COUNT(*) AS Total_Customers
FROM Ecommerce
GROUP BY Purchase_Channel
ORDER BY Avg_Satisfaction DESC;

#Q10. What is the return rate by product category?
SELECT Purchase_Category,
       AVG(Return_Rate) AS Avg_Return_Rate
FROM Ecommerce
GROUP BY Purchase_Category
ORDER BY Avg_Return_Rate DESC;







create database final_project;
use final_project;
/* task 1*/

SELECT Branch, 
       EXTRACT(YEAR FROM Date) AS year,
       EXTRACT(MONTH FROM Date) AS month,
       SUM(Total) AS monthly_sales,
       LAG(SUM(Total)) OVER (PARTITION BY Branch ORDER BY EXTRACT(YEAR FROM Date), EXTRACT(MONTH FROM Date)) AS prev_month_sales,
       (SUM(Total) - LAG(SUM(Total)) OVER (PARTITION BY Branch ORDER BY EXTRACT(YEAR FROM Date), EXTRACT(MONTH FROM Date))) / LAG(SUM(Total)) OVER (PARTITION BY Branch ORDER BY EXTRACT(YEAR FROM Date), EXTRACT(MONTH FROM date)) * 100 AS growth_rate
FROM sales_data
GROUP BY Branch, year, month
ORDER BY Branch, year, month;


/*task 2*/
SELECT Branch, Product_line, 
       SUM(gross_income - cogs) AS profit
FROM sales_data
GROUP BY Branch, product_line
ORDER BY Branch, profit DESC;

/*task 3*/

SELECT CustomerID, 
       CASE 
           WHEN AVG(Total) >= 322 THEN 'High'
           WHEN AVG(Total) BETWEEN 161 AND 322 THEN 'Medium'
           ELSE 'Low'
       END AS spending_tier
FROM sales_data
GROUP BY CustomerID;

/* Task 4 */
-- Identifying sales anomalies per product line

SELECT *,
       AVG(Total) OVER (PARTITION BY Product_line) AS avg_sales,
       STDDEV(Total) OVER (PARTITION BY Product_line) AS std_dev,
       CASE 
           WHEN Total > AVG(Total) OVER (PARTITION BY Product_line) + 3 * STDDEV(Total) OVER (PARTITION BY Product_line) THEN 'High Anomaly'
           WHEN Total < AVG(Total) OVER (PARTITION BY Product_line) - 3 * STDDEV(Total) OVER (PARTITION BY Product_line) THEN 'Low Anomaly'
           ELSE 'Normal'
       END AS anomaly_type
FROM sales_data;


/* Task 5*/

select City,Payment ,count(Payment) as usage_payment
from sales_data
group by City,Payment;

/* Task 6 */

SELECT EXTRACT(MONTH FROM Date) AS month, Gender, SUM(Total) AS total_sales
FROM sales_data
GROUP BY Month, Gender
ORDER BY Month, Gender;



/* Task 7*/

SELECT Customer_type, Product_line, COUNT(*) AS count
FROM sales_data
GROUP BY Customer_type, Product_line
ORDER BY Customer_type, count DESC;


/* Task 8*/

SELECT DISTINCT CustomerID
FROM (
    SELECT CustomerID, Date,
           LEAD(Date) OVER (PARTITION BY CustomerID ORDER BY Date) AS NextPurchaseDate
    FROM sales_data
) AS Purchases
WHERE NextPurchaseDate IS NOT NULL AND NextPurchaseDate <= Date + INTERVAL '30 days';


/* Task 9*/
SELECT CustomerID, SUM(Total) AS total_sales
FROM sales_data
GROUP BY CustomerID
ORDER BY total_sales DESC
LIMIT 5;



/* Task 10 */
SELECT EXTRACT(week FROM Date) AS day_of_week, SUM(Total) AS total_sales
FROM sales_data
GROUP BY day_of_week
ORDER BY day_of_week;

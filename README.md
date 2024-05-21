# Case Study - Orders

# Contents
.Introduction
.Key Analysis Objectives
.Case Study Question & Answers
. Additional Analysis

# Introduction
Welcome to the Customer Order Analysis repository. 
This project focuses on analyzing customer order data to derive 
meaningful insights and performance metrics. The repository includes a 
variety of SQL queries designed to answer key business questions and
provide a comprehensive view of customer behaviors, order trends, and sales performance.

# Key Analysis Objectives
## Total Revenue Calculation:

.Determine the overall revenue generated from all orders.

## Top Customer Revenue Analysis:
.Calculate the total revenue contributed by the top 25 customers based on their order totals.

## Order Count Metrics:
.Compute the total number of orders.
. Determine the number of orders placed by the top 10 customers.

## Customer Order Frequency:
. Identify the number of customers who ordered once.
.Identify the number of customers who ordered multiple times.

## Referral Insights:

.Calculate the number of customers who referred others.
.Identify the locations with the maximum referrals.

## Monthly Revenue Trends:

.Determine which month had the highest revenue.

## Customer Activity Analysis:
.Count inactive customers who haven't ordered in the last 60 days.
.Calculate the growth rate in orders over specific periods.

## Demographic Insights:
.Calculate the percentage of male and female customers.
.Determine the acquisition channels that are most effective.

## Order Characteristics:
.Identify the number of returned orders.
.Calculate the percentage of cancelled orders.
.Determine the percentage of orders placed by happy customers.

## Location-Based Analysis:
.Identify locations with the most and least customers.
.Determine the locations with the highest number of discounted orders.
.Calculate the order value from male customers in specific locations.
.Identify locations with maximum late deliveries.

## Customer Acquisition Channels:
.Analyze which acquisition channel is most effective.
.Determine the percentage of male customers acquired via specific channels.

## Additional Insights:
.Count the total number of delayed deliveries.
.Determine the number of customers who made purchases without receiving a discount


# Case Study Questions & Solutions 

## Qno 1: What is the Total revenue based on the order value?

select sum (Order_total) as total_revenue  
from order_data
## Explanation: This query calculates the total revenue by summing up the order_total values for all orders in the order_data table. 
The SUM function aggregates the total revenue across all records.

## Qno 2: Calculate the total revenue for the top 25 customers based on their order totals.

Select sum(total_revenue ) as tot_revenue
from (
    select top 25 
    customer_key,
    SUM(order_total) as total_revenue 
    from order_data 
    group by customer_key
    order by total_revenue desc
) as X
## Explanation: This query first selects the top 25 customers with the highest total revenue by summing order_total values for each customer_key. 
It then sums the total revenues of these top 25 customers to provide the overall total revenue from the top customers.

## Qno 3: What is the total order count?

Select COUNT(*) as [No.of.orders]
from [order_data]
## Explanation: This query counts the total number of orders in the order_data table using the COUNT function, 
which counts the number of rows.

## Qno 4: Total orders by top 10 customers.

select sum (no_of_cust) as [total orders] 
from (
    select top 10 customer_key, ORDER_NUMBER, count(customer_key) as no_of_cust
    from [order_data]
    group by CUSTOMER_KEY, ORDER_NUMBER
    order by ORDER_NUMBER desc
) as X
## Explanation: This query counts the number of orders made by the top 10 customers by ORDER_NUMBER, 
grouping by customer_key and ORDER_NUMBER. The sum of these counts gives the total orders by these customers.

# Qno 6: Number of customers ordered once.

select distinct customer_key, count(customer_key) as [occurence]
from [order_data]
group by CUSTOMER_KEY
having (count(customer_key) = 1)
## Explanation: This query identifies customers who have placed only one order. 
It groups the records by customer_key and uses HAVING to filter out customers with exactly one order.

## Qno 7: Number of customers ordered multiple times.

select customer_key, count(customer_key) as [occurence]
from [order_data]
group by CUSTOMER_KEY
having (count(customer_key) > 1)
## Explanation: This query identifies customers who have placed more than one order. 
It groups by customer_key and uses HAVING to filter out customers with more than one order.

## Qno 8: Number of customers referred to other customers.

select COUNT(Referred_Other_customers) as [No.of referred], Referred_Other_customers
from [cust_data]
group by Referred_Other_customers
having COUNT(Referred_Other_customers) > 0
## Explanation: This query counts the number of customers who have referred others. 
It groups by Referred_Other_customers and filters to include only those who have made referrals.

## Q9. Which month has maximum revenue.

SELECT TOP 1 YEAR(order_date) AS [year], MONTH(order_date) AS [Month], SUM(order_total) AS [Total revenue]
FROM order_data
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY [Total revenue] DESC
## Explanation: This query calculates the total revenue for each month and year, 
then selects the month with the highest total revenue.

## Q10. Number of inactive customers (who have not ordered in the last 60 days).

SELECT COUNT(*) AS [inactive customers]
FROM cust_data
WHERE CUSTOMER_KEY NOT IN (
    SELECT DISTINCT CUSTOMER_KEY
    FROM order_data
    WHERE ORDER_DATE >= DATEADD(day, -60, (SELECT MAX(order_date) FROM order_data))
)
## Explanation: This query identifies customers who have not placed any orders in the 
last 60 days by comparing the customer keys in the cust_data table with those who have recent orders.

## Q11. Growth rate % in orders from Nov 15th to July 16th.

SELECT *,
    LAG(Tot_orders, 1) OVER (ORDER BY months) AS Prev_orders,
    (Tot_orders - LAG(Tot_orders, 1) OVER (ORDER BY months)) / (LAG(Tot_orders, 1) OVER (ORDER BY months)) * 100 AS Amt_diff
FROM (
    SELECT MONTH(order_date) AS months, SUM(order_total) AS Tot_orders
    FROM order_data
    GROUP BY MONTH(order_date)
) AS X
## Explanation: This query calculates the total number of orders per month and then uses the LAG function 
to compare the current month's total orders with the previous month's total orders to compute the growth rate percentage.

## Q13. Percentage of male customers.

SELECT COUNT(gender) AS total_customers,
       COUNT(CASE WHEN gender = 'M' THEN 1 END) AS Male_customers,
       (COUNT(CASE WHEN gender = 'M' THEN 1 END) * 100 / COUNT(gender)) AS percentage_male
FROM cust_data
## Explanation: This query calculates the percentage of male customers by counting 
the total number of customers and the number of male customers, then computing the percentage.

## Q14. Which location has maximum customers.

SELECT CUSTOMER_KEY, MAX(location) AS max_customers
FROM cust_data
GROUP BY customer_key
ORDER BY max_customers DESC
## Explanation: This query finds the location with the maximum number of customers by grouping the 
customer data by location and ordering by the count of customers in descending order.

## Q15. How many orders are returned (orders with a negative total value).

SELECT COUNT(*)
FROM order_data
WHERE order_total < 0
## Explanation: This query counts the number of returned orders by filtering for orders with a negative total value.

## Q16. Which acquisition channel is more efficient in terms of customer acquisition?

SELECT COUNT(acquired_channel), acquired_channel
FROM cust_data
GROUP BY acquired_channel
ORDER BY COUNT(acquired_channel) DESC
## Explanation: This query determines the most efficient customer acquisition channel by 
counting the number of customers acquired through each channel and ordering by the count in descending order.

## Q17. Which locations have more orders with a discount amount?

SELECT Location, COUNT(location) AS [locations], COUNT(ORDER_NUMBER) AS [orders], SUM(discount) AS [discount]
FROM order_data AS T1
INNER JOIN cust_data AS T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
GROUP BY Location
ORDER BY COUNT(ORDER_NUMBER) DESC
## Explanation: This query identifies locations with the highest number of discounted orders 
by joining order data with customer data, grouping by location, and counting the number of orders and discounts.

## Q18. Which location has the maximum orders delivered late?

SELECT COUNT(ORDER_NUMBER) AS [orders], Location
FROM order_data AS T1
INNER JOIN cust_data AS T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
WHERE DELIVERY_STATUS = 'late'
GROUP BY Location
ORDER BY COUNT(ORDER_NUMBER) DESC
## Explanation: This query finds locations with the most late deliveries by joining order 
data with customer data, filtering for late deliveries, and counting the number of such orders per location.

## Q19. Percentage of male customers acquired through App channels.

SELECT COUNT(gender) AS total_customers,
       SUM(CASE WHEN gender = 'm' THEN 1 ELSE 0 END) AS male_customers,
       (SUM(CASE WHEN gender = 'm' THEN 1 ELSE 0 END) * 100 / COUNT(gender)) AS percentage_male
FROM cust_data
WHERE acquired_channel = 'App'
## Explanation: This query calculates the percentage of male customers acquired 
through the App channel by counting the total and male customers in this channel and computing the percentage.

## Q20. Percentage of orders that got cancelled.

SELECT COUNT(order_number) AS total_orders,
       SUM(CASE WHEN order_status = 'cancelled' THEN 1 END) AS cancelled_orders,
       (SUM(CASE WHEN order_status = 'cancelled' THEN 1 END) * 100 / COUNT(order_number)) AS percentage_cancelled
FROM order_data
## Explanation: This query calculates the percentage of cancelled orders by counting the 
total orders and the number of cancelled orders, then computing the percentage of cancellations.

## Q21. Percentage of orders done by happy customers.

SELECT COUNT(order_number) AS total_orders,
       SUM(CASE WHEN referred_other_customers = 1 THEN referred_other_customers ELSE 0 END) AS happy_orders,
       (SUM(CASE WHEN referred_other_customers = 1 THEN referred_other_customers ELSE 0 END) * 100 / COUNT(order_number)) AS percentage_happy
FROM order_data AS T1
JOIN cust_data AS T2 ON T1.customer_key = T2.customer_key
## Explanation: This query calculates the percentage of orders placed by happy customers 
(those who referred other customers) by counting the total orders and the orders by happy customers, then computing the percentage.

## Q22. Which location has the maximum customers through reference?

SELECT location, COUNT(Referred_Other_customers) AS referred_cust
FROM cust_data
GROUP BY location
HAVING COUNT(Referred_Other_customers) >= 1
ORDER BY COUNT(Referred_Other_customers) DESC
## Explanation: This query identifies locations with the most customers who referred 
others by counting referrals per location and ordering by the count in descending order.

## Q23. Order total value of male customers from Chennai who are happy customers.

SELECT SUM(order_total) AS sum_ord_total
FROM order_data AS T1
INNER JOIN cust_data AS T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
WHERE T2.Gender = 'M' AND T2.Location = 'Chennai' AND T2.Referred_Other_customers = 1
## Explanation: This query calculates the total order value for male customers 
from Chennai who referred other customers by summing their order totals.

## Q24. Which month has the maximum order value from male customers in Chennai?

SELECT order_date, MONTH(order_date) AS Months, SUM(order_total) AS order_value
FROM order_data AS T1
INNER JOIN cust_data AS T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
WHERE T2.Gender = 'M' AND T2.Location = 'Chennai'
GROUP BY order_date
ORDER BY SUM(order_total) DESC
## Explanation: This query determines the month with the highest order value from 
male customers in Chennai by summing their order totals and ordering by the highest total.

## Q25. Number of discounted orders by female customers acquired via website from Bangalore delivered on time.

SELECT COUNT(discount) AS discounted_orders, COUNT(order_number) AS order_count, Gender, Location, Acquired_Channel
FROM order_data AS T1
INNER JOIN cust_data AS T2 ON T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
WHERE T2.Gender = 'f' AND T2.Acquired_Channel = 'website' AND T2.Location = 'Bangalore' AND T1.DELIVERY_STATUS = 'On-time' AND DISCOUNT > 0
GROUP BY Acquired_Channel, Gender, Location
## Explanation: This query counts the number of discounted orders placed by female 
customers acquired through the website from Bangalore and delivered on time by filtering and grouping the data accordingly.

# Q26. Additional analyses:
## i) Total number of delayed deliveries.

SELECT delivery_status, COUNT(Delivery_status) AS delayed_deliveries
FROM order_data
WHERE delivery_status = 'Late'
GROUP BY delivery_status
## Explanation: This query counts the number of deliveries marked as 
'Late' by grouping by the delivery status and filtering for 'Late' deliveries.

## ii) Percentage of female customers.

SELECT COUNT(gender) AS total_customers,
       SUM(CASE WHEN gender = 'f' THEN 1 END) AS female_customers,
       (SUM(CASE WHEN gender = 'f' THEN 1 END) * 100 / COUNT(gender)) AS percentage_female
FROM cust_data
## Explanation: This query calculates the percentage of female customers by 
counting the total and female customers and computing the percentage.

## iii) Which location has the minimum customer base?

SELECT location, COUNT(customer_id) AS customer_base
FROM cust_data
GROUP BY location
ORDER BY COUNT(customer_id)
## Explanation: This query identifies the location with the smallest number of 
customers by counting customers per location and ordering by the count in ascending order.

## iv) Number of customers who did not refer other customers.

SELECT COUNT(customer_id) AS [customers], referred_other_customers
FROM cust_data
WHERE referred_other_customers = 0
GROUP BY referred_other_customers
## Explanation: This query counts the number of customers who have not referred 
other customers by filtering for those with zero referrals.

## v) Customers with no discount on purchase.

SELECT COUNT(customer_key), discount
FROM order_data
WHERE discount = 0
GROUP BY discount
## Explanation: This query counts the number of customers who did not receive a 
discount on their purchase by filtering for orders with zero discounts





























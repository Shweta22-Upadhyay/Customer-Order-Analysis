--------------------------------------------Task 1-------------------------------------------------------
--Qno 1. What is the Total revenue based on the order value?

--Ans no. 1
select sum (Order_total) as total_revenue  
from order_data 

--Qno 2.calculate the total revenue for the top 25 customers based on their order totals.
--Ans no.2
Select sum(total_revenue ) as tot_revenue
from( select top 25 
customer_key ,
SUM(order_total) as total_revenue 
from order_data 
group  by customer_key
order by total_revenue desc) as X 


--Qno 3.What is the total order count?

--Ans 3.
Select COUNT(*) as [No.of.orders]
from [order_data]

--Ans no. 4 ( Total orders by top 10 customers ).


select   sum (no_of_cust) as [total orders] 
from (Select top 10 customer_key , ORDER_NUMBER, count(customer_key) as no_of_cust
      from [order_data ]
      group by CUSTOMER_KEY ,   ORDER_NUMBER
      order by ORDER_NUMBER desc
 ) as X


--Ans no. 6 (Number of customers ordered once ).
select distinct  customer_key , count(customer_key) as [occurence]
from [order_data ]
group by  CUSTOMER_KEY
having (count(customer_key) = 1)

--Ans no. 7 (Number of customers ordered multiple times).
select   customer_key , count(customer_key) as [occurence]
from [order_data ]
group by  ( CUSTOMER_KEY)
having (count(customer_key) > 1) 

--Ans no. 8 (Number of customers referred to other customers ).
select   COUNT(Referred_Other_customers) as [No.of referred], Referred_Other_customers
from [cust_data ]
group by Referred_Other_customers
having COUNT(Referred_Other_customers)> 0

--Ans no. 9 (Which month have max. revenue).
Select top 1 YEAR(order_date) as [year], MONTH (order_date) as [Month], SUM(order_total) as [Total revenue]
from order_data
group by YEAR(order_date), MONTH (order_date)
order by [Total revenue] desc


--Ans 10.Number of customers are inactive.(That have not ordered in the last 60 days).
Select COUNT(*) as [inactive customers]
from [cust_data ]
where CUSTOMER_KEY not in (
select distinct CUSTOMER_KEY from [order_data ]
where ORDER_DATE>= DATEADD (day,-60, (select max(order_date)from [order_data ])))



--Ansno11. Growth rate % in orders from nov15th to july 16th.
select *
LAG  (Tot_orders , 1) over (order by months) as Prev_orders,
Tot_orders - lag (Tot_orders,1) over (order by months) as Amt_diff / (LAG  (Tot_orders , 1) over (order by months) as Prev_orders)*100 
from ( 
       select MONTH(order_date) as months ,sum (order_total) as Tot_orders
       from [order_data ]
       group by month(ORDER_DATE)
      ) As X


---Ans 13.What is the percentage of male customers exist ?
SELECT count(gender) AS total_customers,
   count(CASE WHEN gender = 'M' THEN 1 END) AS Male_customers,
  (count(CASE WHEN gender = 'M' THEN 1  END) * 100 / count(gender) ) AS percentage_male
  FROM cust_data

---Ans 14.Which location has maximum customers ?
select CUSTOMER_KEY , MAX(location) as max_customers
from [cust_data ]
group by customer_key
order by max_customers desc

---Ans 15.How many orders are returned ?(returns can be found if the total order value is -ve value).
select   count(*)
from [order_data ]
where(order_total) < 0


---Ans 16.Which acquistion chnnel is more efficient in terms of customer acquisition?
select count(acquired_channel) , acquired_channel 
from cust_data
group by acquired_channel  
order by count(acquired_channel) desc 

--Ans 17. Which locations having more orders with discount amount ?
select Location, count (location) as [locations], count(ORDER_NUMBER)as [orders], sum (discount) as[discount]
from [order_data ] as T1
inner join [cust_data ] as T2
on T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
group by Location
order by count(ORDER_NUMBER) desc

--Ans 18. Which location having max. orders delivered in delay ?

select count( ORDER_NUMBER) as [orders], Location
from [order_data ] as T1
inner join [cust_data ] as T2
on T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
where DELIVERY_STATUS = 'late' 
group by Location
order by count( ORDER_NUMBER) desc

--Ans 19. What is the % of customers who are males acquired by App channels?
SELECT
  COUNT(gender) AS total_customers,
  SUM(CASE WHEN gender = 'm' THEN 1 ELSE 0 END) AS male_customers,
  SUM(CASE WHEN gender = 'm' THEN 1 ELSE 0 END)* 100 / COUNT(gender)  AS percentage_male
FROM  cust_data
  WHERE acquired_channel = 'App'
  

---Ans 20.What is the % of orders got cancelled ?

  SELECT 
	    COUNT(order_number) AS total_orders,
	  SUM(CASE WHEN order_status = 'cancelled' THEN 1 END) AS cancelled_orders,
	  SUM(CASE WHEN order_status = 'cancelled' THEN 1 END )* 100 / COUNT(order_number) AS percentage_cancelled
	FROM
	  order_data

	
--Ans 21. What is the %of orders done by happy customers ?

SELECT
  COUNT(order_number) AS total_orders,
  SUM(CASE WHEN referred_other_customers = 1 THEN referred_other_customers ELSE 0 END) AS happy_orders,
  (SUM(CASE WHEN referred_other_customers = 1 THEN referred_other_customers ELSE 0 END)* 100 / COUNT(order_number) ) AS percentage_happy
FROM order_data as T1
join cust_data as T2
on T1.customer_key = T2.customer_key
  

---Ans 22.Which location having max. customers through reference ?
select location ,count( Referred_Other_customers) as referred_cust
from [cust_data ]
group by Location
having count( Referred_Other_customers) >= 1
order by count ( Referred_Other_customers) desc

--Ans 23.  What is order_total value of male customers who are belongs to Chennai and
--happy customers ?

select   sum(order_total) as sum_ord_total 
from  [order_data ] as T1
inner join [cust_data ] as T2
on T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
where Gender = 'M' and Location = 'Chennai'and Referred_Other_customers = 1



--Ans 24. Which month having max order value from male customers belong to Chennai?

Select order_date , month (order_date) as Months , sum(order_total) as order_value 
from [order_data ] as T1
inner join [cust_data ] as T2
on T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
where T2.Gender = 'M' and 
T2.Location = 'Chennai'
group by order_date 
order by sum(order_total) desc

--Ans 25. What are the no. of discounted orders ordered by female customers who were acquired by 
--website from Bangalore delivered on time ?

select count(discount) as discounted_orders , count(order_number) as order_count , Gender, Location,
Acquired_Channel
from [order_data ] as T1
inner join [cust_data ] as T2
on T1.CUSTOMER_KEY = T2.CUSTOMER_KEY
where T2.Gender = 'f' and T2.Acquired_Channel = 'website'
and T2.Location = 'Bangalore' and T1.DELIVERY_STATUS = 'On-time' and DISCOUNT>0
group by Acquired_Channel,Gender, Location


---Qno.26) 5 Additional analysis.

--Qno i) Total number of delayed deliveries ?
select delivery_status ,count(Delivery_status) as delayed_deliveries
from order_data
where delivery_status = 'Late'
group by delivery_status

--Qno ii) Percentage of female customers ?

SELECT
  count(gender) AS total_customers,
  SUM(CASE WHEN gender = 'f' THEN 1 END) AS female_customers,
  SUM(CASE WHEN gender = 'f' THEN 1  END)* 100 / count(gender) AS percentage_female
FROM cust_data
  

---Qno iii)Which location has minimum customer base ?
select location , count (customer_id) as customer_base
from cust_data
group by location 
order by count (customer_id) 

--Qno iv) Number of customers not referred other customers?
select count(customer_id) as [customers], referred_other_customers
from cust_data
where referred_other_customers =0
group by referred_other_customers

--Qno v) Customers with no discount on purchase?
select count(customer_key) ,discount
from order_data
where discount = 0
group by discount





			

	  




     



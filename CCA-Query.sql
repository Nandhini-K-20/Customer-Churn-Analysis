use customers_churn;
-- (1.Basic Filtering)

-- 1. List all customers who signed up in the year 2023.
select * from customers where year(signup_date)=2023;

-- 2. Retrieve customers whose acquisition_channel is either 'Referral' or 'Organic'.
select * from customers where acquisition_channel in('referral','organic');

-- 3.Find all billing_transactions where payment_status = 'Failed'.
select * from billing_transactions where payment_status ='failed';

-- (2.Sorting & Aggregate function)

-- 4. List the top 10 highest billing_transactions by amount.
select * from billing_transactions order by amount desc limit 10 ;		

-- 5. Count the total number of customers per country.
select country,count(*) as total_customers 
from customers group by country;

-- 6. List all customers ordered by signup_date, most recent first.
select * from customers order by signup_date desc;

-- 7. Find the average monthly_price across all subscription_plans.
select avg(monthly_price) as  average_monthly_price
from subscription_plans;

-- (3.Group by & Having)

-- 8. Find subscription plans with more than 500 active subscriptions.
select plan_id, COUNT(*) as active_subscriptions
from subscriptions where status = 'active'
group by plan_id having COUNT(*) > 500;

-- 9. Find churn_reason categories that account for more than 50 churned customers.
select churn_reason, count(*) as churn_count
from churn_events group by churn_reason having count(*) >50;

-- 10.Find the number of customers acquired through each acquisition_channel.
select acquisition_channel, count(*) as customer_count 
from customers group by  acquisition_channel ;

-- (4.Joins)

-- 11. List each customer along with the name of their current subscription plan.
select c.customer_id, c.first_name, sp.plan_name
from customers c
join subscriptions s 
ON c.customer_id = s.customer_id
JOIN subscription_plans sp 
ON s.plan_id = sp.plan_id;






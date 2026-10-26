
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

-- 12. Find all support tickets along with the customer's name and email.
select sp.ticket_id, c.first_name, c.last_name, c.email
from customers c
join support_tickets sp
on c.customer_id = sp.customer_id;

-- 13.List churned customers with their churn_reason and the plan they were on when they churned.
select ce.customer_id, sp.plan_name, ce.churn_reason
from churn_events ce
join subscriptions s
on ce.subscription_id = s.subscription_id
join subscription_plans sp
on s.plan_id = sp.plan_id;

-- 14. Find customers who have never raised a support ticket (use a LEFT JOIN).
select c.customer_id, c.first_name, c.last_name
from customers c
left join support_tickets st
on c.customer_id = st.customer_id
where st.customer_id is null;
 
-- 15. List campaign_interactions along with the campaign_name and the customer's email.
select ci.interaction_id,c.email, mc.campaign_name
from campaign_interactions ci
join  marketing_campaigns mc 
on ci.campaign_id =mc.campaign_id
join customers c
on ci.customer_id=c.customer_id;

-- (5. Subqueries)

-- 16. Find customers whose total billed amount is above the average billed amount of all customers.
select customer_id, sum(amount) as total_billed
from billing_transactions
group by customer_id
having sum(amount) > (
    select avg(total_billed)
    from (
        select customer_id, sum(amount) as total_billed
        from billing_transactions
        group by customer_id
    ) as customer_totals
);

-- 17.Find the plan_id with the highest number of subscriptions using a subquery. 
select plan_id, count(*) as subscription_count
from subscriptions
group by plan_id
having count(*) = (
    select max(subscription_count)
    from (
        select plan_id, count(*) as subscription_count
        from subscriptions
        group by plan_id
    ) as plan_counts
);

-- 18.Find customers who churned within 30 days of their signup_date using a correlated subquery.
select c.customer_id, c.signup_date
from customers c
where exists (
    select 1
    from churn_events ch
    where ch.customer_id = c.customer_id
      and ch.churn_date <= c.signup_date + interval 30 day
);

-- 19.List customers whose nps_score is below the overall average nps_score.
select customer_id, first_name, last_name
from customers
where customer_id in(
select customer_id
from customer_feedback where nps_score < (
select avg(nps_score) as overall_nps_score
from customer_feedback
)
);

-- (6. Window Functions)

-- 20. Rank customers by total billing amount using RANK().
select customer_id, sum(amount) as total_billing,
    rank() over (order by sum(amount) desc) as billing_rank
from billing_transactions
group by customer_id;

-- 21. Calculate a running total of billing_transactions amount ordered by transaction_date.
select transaction_date, amount,sum(amount)
over (order by transaction_date, transaction_id) as running_total
from billing_transactions;

-- (7. CTEs & Recursive Queries)

-- 22. Write a CTE to calculate total spend per customer, then filter to customers who spent over $500.
with customer_spend as (
    select customer_id,
           sum(amount) as total_spend
    from billing_transactions
    group by customer_id
)
select customer_id, total_spend
from customer_spend
where total_spend > 500;

-- 23. Use a CTE to calculate the average ticket resolution time per issue_category.
with ticket_resolution as (
    select issue_category,
        TIMESTAMPDIFF(HOUR, created_date, resolved_date) as resolution_hours
    from support_tickets
    where resolved_date is not null
)
select
    issue_category,
    round(avg(resolution_hours), 2) as avg_resolution_hours
from ticket_resolution
group by issue_category;

-- (8. Date & String Functions)

-- 24. Find the number of days between signup_date and churn_date for each churned customer.
select c.customer_id, c.signup_date, ch.churn_date,
    datediff(ch.churn_date, c.signup_date) as days_between
from customers c
join churn_events ch on c.customer_id = ch.customer_id  
where ch.churn_date is not null;

-- 25.Find all customers whose email domain is 'gmail.com'.  
select customer_id, first_name, email
from customers
where email like '%@gmail.com';

-- 26.Find customers who signed up on a weekend.
select customer_id, first_name, signup_date
from customers
where dayofmonth(signup_date) in (1, 7);

-- (9. CASE Statements & Conditional Logic)

-- 27. Use a CASE statement to label subscriptions as 'High Value', 'Medium Value', or 'Low Value' based on monthly_price.
select s.subscription_id, sp.monthly_price,
    case
        when monthly_price >= 1000 then 'High Value'
        when monthly_price >= 500 then 'Medium Value'
        else 'Low Value'
    end as value_category
from subscriptions s
join subscription_plans sp on s.plan_id = sp.plan_id;

-- 28.Use CASE inside SUM() to count Active vs Cancelled subscriptions in a single query.
select sum(case
            when status = 'Active' then 1
            else 0
        end) as active_count,

    sum(case
            when status = 'Cancelled' then 1
            else 0
        end) as cancelled_count
from subscriptions;

-- 29. Group churn_reason values into broader categories: 'Price-related', 'Service-related', and 'Other'.
select churn_reason,
    case
        when churn_reason in ('Too Expensive', 'High Price', 'Pricing')
            then 'Price-related'

        when churn_reason in ('Poor Service', 'Technical Issues', 'Customer Service')
            then 'Service-related'
        else 'Other'
    end as churn_category
from churn_events;

-- (10. Views, Indexes & Set Operations)

-- 30.Create a view named active_customers_view showing only currently active customers.
create view active_customers_view as
select * from customers where status = 'Active';

-- 31. Write a query using UNION to combine churned customers and at-risk customers into a single result set.
SELECT customer_id, 'Churned' AS customer_status
FROM churn_events
UNION
SELECT customer_id, 'At Risk' AS customer_status
FROM customer_feedback
WHERE nps_score < 50;






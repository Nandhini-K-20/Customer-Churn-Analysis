Customer Churn Analysis
Project Overview
Customer churn (customers cancelling or not renewing their service) is one of the biggest threats to a subscription-based business. Acquiring a new customer usually costs far more than retaining an existing one.
In this project, I:
•	Imported raw CSV data into MySQL
•	Designed a relational database with 10 interconnected tables
•	Defined primary keys, foreign keys, and indexes
•	Cleaned and validated the data using SQL
•	Wrote 30 SQL queries to analyze churn patterns
•	Built an ER diagram to document table relationships
Objectives
•	Calculate overall and segment-wise churn rates
•	Identify the key drivers of churn
•	Quantify revenue lost due to churn
•	Segment customers by risk and value
•	Provide data-backed recommendations to improve retention
Business Problem
The company is losing customers and wants to answer:
•	What percentage of customers are churning?
•	Which customer segments (contract, region, demographics) churn the most?
•	Does tenure, pricing, or payment method influence churn?
•	How much revenue is being lost because of churn?
•	Which customers are at high risk of leaving next?
•	Do support issues and service types affect churn?



Tools & Technologies
Tool	Purpose
MySQL 8.0	Database & query execution
MySQL Workbench	Data import, query development, ER diagram
SQL	Data cleaning, analysis, reporting
GitHub	Version control & portfolio


SQL Concepts Used
Category	Concepts
Database Design	Primary keys, foreign keys, constraints, indexes, normalization
Data Cleaning	NULL handling, duplicate detection, TRIM, COALESCE, data type conversion
Joins	INNER JOIN, LEFT JOIN, multi-table joins
Aggregation	COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
Conditional Logic	CASE WHEN, IF
Subqueries	Scalar, correlated, and nested subqueries
CTEs	Common Table Expressions (WITH)
Window Functions	RANK(), DENSE_RANK(), ROW_NUMBER(), SUM() OVER(), running totals
Date Functions	DATE_FORMAT, DATEDIFF, TIMESTAMPDIFF, MONTH, YEAR
Database Objects	Views, stored procedures

ER Diagram
      #Customer_churn_ER diagram
Sample Queries
 List the top 10 highest billing_transactions by amount.
select * from billing_transactions order by amount desc limit 10 ;	

Count the total number of customers per country.
select country,count(*) as total_customers 
from customers group by country;	

How to Run the Project
Step 1: Install MySQL
Install:
•	MySQL Server
•	MySQL Workbench
Step 2: Create Database
CREATE DATABASE customers_churn;
USE scustomers_churn ;
Step 3: Import SQL File
Import the provided .sql file into MySQL Workbench.
Step 4: Execute Queries
Run analytical queries and generate reports.

Author
Nandhini K
•	MSC – Vels university
•	Interested in Python, SQL, AI/ML, LLM

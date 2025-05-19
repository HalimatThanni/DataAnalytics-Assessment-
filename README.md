# Adashi DataAnalytics-Assessment

<img width="1000" height="500" alt="card-3" src="https://github.com/user-attachments/assets/3e1ed855-7759-4135-abba-1345f080c90d" />

## Introduction
Hello! My name is Halimat Thanni, and this repository contains the SQL queries I developed as part of a data analytics proficiency assessment. The task involved analyzing customer and transaction data for a financial platform, across savings and investment plans.

In this report, I’ll be walking you through my thought process for each of the four SQL questions, the specific approach I took, and some of the challenges I encountered along the way as I worked towards refining my queries to meet the expected outcomes.

## Questions 1: High-Value Customers Identification
This question requires that I identify high-value customers by determining customers with at least one savings account (with confirmed inflows) and one investment plan (that qualifies as a fund). For each customer, return their total deposits, number of savings accounts, number of investment plans, and basic personal info.

**Approach:**
For this question, I began by creating two separate Common Table Expressions (CTEs): The Savings CTE and Investment CTE.

For the Savings CTE, I counted the number of savings accounts per customer where confirmed_amount > 0 and summed their total deposits. Then for Investment CTE, I counted investment plans where is_a_fund = 1 and amount > 0.
I then joined these CTEs with the users_customuser table using the owner_id foreign key to fetch the customer’s details.
To handle missing names, I used COALESCE to replace null values with 'John Doe'.

**Challenges:**
Initially, I faced mismatches with column names because of assumptions about fields that didn’t exist or weren’t properly referenced. I corrected this by carefully reviewing the database schema and consistently using actual columns like confirmed_amount for savings inflow and is_a_fund for investments.
Another hurdle was ensuring customers only appeared if they had both a qualifying savings account and investment plan. I resolved this by using COALESCE defaults and a WHERE clause to enforce the required minimum counts.

## Question 2: Transaction Frequency Analysis
Here, I am required to analyse how frequently customers make transactions, categorise them into frequency tiers (High, Medium, Low), and return the number of customers in each category and their average transactions per month.

**Approach:**
I created a CTE to count transactions for each customer and calculated the total months between their first and latest transaction dates. Using this, I computed the average number of transactions per month for each customer. Then, in a second CTE, I categorised customers based on their average transaction frequency using CASE logic:
- High Frequency: ≥ 10 transactions/month
- Medium Frequency: 3–9 transactions/month
- Low Frequency: < 3 transactions/month

Finally, I aggregated the customer counts and average transactions per category.

**Challenges:**
The key issue here was calculating the correct number of months. Initially, I had to ensure that months weren’t zero (to avoid division errors) and adjusted by adding +1 in the denominator. I also had to double-check that the date columns used were consistent (created_on from the savings table).

## Question 3: Inactivity Alerts
I am to identify inactive customers who haven't performed any savings or investment transaction in over a year (365 days).

**Approach:**
I created a CTE called inactivity_report, combining:
- The most recent transaction date per plan_id and owner_id in the savings table.
- The creation date of each investment plan.

I then calculated the number of days since each transaction using DATEDIFF(NOW(), last_transaction_date) and filtered for those over 365 days.

**Challenges:**
The main hurdle was handling the CTE execution. I mistakenly thought the CTE would persist like a temporary table when run separately. To debug this, I first executed just the CTE block to view results, then followed up with the final query. I also had to correct the placement of LIMIT (which belongs at the end of the full query, not within the CTE block).

Additionally, combining UNION ALL results while maintaining an ORDER BY within the CTE caused errors, so I moved ordering to the final SELECT instead.

## Question 4: Customer Lifetime Value (CLV) Estimation
The requirement is to estimate the Customer Lifetime Value (CLV) for each customer based on the number of transactions and their tenure.

**Approach:**
I calculated:
- Customer tenure in months using TIMESTAMPDIFF.
- Total number of transactions from the savings table.
- Estimated CLV by multiplying the transaction count per month by 12 (to annualise) and applying a monetary conversion factor (0.001, since amounts are in Kobo).

I joined this with the users_customuser table to fetch customer details and ordered the results by estimated CLV in descending order.

**Challenges:**
One recurring issue was that customer names kept returning as null. On investigation, I confirmed the name column allowed nulls by default (DEFAULT NULL). To keep the output clean and informative, I applied COALESCE again to substitute 'John Doe' wherever the name was missing.


## Conclusion
This assessment allowed me to demonstrate practical SQL query-building skills for financial data analysis, from identifying high-value customers to estimating lifetime value. While some challenges arose around schema alignment and query structuring, debugging through iterative testing improved the final outputs.

I appreciated the learning opportunity this exercise provided, especially around complex joins, CTE nesting, and handling inconsistent data.

Thank you for reviewing my work!

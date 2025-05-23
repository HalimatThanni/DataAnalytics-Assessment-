-- ========================================
-- Question 2: Transaction Frequency Analysis
-- ========================================

-- CTE to calculate total transactions and active months per customer
WITH transaction_counts AS (
  SELECT 
    owner_id,
    COUNT(*) AS total_transactions,
    (DATEDIFF(MAX(created_on), MIN(created_on)) / 30) + 1 AS total_months
  FROM savings_savingsaccount
  GROUP BY owner_id
),

-- CTE to calculate average transactions per month
averages AS (
  SELECT 
    owner_id,
    total_transactions,
    total_months,
    ROUND(total_transactions / total_months, 2) AS avg_transactions_per_month
  FROM transaction_counts
),

-- CTE to categorize customers based on transaction frequency
categories AS (
  SELECT 
    CASE 
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
  FROM averages
  GROUP BY frequency_category
)

-- Final result showing customer distribution by frequency category
SELECT * FROM categories;

-- ========================================
-- Question 3: Inactivity Report (Over 365 Days)
-- ========================================

-- CTE to gather last transaction dates and inactivity days for both savings and investment accounts
WITH inactivity_report AS (

  -- Savings accounts inactivity
  SELECT 
    plan_id,
    owner_id,
    'Savings' AS type,
    MAX(created_on) AS last_transaction_date,
    DATEDIFF(NOW(), MAX(created_on)) AS inactivity_days
  FROM savings_savingsaccount
  GROUP BY plan_id, owner_id

  UNION ALL

  -- Investment plans inactivity
  SELECT 
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    created_on AS last_transaction_date,
    DATEDIFF(NOW(), created_on) AS inactivity_days
  FROM plans_plan
)

-- Final result filtering customers inactive for over 365 days
SELECT *
FROM inactivity_report
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC
LIMIT 100;

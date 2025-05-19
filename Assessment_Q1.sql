-- Create CTE for savings
WITH Savings AS (
    SELECT 
        owner_id, 
        COUNT(DISTINCT savings_id) AS savings_count,
        SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),

-- Create CTE for investment
Investment AS (
    SELECT 
        owner_id, 
        COUNT(DISTINCT id) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY owner_id
)

-- Final select with joins
SELECT 
    u.id AS owner_id,
    COALESCE(u.name, 'John Doe') AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    COALESCE(s.total_deposits, 0) AS total_deposits
FROM users_customuser u
LEFT JOIN Savings s ON u.id = s.owner_id
LEFT JOIN Investment i ON u.id = i.owner_id
WHERE COALESCE(s.savings_count, 0) >= 1 
  AND COALESCE(i.investment_count, 0) >= 1
ORDER BY total_deposits DESC;

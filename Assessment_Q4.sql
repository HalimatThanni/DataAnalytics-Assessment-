-- ========================================
-- Question 4: Customer Lifetime Value (CLV) Estimation
-- ========================================

-- Calculate CLV based on transaction counts, customer tenure, and a multiplier
SELECT 
  u.id AS customer_id,
  COALESCE(u.name, 'John Doe') AS name,
  TIMESTAMPDIFF(MONTH, u.date_joined, NOW()) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  
  -- Estimate CLV assuming 0.001 average transaction value per year
  ROUND(
    (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, NOW())) * 12 * 0.001, 
    2
  ) AS estimated_clv

FROM users_customuser u
LEFT JOIN savings_savingsaccount s
ON u.id = s.owner_id

GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC
LIMIT 100;
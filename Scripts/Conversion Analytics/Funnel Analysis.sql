CREATE VIEW Funnel_Analysis  AS
SELECT 
    p.category,
    'Viewed' AS stage,
    1 AS stage_order,
    COUNT(*) AS total
FROM events e
JOIN products p
ON e.product_id = p.product_id
WHERE e.event_type = 'view'
GROUP BY p.category

UNION ALL

SELECT 
    p.category,
    'Added to Cart' AS stage,
    2 AS stage_order,
    COUNT(*) AS total
FROM events e
JOIN products p
ON e.product_id = p.product_id
WHERE e.event_type = 'cart'
GROUP BY p.category

UNION ALL

SELECT 
    p.category,
    'Purchased' AS stage,
    3 AS stage_order,
    COUNT(*) AS total
FROM events e
JOIN products p
ON e.product_id = p.product_id
WHERE e.event_type = 'purchase'
GROUP BY p.category;
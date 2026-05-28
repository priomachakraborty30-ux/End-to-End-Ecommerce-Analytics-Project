CREATE VIEW City_wise_Revenue_Analysis  AS

SELECT

    u.city,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT u.user_id) AS total_customers,

    ROUND(

        SUM(
            oi.quantity * oi.item_price
        )::NUMERIC,

        2

    ) AS total_revenue,

    ROUND(

        SUM(
            oi.quantity * oi.item_price
        )::NUMERIC

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS avg_order_value,

    ROUND(

        (
            SUM(
                oi.quantity * oi.item_price
            ) * 100.0
            /
            SUM(
                SUM(
                    oi.quantity * oi.item_price
                )
            ) OVER ()
        )::NUMERIC,

        2

    ) AS revenue_contribution_percentage

FROM users u

JOIN orders o
ON u.user_id = o.user_id

JOIN order_items oi
ON o.order_id = oi.order_id

WHERE o.order_status IN ('completed','shipped')

GROUP BY u.city

ORDER BY revenue_contribution_percentage DESC;--total_revenue
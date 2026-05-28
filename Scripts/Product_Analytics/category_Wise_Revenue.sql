--Checking Which category is making the most revenue
/*
 * OBJECTIVE: Finding out which categories are causing the most revenues
 * each category has similar no of variation of products
 */
CREATE VIEW Category_wise_Revenue_Generation AS

SELECT

    p.category,

    ROUND(
        SUM(
            oi.item_total
        )::NUMERIC,
        2
    ) AS total_revenue,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT p.product_id) AS total_products,
    
    ROUND(

    SUM(
        oi.item_total
    )::NUMERIC

    /

    COUNT(DISTINCT o.order_id),

    2

) AS avg_order_value,

    ROUND(
        AVG(oi.item_price)::NUMERIC,
        2
    ) AS avg_product_price,

    ROUND(
    (
        SUM(oi.item_total)* 100.0
        /
        SUM(
            SUM(
                oi.item_total
            )
        )  OVER ()
        )::numeric,
        2
    ) AS revenue_contribution_percent

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status IN ('completed','shipped')

GROUP BY p.category

ORDER BY total_revenue DESC;
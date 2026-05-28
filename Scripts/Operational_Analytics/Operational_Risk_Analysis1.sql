--OPERATIONAL RISK ANALYSIS CATEGORY WISE
/*OBJECTIVE
 * category-level cancellation/return impact.
 */
CREATE VIEW Category_wise_Operational_Risk_Analysis  AS

SELECT

    p.category,

    o.order_status,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(

        SUM(
            oi.quantity * oi.item_price
        )::NUMERIC,

        2

    ) AS blocked_order_value,

    ROUND(

        AVG(
            oi.quantity * oi.item_price
        )::NUMERIC,

        2

    ) AS avg_order_loss

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status IN ('cancelled','returned')

GROUP BY
    p.category,
    o.order_status

ORDER BY blocked_order_value DESC;
--Same as operational risk analysis2 Jst with the rates:
--Cancelled Orders
CREATE VIEW Product_wise_Operational_Risk_CancelRate_Analysis  AS
WITH total_product_orders AS (

    SELECT

        p.product_id,

        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    JOIN products p
    ON oi.product_id = p.product_id

    GROUP BY p.product_id
)

SELECT

    p.category,

    p.product_id,

    p.product_name,

    COUNT(DISTINCT o.order_id) AS cancelled_orders,

    ROUND(

        SUM(
            oi.quantity * oi.item_price
        )::NUMERIC,

        2

    ) AS cancelled_order_value,

    tpo.total_orders,

    ROUND(

        (
            COUNT(DISTINCT o.order_id) * 100.0
            /
            tpo.total_orders
        )::NUMERIC,

        2

    ) AS cancellation_rate_percentage

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

JOIN total_product_orders tpo
ON p.product_id = tpo.product_id

WHERE o.order_status = 'cancelled'

GROUP BY

    p.category,
    p.product_id,
    p.product_name,
    tpo.total_orders

ORDER BY cancellation_rate_percentage DESC,
         cancelled_orders DESC;



--Returned Products

CREATE VIEW Product_wise_Operational_Risk_ReturnRate_Analysis  AS

WITH total_product_orders AS (

    SELECT

        p.product_id,

        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    JOIN products p
    ON oi.product_id = p.product_id

    GROUP BY p.product_id
)

SELECT

    p.category,

    p.product_id,

    p.product_name,

    COUNT(DISTINCT o.order_id) AS returned_orders,

    ROUND(

        SUM(
            oi.quantity * oi.item_price
        )::NUMERIC,

        2

    ) AS returned_order_value,

    tpo.total_orders,

    ROUND(

        (
            COUNT(DISTINCT o.order_id) * 100.0
            /
            tpo.total_orders
        )::NUMERIC,

        2

    ) AS return_rate_percentage

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

JOIN total_product_orders tpo
ON p.product_id = tpo.product_id

WHERE o.order_status = 'returned'

GROUP BY

    p.category,
    p.product_id,
    p.product_name,
    tpo.total_orders

ORDER BY return_rate_percentage DESC,
         returned_orders DESC;
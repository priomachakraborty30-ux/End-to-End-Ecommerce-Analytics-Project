--PRODUCT WISE REVENUE COMPARISON
/*
 * For each category we r trying to find out which product is working best
 * Which product are the low performing products
 * We have assigned ranking to each of the product as per the revenues they are generating
 */
CREATE VIEW Product_wise_Revenue_Generation AS

WITH product_revenue AS (

    SELECT

        p.category,
        p.product_id,
        p.product_name,

        ROUND(
            SUM(
                oi.quantity * oi.item_price
            )::NUMERIC,
            2
        ) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        ROUND(
            AVG(oi.item_price)::NUMERIC,
            2
        ) AS avg_product_price

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    JOIN products p
    ON oi.product_id = p.product_id

    WHERE o.order_status IN ('completed','shipped')

    GROUP BY
        p.category,
        p.product_id,
        p.product_name
)

SELECT

    category,
    product_id,
    product_name,

    total_revenue,

    total_orders,

    avg_product_price,

    DENSE_RANK() OVER (

        PARTITION BY category

        ORDER BY total_revenue DESC

    ) AS product_rank_in_category

FROM product_revenue

ORDER BY
    category,
    product_rank_in_category;

--RESULT
/*
 * So in the result we can see for each category the top performing product
 * And products whose performance should be evaluated deeply 
 */

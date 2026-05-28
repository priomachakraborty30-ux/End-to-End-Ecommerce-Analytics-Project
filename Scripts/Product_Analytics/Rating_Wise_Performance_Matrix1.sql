--Comparson Return rate with Avg Rating
/*
 * OBJECTIVE:
 * | Pattern                        | Interpretation              |
| ------------------------------ | --------------------------- |
| high return rate + low rating  | product dissatisfaction     |
| high return rate + high rating | operational/logistics issue |
| low return rate + low rating   | niche dissatisfaction       |
| high revenue loss + low rating | critical business problem   |

 */
CREATE VIEW Avg_Rating_vs_ReturnRate_Analysis  AS

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
),

returned_products AS (

    SELECT

        p.product_id,
        p.product_name,
        p.category,

        COUNT(DISTINCT o.order_id) AS returned_orders,

        ROUND(

            SUM(
                oi.quantity * oi.item_price
            )::NUMERIC,

            2

        ) AS returned_order_value

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    JOIN products p
    ON oi.product_id = p.product_id

    WHERE o.order_status = 'returned'

    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)

SELECT

    rp.category,

    rp.product_id,

    rp.product_name,

    tpo.total_orders,

    rp.returned_orders,

    ROUND(

        (
            rp.returned_orders * 100.0
            /
            tpo.total_orders
        )::NUMERIC,

        2

    ) AS return_rate_percentage,

    rp.returned_order_value,

    COUNT(r.review_id) AS total_reviews,

    ROUND(
        AVG(r.rating)::NUMERIC,
        2
    ) AS avg_review_rating

FROM returned_products rp

JOIN total_product_orders tpo
ON rp.product_id = tpo.product_id

LEFT JOIN reviews r
ON rp.product_id = r.product_id

GROUP BY

    rp.category,
    rp.product_id,
    rp.product_name,
    tpo.total_orders,
    rp.returned_orders,
    rp.returned_order_value

ORDER BY
    --return_rate_percentage DESC,
    avg_review_rating ASC;


--RESULT:
/*
* We can check for each category which poduct got the lowest avg rating thn check their return rte to understand issue
*/
--PRODUCTS WITH HIGH RATING BUT LOW VIEW TO PURCHASE CONVERSION
--It depicts that maybe the products are of price not approved by users
CREATE VIEW product_Performance_High_Rating_low_purchase AS
WITH product_metrics AS (

    SELECT 
--        p.product_id,
        p.product_name,
        p.category,
        p.rating,
        p.price,

        COUNT(
            CASE 
                WHEN e.event_type = 'view'
                THEN 1
            END
        ) AS total_views,

        COUNT(
            CASE 
                WHEN e.event_type = 'cart'
                THEN 1
            END
        ) AS total_carts,

        COUNT(
            CASE 
                WHEN e.event_type = 'purchase'
                THEN 1
            END
        ) AS total_purchases

    FROM products p
    LEFT JOIN events e
    ON p.product_id = e.product_id

    GROUP BY 
--        p.product_id,
        p.product_name,
        p.category,
        p.rating,
        p.price
)

SELECT
--    product_id,
    product_name,
    category,
    rating,
    total_views,
    total_carts,
    total_purchases,
    price,

    ROUND(
        total_purchases * 100.0 /
        NULLIF(total_views,0),
        2
    ) AS view_to_purchase_conversion,

    ROUND(
        total_purchases * 100.0 /
        NULLIF(total_carts,0),
        2
    ) AS cart_to_purchase_conversion

FROM product_metrics

WHERE rating >= 4
AND (
    total_purchases * 100.0 /
    NULLIF(total_views,0)
) < 5

ORDER BY view_to_purchase_conversion ASC;
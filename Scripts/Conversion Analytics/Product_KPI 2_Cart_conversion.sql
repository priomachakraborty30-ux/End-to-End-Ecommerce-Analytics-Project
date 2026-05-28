--KPI 2
--CART TO PURCHASE CONVERSION PERCENTAGE
/*Objective:
 * checkout effectiveness
 * If the price is too high for the consumer creating hesistation before checkout
 * Delivery fee, platform fee or handling fee is too high or is extra surge is getting added
 * Payment issues needs to be checked
 */
CREATE VIEW prod_Conversion_Analysis2 AS
WITH category_wise_conversion2 AS (
    select
    	DATE(e.event_timestamp) AS event_date,
        p.category,
        COUNT(
            CASE 
                WHEN e.event_type = 'cart' THEN 1 
            END
        ) AS total_cart_count,

        COUNT(
            CASE 
                WHEN e.event_type = 'purchase' THEN 1 
            END
        ) AS total_purchases

    FROM events e
    JOIN products p
        ON e.product_id = p.product_id

    GROUP by DATE(e.event_timestamp),
    p.category
    
)
select
event_date,
category,
total_cart_count,
total_purchases,
(CASE
    WHEN total_cart_count = 0 THEN 0::numeric
    ELSE ROUND(
       (total_purchases * 100.0 / total_cart_count)::numeric,
        2)
    END )AS conversion_rate_percentage_cart

FROM category_wise_conversion2 c

ORDER BY conversion_rate_percentage_cart DESC;

--RESULTS:
/*As seen in result Sports had the highest conversion rate but lowest cart count 
 * which again proves higher cart value  does not always results in higher purchases
 * for pet supplies and books we need to investigate the reviews as it seems they have high add to cart value with low conversion rate
 */

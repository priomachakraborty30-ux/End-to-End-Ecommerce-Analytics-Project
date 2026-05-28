--KPI 1
--BROAD PRODUCT PERFORMANCE MATRIX
/*Objective:
 *  How much engagement a product is getting and how much Actual conversion is happenning
 *  Does high engagement results in higher purchases
 *  Which products showing lesser conversion rates instead of having high views
*/

WITH category_wise_conversion AS (
    SELECT 
        p.category,
        COUNT(
            CASE 
                WHEN e.event_type = 'view' THEN 1 
            END
        ) AS total_views,

        COUNT(
            CASE 
                WHEN e.event_type = 'purchase' THEN 1 
            END
        ) AS total_purchases

    FROM events e
    JOIN products p
        ON e.product_id = p.product_id

    GROUP BY p.category
)
SELECT
category,
total_views,
total_purchases,
(CASE
    WHEN total_views = 0 THEN 0::numeric
    ELSE ROUND(
       (total_purchases * 100.0 / total_views)::numeric,
        2)
    END )AS conversion_rate_percentage

FROM category_wise_conversion c

ORDER BY conversion_rate_percentage DESC;

--RESULTS:
/*As seen in result clothing had the highest views but lowest conversion rate percentage 
 * which proves higher views does not always results in higher purchases
 * Overall conversion rate from view is also very low highest is only 7.58%
 */

--Product Wise Performance Analysis
--PRODUCTS WHICH IS PERFORMING BAD HAVING 0 PURCHASES
/*
 * Books = 27
 * Clothing = 42
 * Home & Kitchen = 28
 * Beauty = 26
 * Sports = 23
 * Pet Supplies = 28
 * Toys = 31
 * Groceries = 22
 * Automotive = 28
 * Electronics = 20
 */
CREATE VIEW product_Performance_Analysis_0purchase AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,


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
    ) AS total_cart_adds,

    COUNT(
        CASE 
            WHEN e.event_type = 'wishlist'
            THEN 1
        END
    ) AS total_wishlists

FROM events e
JOIN products p
ON e.product_id = p.product_id

GROUP BY 
    p.product_id,
    p.product_name,
    p.category

HAVING COUNT(
    CASE 
        WHEN e.event_type = 'purchase'
        THEN 1
    END
) = 0

ORDER BY total_views DESC;

--RESULTS:
/*Need to check certain clothing products as tot 42 products in clothing category is doin preety bad
*/

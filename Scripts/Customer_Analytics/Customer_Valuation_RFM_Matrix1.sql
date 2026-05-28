--Customer Valuation
--OBJECTIVE: TO UNDERSTAND USERS ENGAGEMENT BASED ON RFM MATRIX
/*
 * Recency: Compare to current date whats the recent purchase of that customer to understand the regularity of customer
 * Frequency: To understand how much frequently the customer is buying from the platform
 * Monetary: The revenue value addition by each customer
 */
CREATE VIEW Customer_Valuation_RFM_Matrix1 AS
WITH customer_metrics AS (

    SELECT 
        u.user_id,
        u.name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.item_total) AS monetary

    FROM users u

    JOIN orders o
    ON u.user_id = o.user_id

    JOIN order_items oi
    ON o.order_id = oi.order_id

    WHERE o.order_status in ('completed','shipped')

    GROUP BY 
        u.user_id,
        u.name
)

SELECT
    user_id,
    name,

    CURRENT_DATE - DATE(last_order_date) AS recency,

    frequency,

    ROUND(monetary::numeric,2) AS monetary

FROM customer_metrics;

--RESULT:
/*
 * We have successfully get a proper data for each customer showing value for each matrix
 * RFM analysis considered completed and shipped orders to capture realized and near-realized customer value
 * while excluding cancelled/returned transactions.
*/
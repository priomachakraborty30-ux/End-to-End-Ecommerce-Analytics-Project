--CUSTOMER VALUATION
/*
 * OBJECTIVE: To understand customer value based on recency, frequency and monetary value
 * We have calculated RFM score for each customer
 * We have calculated Weighted RFM Score for each customer
 * We have decided a particular customer segment for each customer
 */
CREATE VIEW Customer_Valuation_RFM_Matrix2_Upd AS

WITH customer_metrics AS (

    SELECT 
        u.user_id,
        u.name,
        p.category,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.quantity * oi.item_price) AS monetary

    FROM users u

    JOIN orders o
    ON u.user_id = o.user_id

    JOIN order_items oi
    ON o.order_id = oi.order_id
    
    JOIN products p
    ON oi.product_id = p.product_id 

    WHERE o.order_status in ('completed','shipped')

    GROUP BY 
        u.user_id,
        u.name,
        p.category
),

rfm_base AS (

    SELECT
        user_id,
        name,
        category,

        CURRENT_DATE - DATE(last_order_date) AS recency,

        frequency,

        ROUND(monetary::NUMERIC,2) AS monetary

    FROM customer_metrics
),

rfm_scores AS (

	SELECT
	    user_id,
	    name,
		category,
	    recency,
	    frequency,
	    monetary,
	
	    case
		    WHEN recency <= 200 THEN 5
		    WHEN recency <= 370 THEN 4
		    WHEN recency <= 540 THEN 3
		    WHEN recency <= 710 THEN 2
		    ELSE 1
	
	END AS r_score,
	
	    case
		    WHEN frequency >= 5 THEN 5
		    WHEN frequency >= 4 THEN 4
		    WHEN frequency >= 3 THEN 3
		    WHEN frequency >= 2 THEN 2
		    ELSE 1
	
	END  AS f_score,
	
	   case
		    WHEN monetary >= 2000 THEN 5 --656
		    WHEN monetary >= 1000 THEN 4 --991
		    WHEN monetary >= 500 THEN 3  --1123
		    WHEN monetary >= 200 THEN 2  --1289
		    ELSE 1-- 1518
	
	END AS m_score
	
	FROM rfm_base
	),

weighted_rfms as (

	SELECT
	    *,
	
	    CONCAT(r_score, f_score, m_score) AS rfm_score,
	    
	    (r_score * 0.4 + f_score * 0.3 + m_score * 0.3)
	    AS weighted_rfm
	    	
	FROM rfm_scores
),
customer_segmentation as(
	select *,	
		case
		    WHEN weighted_rfm >=4 
		    THEN 'Platinum'
	
			WHEN weighted_rfm >=3
			THEN 'Gold'
			
			WHEN weighted_rfm >=2
			THEN 'Silver'
			
			else  'Bronze'
		end as cust_segment
		from weighted_rfms
		)
		
		
SELECT
*

FROM customer_segmentation

ORDER BY weighted_rfm DESC;

--RESULT
/*
 * Now we have a consolidated data which providing a clear picture on revenue generation by each customer
 * we can understand platinum, Gold, silver and bronze user segments decided by the weighted rfm score
 */


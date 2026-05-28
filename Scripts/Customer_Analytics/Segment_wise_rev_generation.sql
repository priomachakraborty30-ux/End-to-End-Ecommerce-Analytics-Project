--CUSTOMER VALUATION
/*
 * OBJECTIVE: To find out segment wise total rev, 
 * avg customer value, and 
 * revenue contribution percentage
 */
CREATE VIEW Customer_Segment_wise_Revenue_Generation AS

WITH customer_metrics AS (

    SELECT 
        u.user_id,
        u.name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.quantity * oi.item_price) AS monetary

    FROM users u

    JOIN orders o
    ON u.user_id = o.user_id

    JOIN order_items oi
    ON o.order_id = oi.order_id

    WHERE o.order_status in ('completed','shipped')

    GROUP BY 
        u.user_id,
        u.name
),

rfm_base AS (

    SELECT
        user_id,
        name,

        CURRENT_DATE - DATE(last_order_date) AS recency,

        frequency,

        ROUND(monetary::NUMERIC,2) AS monetary

    FROM customer_metrics
),

rfm_scores AS (

	SELECT
	    user_id,
	    name,
	
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
		from weighted_rfms)
		
		
SELECT

    cust_segment,

    COUNT(*) AS total_customers,

    ROUND(
        SUM(monetary)::NUMERIC,
        2
    ) AS total_revenue,

    ROUND(
        AVG(monetary)::NUMERIC,
        2
    ) AS avg_customer_value,

    ROUND(
        SUM(monetary) * 100.0
        /
        SUM(SUM(monetary)) OVER (),
        2
    ) AS revenue_contribution_percentage

FROM customer_segmentation

GROUP BY cust_segment

ORDER BY total_revenue DESC;

--RESULT:
/*
 * WE find out Gold is revenue-driving segment.
 * Silver shows the large moderate customer base
*/
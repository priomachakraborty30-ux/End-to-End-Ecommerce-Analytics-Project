--OPERATIONAL INEFFICIENCY PRODUCT WISE
/*
 * OBJECTIVE: 
 * To understand the poor operational performance product wise
 * So first we have checked for the 'Return Orders': 
 * Return orders indicate 1)product dissatisfaction 2)quality mismatch 3)expectation mismatch 4)sizing issue
 * Second Query is for 'Cancelled Order'
 * Cancelled Oredrs indicate: 1) delivery delay 2)payment failure 3)stock issue 4)buyer indecision
 */

CREATE VIEW Product_wise_Operational_Risk_Return_Analysis  AS

--Returned Orders
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

    ) AS returned_order_value

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'returned'

GROUP BY

    p.category,
    p.product_id,
    p.product_name

ORDER BY returned_orders DESC,--Operational inefficiency: Most Frequently Returned Products
         returned_order_value DESC; -- Financial pain point: Which product is causing the huge financial loss due to return

         
--RESULT:
         /*
         * As per requirement we can check which product from which category causing the most no of return, causing complex operational workload
         * When we want to know which product is causing the highest financial loss in revenue then we r gonna check the result by order value desc
         * In the result if we r checking by the no of return then Zenith School Zenith Treatment has the highest no of return
         * Where According to order value that is lost due to return it is Willow Hospital with lost value of 21452.1
         * Then Astra pull with no of return only 4 times but loss value of huge 21043.17 rs         
         **/
         
         
--Cancelled Orders:
CREATE VIEW Product_wise_Operational_Risk_Cancel_Analysis  AS
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

    ) AS cancelled_order_value
    

FROM orders o

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'cancelled'

GROUP BY

    p.category,
    p.product_id,
    p.product_name

ORDER BY cancelled_orders DESC,
         cancelled_order_value DESC;
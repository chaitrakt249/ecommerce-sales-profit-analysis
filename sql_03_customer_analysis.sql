-- Customer value
SELECT customer_id, customer_name,
       COUNT(DISTINCT order_id) AS orders,
       SUM(sales) AS sales,
       SUM(profit) AS profit,
       SUM(sales)/COUNT(DISTINCT order_id) AS aov
FROM superstore_sales
GROUP BY customer_id, customer_name
ORDER BY sales DESC;

-- Repeat customers
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
    FROM superstore_sales
    GROUP BY customer_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS customers,
    AVG(order_count) AS avg_orders
FROM customer_orders
GROUP BY 1;

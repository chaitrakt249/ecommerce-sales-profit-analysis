-- Load the cleaned CSV into a table named superstore_sales before running this script.

SELECT COUNT(*) AS row_count FROM superstore_sales;
SELECT COUNT(DISTINCT order_id) AS orders, COUNT(DISTINCT customer_id) AS customers FROM superstore_sales;
SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT order_id, product_id, order_date, sales, quantity, profit
    FROM superstore_sales
    GROUP BY order_id, product_id, order_date, sales, quantity, profit
    HAVING COUNT(*) > 1
) d;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM superstore_sales;

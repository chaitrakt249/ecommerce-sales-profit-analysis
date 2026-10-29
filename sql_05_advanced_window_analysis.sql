-- Rank products within each category
WITH product_profit AS (
    SELECT category, product_name, SUM(profit) AS profit
    FROM superstore_sales
    GROUP BY category, product_name
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY profit DESC) AS category_profit_rank
FROM product_profit;

-- Month-over-month sales growth
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS sales
    FROM superstore_sales
    GROUP BY 1
)
SELECT month, sales,
       LAG(sales) OVER (ORDER BY month) AS previous_month_sales,
       (sales - LAG(sales) OVER (ORDER BY month)) /
       NULLIF(LAG(sales) OVER (ORDER BY month),0) * 100 AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Running yearly sales
SELECT order_date,
       SUM(sales) OVER (PARTITION BY EXTRACT(YEAR FROM order_date)
                        ORDER BY order_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_sales
FROM superstore_sales;

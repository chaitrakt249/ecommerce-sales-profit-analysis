-- Core business KPIs
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS profit_margin_pct,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM superstore_sales;

-- Monthly trend
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales) AS sales,
    SUM(profit) AS profit,
    SUM(profit) / NULLIF(SUM(sales),0) * 100 AS margin_pct
FROM superstore_sales
GROUP BY 1,2
ORDER BY 1,2;

-- Category profitability
SELECT category, SUM(sales) AS sales, SUM(profit) AS profit,
       SUM(profit)/NULLIF(SUM(sales),0)*100 AS margin_pct
FROM superstore_sales
GROUP BY category
ORDER BY profit DESC;

-- Loss-making sub-categories
SELECT sub_category, SUM(sales) AS sales, SUM(profit) AS profit
FROM superstore_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit;

-- =========================================================
-- E-COMMERCE SALES & PROFIT ANALYSIS
-- SQL ANALYSIS PROJECT
-- =========================================================
--
-- Dataset: Sample Superstore
-- Table required: superstore_sales
--
-- This file contains data quality checks,
-- business KPIs, customer analysis, product analysis,
-- discount analysis and advanced SQL analysis.
-- =========================================================


-- =========================================================
-- 1. DATA QUALITY CHECKS
-- =========================================================

-- Total rows, orders and customers
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM superstore_sales;


-- Check for duplicate records
SELECT
    COUNT(*) AS duplicate_rows
FROM (
    SELECT
        order_id,
        product_id,
        order_date,
        sales,
        quantity,
        profit
    FROM superstore_sales
    GROUP BY
        order_id,
        product_id,
        order_date,
        sales,
        quantity,
        profit
    HAVING COUNT(*) > 1
) duplicates;


-- Check for missing important values
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM superstore_sales;


-- Check for invalid sales
SELECT
    COUNT(*) AS negative_sales_rows
FROM superstore_sales
WHERE sales < 0;


-- Check for invalid quantities
SELECT
    COUNT(*) AS invalid_quantity_rows
FROM superstore_sales
WHERE quantity <= 0;


-- Check for invalid discounts
SELECT
    COUNT(*) AS invalid_discount_rows
FROM superstore_sales
WHERE discount < 0
   OR discount > 1;


-- =========================================================
-- 2. CORE BUSINESS KPIs
-- =========================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM superstore_sales;


-- =========================================================
-- 3. MONTHLY SALES & PROFIT PERFORMANCE
-- =========================================================

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS margin_pct
FROM superstore_sales
GROUP BY 1, 2
ORDER BY 1, 2;


-- =========================================================
-- 4. CATEGORY PERFORMANCE
-- =========================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS margin_pct
FROM superstore_sales
GROUP BY category
ORDER BY profit DESC;


-- =========================================================
-- 5. LOSS-MAKING SUB-CATEGORIES
-- =========================================================

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit
FROM superstore_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit;


-- =========================================================
-- 6. CUSTOMER VALUE ANALYSIS
-- =========================================================

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM superstore_sales
GROUP BY customer_id, customer_name
ORDER BY sales DESC;


-- =========================================================
-- 7. ONE-TIME VS REPEAT CUSTOMERS
-- =========================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM superstore_sales
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(AVG(order_count), 2) AS avg_orders
FROM customer_orders
GROUP BY 1;


-- =========================================================
-- 8. TOP PRODUCTS BY PROFIT
-- =========================================================

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    SUM(quantity) AS units,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(AVG(discount), 3) AS avg_discount,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS margin_pct
FROM superstore_sales
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
ORDER BY profit DESC
LIMIT 20;


-- =========================================================
-- 9. DISCOUNT VS PROFITABILITY
-- =========================================================

SELECT
    CASE
        WHEN discount = 0 THEN 'No discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE '31%+'
    END AS discount_band,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS margin_pct
FROM superstore_sales
GROUP BY 1
ORDER BY 1;


-- =========================================================
-- 10. LOSS-MAKING PRODUCTS
-- =========================================================

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit
FROM superstore_sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY sales DESC;


-- =========================================================
-- 11. PRODUCT RANKING WITHIN CATEGORY
-- =========================================================

WITH product_profit AS (
    SELECT
        category,
        product_name,
        SUM(profit) AS profit
    FROM superstore_sales
    GROUP BY category, product_name
)
SELECT
    category,
    product_name,
    ROUND(profit, 2) AS profit,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY profit DESC
    ) AS category_profit_rank
FROM product_profit
ORDER BY category, category_profit_rank;


-- =========================================================
-- 12. MONTH-OVER-MONTH SALES GROWTH
-- =========================================================

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS sales
    FROM superstore_sales
    GROUP BY 1
),
with_previous AS (
    SELECT
        month,
        sales,
        LAG(sales) OVER (
            ORDER BY month
        ) AS previous_month_sales
    FROM monthly
)
SELECT
    month,
    ROUND(sales, 2) AS sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        (sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS mom_growth_pct
FROM with_previous
ORDER BY month;


-- =========================================================
-- 13. YEAR-TO-DATE SALES
-- =========================================================

WITH daily_sales AS (
    SELECT
        order_date,
        SUM(sales) AS daily_sales
    FROM superstore_sales
    GROUP BY order_date
)
SELECT
    order_date,
    ROUND(daily_sales, 2) AS daily_sales,
    ROUND(
        SUM(daily_sales) OVER (
            PARTITION BY EXTRACT(YEAR FROM order_date)
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS ytd_sales
FROM daily_sales
ORDER BY order_date;


-- =========================================================
-- END OF SQL ANALYSIS
-- =========================================================

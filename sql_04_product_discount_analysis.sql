-- Top products by profit
SELECT product_id, product_name, category, sub_category,
       SUM(quantity) AS units,
       SUM(sales) AS sales,
       SUM(profit) AS profit,
       AVG(discount) AS avg_discount,
       SUM(profit)/NULLIF(SUM(sales),0)*100 AS margin_pct
FROM superstore_sales
GROUP BY product_id, product_name, category, sub_category
ORDER BY profit DESC
FETCH FIRST 20 ROWS ONLY;

-- Discount vs profitability
SELECT
    CASE
        WHEN discount = 0 THEN 'No discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE '31%+'
    END AS discount_band,
    SUM(sales) AS sales,
    SUM(profit) AS profit,
    SUM(profit)/NULLIF(SUM(sales),0)*100 AS margin_pct
FROM superstore_sales
GROUP BY 1
ORDER BY 1;

-- Products with high sales but negative profit
SELECT product_name, SUM(sales) AS sales, SUM(profit) AS profit
FROM superstore_sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY sales DESC;

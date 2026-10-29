# Power BI Dashboard Build Guide

## Data model

Use the cleaned fact table `superstore_cleaned.csv`.

Recommended model:

- FactSales: transaction rows
- DimDate: calendar table
- DimProduct: Product ID, Product Name, Category, Sub-Category
- DimCustomer: Customer ID, Customer Name, Segment
- DimLocation: City, State, Region

## Core DAX measures

```DAX
Total Sales = SUM(FactSales[sales])

Total Profit = SUM(FactSales[profit])

Profit Margin % = DIVIDE([Total Profit], [Total Sales])

Orders = DISTINCTCOUNT(FactSales[order_id])

Customers = DISTINCTCOUNT(FactSales[customer_id])

Units Sold = SUM(FactSales[quantity])

Average Order Value = DIVIDE([Total Sales], [Orders])

Average Discount = AVERAGE(FactSales[discount])

Loss Making Sales = CALCULATE([Total Sales], FactSales[profit] < 0)
```

## Page 1 — Executive Overview

KPI cards: Total Sales, Total Profit, Profit Margin %, Orders, Customers, AOV.

Visuals:
- Monthly Sales & Profit line chart
- Sales by Category
- Profit by Category
- Sales by Region
- Top 10 Products by Profit

Slicers: Year, Region, Category, Segment.

## Page 2 — Profitability

Visuals:
- Profit margin by category/sub-category
- Discount band vs margin
- Loss-making products table
- Sales vs Profit scatter plot by product

Decision: identify revenue that does not translate into healthy profit.

## Page 3 — Customer Analysis

Visuals:
- Top customers by sales
- Top customers by profit
- Orders per customer distribution
- Segment comparison

Decision: prioritize high-value and repeat customers.

## Page 4 — Regional & Product Analysis

Visuals:
- Region/state sales map or bar chart
- Category × region matrix
- Top/bottom products
- Quantity vs profit

Decision: identify markets and products requiring investment or correction.

## Design rules

Keep each page focused on one business question. Use consistent number formatting, meaningful titles, tooltips, drill-through where useful, and avoid decorative charts that do not support a decision.

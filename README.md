# E-Commerce Sales & Profit Analysis

## Project Overview

This project analyzes an e-commerce sales dataset to understand sales performance, profitability, customer behavior, product performance, and the impact of discounts.

The project follows a complete data analysis workflow:

**Data Cleaning → Exploratory Analysis → SQL Analysis → Business Insights → Power BI Dashboard**

The goal is to identify trends, profitable and loss-making areas, customer patterns, and business opportunities using real-world analytical techniques.

---

## Dataset

**Dataset:** Sample Superstore Dataset

**Records:** 9,994  
**Original Columns:** 21

The dataset contains information about:

- Orders and shipping
- Customers
- Customer segments
- Products
- Categories and sub-categories
- Sales
- Quantity
- Discounts
- Profit
- Geographic information

---

## Tools & Technologies

- **Python**
- **Pandas**
- **NumPy**
- **Matplotlib**
- **Seaborn**
- **SQL**
- **DuckDB** for SQL testing
- **Power BI**
- **Jupyter Notebook**
- **GitHub**

---

## Project Workflow

### 1. Data Cleaning & Profiling — Python

The raw Superstore dataset was cleaned and prepared using Pandas.

Tasks performed:

- Standardized column names
- Converted date columns
- Converted numeric columns
- Checked duplicate records
- Checked missing values
- Created shipping duration
- Created profit margin
- Created order year, month, and quarter
- Identified loss-making transactions
- Calculated core business KPIs

The cleaned dataset is generated as:

`superstore_cleaned.csv`

Run:

`python_01_clean_and_profile.py`

---

### 2. Business Analysis — Python

The cleaned dataset is analyzed using Pandas.

Analysis includes:

- Monthly sales and profit performance
- Category performance
- Customer analysis
- Customer average order value
- Product profitability
- Loss-making products
- Top profitable products
- Discount analysis
- Profit margin by discount band

Charts generated:

- Monthly Sales Trend
- Profit by Category
- Profit Margin by Discount Band

Run:

`python_02_business_analysis.py`

---

### 3. SQL Analysis

The project includes a consolidated SQL analysis file containing 13 analytical queries.

SQL analysis includes:

- Data quality checks
- Core business KPIs
- Monthly sales and profit
- Category performance
- Loss-making sub-categories
- Customer value analysis
- One-time vs repeat customers
- Top products by profit
- Discount vs profitability
- Loss-making products
- Product ranking within category
- Month-over-month sales growth
- Year-to-date sales

Advanced SQL techniques used:

- `GROUP BY`
- `HAVING`
- `CASE`
- CTEs
- `LAG()`
- `DENSE_RANK()`
- Window functions
- Date functions
- Aggregations

SQL file:

`ecommerce_sales_profit_analysis.sql`

---

## Power BI Dashboard

The Power BI dashboard provides an interactive view of the business performance.

The dashboard focuses on:

- Total Sales
- Total Profit
- Profit Margin
- Sales trends
- Profit by category
- Regional performance
- Product performance
- Customer and segment analysis

The Power BI dashboard is available in the:

`power-bi/`

folder.

---

## Key Business Insights

- Total sales are approximately **$2.30M** with approximately **$286K** in profit.
- Overall profit margin is approximately **12.47%**.
- Technology is one of the strongest contributors to overall sales and profitability.
- Some products and sub-categories generate losses despite contributing sales.
- Higher discounts can negatively affect profitability.
- Customer performance varies significantly, making customer-level profitability analysis important.
- Sales growth should be evaluated alongside profit and margin rather than sales alone.
- Monthly performance shows clear variation across the year.

---

## Business Recommendations

- Review products and sub-categories generating consistent losses.
- Evaluate discount strategies for products with low or negative margins.
- Prioritize profitable categories and products.
- Monitor customer profitability in addition to customer sales.
- Use monthly sales trends to improve inventory and marketing planning.
- Track both sales and profit when evaluating business performance.

---

## Project Structure

```text
ecommerce-sales-profit-analysis/
│
├── power-bi/
│   └── Power BI dashboard files
│
├── ecommerce_sales_profit_analysis.ipynb
│
├── Sample - Superstore.csv
│
├── python_01_clean_and_profile.py
│
├── python_02_business_analysis.py
│
├── ecommerce_sales_profit_analysis.sql
│
├── business_recommendations.md
│
├── data_dictionary.md
│
├── interview_cheat_sheet.md
│
├── powerbi_dashboard_build_guide.md
│
└── README.md

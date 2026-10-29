from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Project folder = where this Python file is located
ROOT = Path(__file__).resolve().parent

# Cleaned dataset created by Python 01
DATA = ROOT / "superstore_cleaned.csv"

# Folder for analysis results
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)


# -----------------------------
# LOAD DATA
# -----------------------------

if not DATA.exists():
    raise FileNotFoundError(
        f"Could not find {DATA.name}. "
        "Run python_01_clean_and_profile.py first."
    )

df = pd.read_csv(DATA, parse_dates=["order_date", "ship_date"])


# -----------------------------
# MONTHLY PERFORMANCE
# -----------------------------

monthly = (
    df.groupby("order_month", as_index=False)
    .agg(
        sales=("sales", "sum"),
        profit=("profit", "sum"),
        orders=("order_id", "nunique")
    )
)

monthly["margin_pct"] = (
    monthly["profit"] / monthly["sales"] * 100
)

monthly.to_csv(
    OUT / "monthly_performance.csv",
    index=False
)


# -----------------------------
# CATEGORY PERFORMANCE
# -----------------------------

category = (
    df.groupby("category", as_index=False)
    .agg(
        sales=("sales", "sum"),
        profit=("profit", "sum"),
        units=("quantity", "sum"),
        orders=("order_id", "nunique")
    )
)

category["margin_pct"] = (
    category["profit"] / category["sales"] * 100
)

category.sort_values(
    "profit",
    ascending=False
).to_csv(
    OUT / "category_performance.csv",
    index=False
)


# -----------------------------
# CUSTOMER ANALYSIS
# -----------------------------

customer = (
    df.groupby(
        ["customer_id", "customer_name"],
        as_index=False
    )
    .agg(
        sales=("sales", "sum"),
        profit=("profit", "sum"),
        orders=("order_id", "nunique"),
        units=("quantity", "sum")
    )
)

customer["aov"] = (
    customer["sales"] / customer["orders"]
)

customer["margin_pct"] = (
    customer["profit"] / customer["sales"] * 100
)

customer.sort_values(
    "sales",
    ascending=False
).head(100).to_csv(
    OUT / "top_customers.csv",
    index=False
)


# -----------------------------
# PRODUCT PROFITABILITY
# -----------------------------

product = (
    df.groupby(
        [
            "product_id",
            "product_name",
            "category",
            "sub_category"
        ],
        as_index=False
    )
    .agg(
        sales=("sales", "sum"),
        profit=("profit", "sum"),
        units=("quantity", "sum"),
        avg_discount=("discount", "mean")
    )
)

product["margin_pct"] = (
    product["profit"] / product["sales"] * 100
)

product.sort_values(
    "profit"
).head(25).to_csv(
    OUT / "loss_making_products.csv",
    index=False
)

product.sort_values(
    "profit",
    ascending=False
).head(25).to_csv(
    OUT / "top_profitable_products.csv",
    index=False
)


# -----------------------------
# DISCOUNT ANALYSIS
# -----------------------------

bins = [-0.01, 0, 0.10, 0.20, 0.30, 1]

labels = [
    "No discount",
    "1-10%",
    "11-20%",
    "21-30%",
    "31%+"
]

df["discount_band"] = pd.cut(
    df["discount"],
    bins=bins,
    labels=labels
)

discount = (
    df.groupby(
        "discount_band",
        observed=False,
        as_index=False
    )
    .agg(
        sales=("sales", "sum"),
        profit=("profit", "sum"),
        rows=("row_id", "count")
    )
)

discount["margin_pct"] = (
    discount["profit"] / discount["sales"] * 100
)

discount.to_csv(
    OUT / "discount_analysis.csv",
    index=False
)


# -----------------------------
# CHART 1 — MONTHLY SALES
# -----------------------------

plt.figure(figsize=(11, 5))

sns.lineplot(
    data=monthly,
    x="order_month",
    y="sales"
)

plt.xticks(rotation=60)
plt.title("Monthly Sales Trend")
plt.tight_layout()

plt.savefig(
    OUT / "monthly_sales_trend.png",
    dpi=180
)

plt.close()


# -----------------------------
# CHART 2 — PROFIT BY CATEGORY
# -----------------------------

plt.figure(figsize=(9, 5))

sns.barplot(
    data=category.sort_values(
        "profit",
        ascending=False
    ),
    x="category",
    y="profit"
)

plt.xticks(rotation=20)
plt.title("Profit by Category")
plt.tight_layout()

plt.savefig(
    OUT / "profit_by_category.png",
    dpi=180
)

plt.close()


# -----------------------------
# CHART 3 — DISCOUNT VS MARGIN
# -----------------------------

plt.figure(figsize=(9, 5))

sns.barplot(
    data=discount,
    x="discount_band",
    y="margin_pct"
)

plt.xticks(rotation=20)
plt.title("Profit Margin by Discount Band")
plt.tight_layout()

plt.savefig(
    OUT / "margin_by_discount.png",
    dpi=180
)

plt.close()


# -----------------------------
# COMPLETION MESSAGE
# -----------------------------

print("=" * 50)
print("BUSINESS ANALYSIS COMPLETED")
print("=" * 50)

print("\nRows analyzed:", len(df))

print("\nOutput folder:")
print(OUT)

print("\nFiles created:")

for file in sorted(OUT.iterdir()):
    print("-", file.name)

print("\nAnalysis completed successfully!")

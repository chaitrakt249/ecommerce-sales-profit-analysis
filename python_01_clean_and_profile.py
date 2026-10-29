from pathlib import Path
import pandas as pd
import numpy as np

# Project folder = same folder where this Python file is saved
ROOT = Path.cwd()

# Dataset is in the same GitHub folder
DATA = ROOT / "Sample - Superstore.csv"

# Cleaned dataset will be created here
OUT = ROOT / "superstore_cleaned.csv"


def clean_data(path):
    # Read the Superstore dataset
    df = pd.read_csv(path, encoding="latin1")

    # Clean column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("-", "_")
    )

    # Convert dates
    for col in ["order_date", "ship_date"]:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")

    # Convert numeric columns
    for col in ["sales", "quantity", "discount", "profit"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    # Create useful analysis columns
    df["ship_days"] = (
        df["ship_date"] - df["order_date"]
    ).dt.days

    df["profit_margin"] = np.where(
        df["sales"] != 0,
        df["profit"] / df["sales"],
        np.nan
    )

    df["order_year"] = df["order_date"].dt.year
    df["order_month"] = df["order_date"].dt.to_period("M").astype(str)
    df["order_quarter"] = df["order_date"].dt.to_period("Q").astype(str)

    # Identify loss-making transactions
    df["is_loss"] = (df["profit"] < 0).astype(int)

    return df


def main():

    # Check whether dataset exists
    if not DATA.exists():
        raise FileNotFoundError(
            f"Dataset not found: {DATA}\n"
            "Make sure Sample - Superstore.csv is in the same folder "
            "as this Python file."
        )

    # Clean the data
    df = clean_data(DATA)

    # Save cleaned dataset
    df.to_csv(OUT, index=False)

    # -----------------------------
    # DATA QUALITY RESULTS
    # -----------------------------

    print("=" * 50)
    print("E-COMMERCE SALES & PROFIT ANALYSIS")
    print("DATA CLEANING & PROFILING")
    print("=" * 50)

    print("\nDATASET SIZE")
    print("Rows:", len(df))
    print("Columns:", len(df.columns))

    print("\nDATA QUALITY")
    print("Duplicate rows:", df.duplicated().sum())

    print("\nMissing Values:")
    missing = df.isna().sum()
    print(missing[missing > 0])

    # -----------------------------
    # BUSINESS KPIs
    # -----------------------------

    total_sales = df["sales"].sum()
    total_profit = df["profit"].sum()
    total_quantity = df["quantity"].sum()
    total_orders = df["order_id"].nunique()
    total_customers = df["customer_id"].nunique()

    profit_margin = (
        total_profit / total_sales * 100
        if total_sales != 0 else 0
    )

    print("\nCORE BUSINESS KPIs")
    print("-" * 30)
    print("Total Sales:", round(total_sales, 2))
    print("Total Profit:", round(total_profit, 2))
    print("Profit Margin:", round(profit_margin, 2), "%")
    print("Units Sold:", int(total_quantity))
    print("Total Orders:", total_orders)
    print("Total Customers:", total_customers)

    # -----------------------------
    # OUTPUT FILE
    # -----------------------------

    print("\nOUTPUT")
    print("-" * 30)
    print("Cleaned dataset saved as:")
    print(OUT)

    print("\nScript completed successfully!")

    
if __name__ == "__main__":
    main()

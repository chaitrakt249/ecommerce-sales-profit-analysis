from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'data' / 'Sample - Superstore.csv'
OUT = ROOT / 'data' / 'superstore_cleaned.csv'


def clean_data(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, encoding='latin1')
    df.columns = (df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('-', '_'))
    for col in ['order_date', 'ship_date']:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors='coerce')
    for col in ['sales', 'quantity', 'discount', 'profit']:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce')
    df['ship_days'] = (df['ship_date'] - df['order_date']).dt.days
    df['profit_margin'] = np.where(df['sales'].ne(0), df['profit'] / df['sales'], np.nan)
    df['order_year'] = df['order_date'].dt.year
    df['order_month'] = df['order_date'].dt.to_period('M').astype(str)
    df['order_quarter'] = df['order_date'].dt.to_period('Q').astype(str)
    df['is_loss'] = (df['profit'] < 0).astype(int)
    return df


def main():
    if not DATA.exists():
        raise FileNotFoundError(f'Missing dataset: {DATA}')
    df = clean_data(DATA)
    OUT.parent.mkdir(exist_ok=True)
    df.to_csv(OUT, index=False)
    print('Rows:', len(df))
    print('Columns:', len(df.columns))
    print('Duplicate rows:', df.duplicated().sum())
    print('Missing values:')
    print(df.isna().sum().sort_values(ascending=False).head(15))
    print('\nCore KPIs')
    print('Sales:', round(df.sales.sum(), 2))
    print('Profit:', round(df.profit.sum(), 2))
    print('Margin:', round(df.profit.sum()/df.sales.sum()*100, 2), '%')
    print('Units:', int(df.quantity.sum()))
    print('Orders:', df.order_id.nunique())
    print('Customers:', df.customer_id.nunique())

if __name__ == '__main__':
    main()

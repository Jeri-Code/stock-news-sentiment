import os, time, requests
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine

API = os.getenv("ALPHAVANTAGE_API_KEY")
TICKERS = [t.strip().upper() for t in os.getenv("TICKERS","AAPL").split(",") if t.strip()]
FUNC = os.getenv("AV_FUNCTION", "TIME_SERIES_DAILY")
SIZE = os.getenv("AV_OUTPUTSIZE", "compact")  # compact|full
SLEEP = int(os.getenv("AV_SLEEP_SECONDS", "15"))
DSN = os.getenv("WAREHOUSE_DSN", "postgresql+psycopg2://app:app_pw@db:5432/warehouse")

if not API:
    raise SystemExit("Missing ALPHAVANTAGE_API_KEY")

def fetch_daily(symbol: str, retries: int = 4) -> pd.DataFrame:
    url = f"https://www.alphavantage.co/query?function={FUNC}&symbol={symbol}&outputsize={SIZE}&apikey={API}"
    for attempt in range(1, retries + 1):
        r = requests.get(url, timeout=30)
        try:
            j = r.json()
        except Exception:
            j = {}
        if "Time Series (Daily)" in j:
            ts = j["Time Series (Daily)"]
            rows = [{
                "ticker": symbol,
                "date": d,
                "open": float(v["1. open"]),
                "high": float(v["2. high"]),
                "low":  float(v["3. low"]),
                "close":float(v["4. close"]),
                "adj_close": float(v["4. close"]),
                "volume": int(v["5. volume"]),
                "ingested_at": datetime.utcnow()
            } for d, v in ts.items()]
            return pd.DataFrame(rows)
        else:
            msg = j.get("Note") or j.get("Information") or j.get("Error Message") or str(j)[:200]
            print(f"[WARN] {symbol} attempt {attempt}/{retries}: {msg}")
            time.sleep(SLEEP if ("Note" in j or "Information" in j) else min(SLEEP, 5))
    return pd.DataFrame(columns=["ticker","date","open","high","low","close","adj_close","volume","ingested_at"])

def main():
    engine = create_engine(DSN)
    all_rows = []
    for i, tkr in enumerate(TICKERS, start=1):
        df = fetch_daily(tkr)
        if not df.empty:
            all_rows.append(df)
        if i < len(TICKERS):
            time.sleep(SLEEP)

    if not all_rows:
        raise SystemExit("No data returned from Alpha Vantage.")

    out = pd.concat(all_rows, ignore_index=True)

    with engine.begin() as conn:
        conn.exec_driver_sql("CREATE SCHEMA IF NOT EXISTS raw;")
        conn.exec_driver_sql("""
            CREATE TABLE IF NOT EXISTS raw.raw_price (
              ticker TEXT,
              date DATE,
              open NUMERIC, high NUMERIC, low NUMERIC, close NUMERIC,
              adj_close NUMERIC, volume BIGINT,
              ingested_at TIMESTAMPTZ
            );
        """)

    out.to_sql("raw_price", engine, schema="raw", if_exists="append", index=False)
    print(f"[OK] appended {len(out)} rows -> raw.raw_price")

if __name__ == "__main__":
    main()

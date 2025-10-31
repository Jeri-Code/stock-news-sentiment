WITH src AS (
  SELECT * FROM raw_price
),
ranked AS (
  SELECT
    UPPER(ticker) AS ticker,
    date::date AS d,
    open, high, low, close, adj_close, volume,
    ingested_at,
    ROW_NUMBER() OVER (
      PARTITION BY UPPER(ticker), date::date
      ORDER BY ingested_at DESC
    ) AS rn
  FROM src
)
SELECT
  ticker,
  d,
  TO_CHAR(d,'YYYYMMDD')::INT AS date_key,
  open, high, low, close, adj_close, volume,
  ingested_at
FROM ranked
WHERE rn = 1

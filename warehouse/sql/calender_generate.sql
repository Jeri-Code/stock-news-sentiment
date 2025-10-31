INSERT INTO dim_calendar (date_key, d, is_trading_day, year, month, day, dow)
SELECT
  CAST(to_char(d, 'YYYYMMDD') AS INT) AS date_key,
  d,
  TRUE,
  EXTRACT(YEAR FROM d)::INT,
  EXTRACT(MONTH FROM d)::INT,
  EXTRACT(DAY FROM d)::INT,
  EXTRACT(DOW FROM d)::INT
FROM generate_series('2010-01-01'::date, CURRENT_DATE + 365, interval '1 day') AS g(d)
ON CONFLICT (date_key) DO NOTHING;

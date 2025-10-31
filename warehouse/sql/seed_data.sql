-- ===== DIM_TICKER =====
INSERT INTO dim_ticker (ticker, name, sector, exchange, is_active) VALUES
    ('AAPL', 'Apple Inc', 'Technology', 'NASDAQ', TRUE),
    ('MSFT', 'Microsoft Corp', 'Technology', 'NASDAQ', TRUE),
    ('AMZN', 'Amazon.com Inc', 'Consumer Discretionary', 'NASDAQ', TRUE);

-- ===== DIM_SOURCE =====
INSERT INTO dim_source (provider, name) VALUES
    ('polygon', 'Polygon.io'),
    ('reddit', 'Reddit API'),
    ('alphavantage', 'Alpha Vantage');

-- ===== DIM_CALENDAR (TEST RANGE) =====
INSERT INTO dim_calendar (date_key, d, is_trading_day, year, month, day, dow) VALUES
    (20251020, '2025-10-20', TRUE, 2025, 10, 20, 1),
    (20251021, '2025-10-21', TRUE, 2025, 10, 21, 2),
    (20251022, '2025-10-22', TRUE, 2025, 10, 22, 3),
    (20251023, '2025-10-23', TRUE, 2025, 10, 23, 4),
    (20251024, '2025-10-24', TRUE, 2025, 10, 24, 5);
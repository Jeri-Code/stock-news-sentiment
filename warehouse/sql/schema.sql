-- ===== DIMENSIONS =====
CREATE TABLE IF NOT EXISTS dim_ticker (
    symbol_id SERIAL PRIMARY KEY,
    ticker TEXT UNIQUE NOT NULL,
    name TEXT,
    sector TEXT,
    exchange TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dim_calendar (
    date_key INT PRIMARY KEY,
    d DATE NOT NULL,
    is_trading_day BOOLEAN,
    year INT,
    month INT,
    day INT,
    dow INT
);

CREATE TABLE IF NOT EXISTS dim_source (
    source_id SERIAL PRIMARY KEY,
    provider TEXT NOT NULL,
    name TEXT
);

-- ===== FACTS =====
CREATE TABLE IF NOT EXISTS fact_price (
    symbol_id INT REFERENCES dim_ticker(symbol_id),
    date_key INT REFERENCES dim_calendar(date_key),
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC,
    adj_close NUMERIC,
    volume BIGINT,
    PRIMARY KEY (symbol_id, date_key)
);

CREATE TABLE IF NOT EXISTS fact_news (
    news_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symbol_id INT REFERENCES dim_ticker(symbol_id),
    date_key INT REFERENCES dim_calendar(date_key),
    published_ts TIMESTAMPTZ,
    headline TEXT,
    summary TEXT,
    url TEXT,
    provider TEXT,
    source TEXT,
    provider_sentiment NUMERIC,
    model_sentiment NUMERIC,
    model_label TEXT,
    article_id TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS fact_social_message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symbol_id INT REFERENCES dim_ticker(symbol_id),
    date_key INT REFERENCES dim_calendar(date_key),
    created_ts TIMESTAMPTZ,
    platform TEXT,
    source TEXT,
    text TEXT,
    upvotes INT,
    model_sentiment NUMERIC,
    model_label TEXT
);
CREATE TABLE IF NOT EXISTS fact_price (
    ts TIMESTAMP NOT NULL,
    ticker TEXT NOT NULL,
    close NUMERIC,
    PRIMARY KEY (ts, ticker)
);

CREATE TABLE IF NOT EXISTS fact_news (
    published_at TIMESTAMP NOT NULL,
    ticker TEXT NOT NULL,
    source TEXT,
    headline TEXT,
    sentiment_label TEXT,
    sentiment_score NUMERIC,
    PRIMARY KEY (published_at, ticker, headline)
);

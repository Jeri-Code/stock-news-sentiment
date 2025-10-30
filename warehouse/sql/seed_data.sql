-- Initial test data
INSERT INTO fact_price (ts, ticker, close)
VALUES (NOW(), 'AAPL', 190.00)
ON CONFLICT (ts, ticker) DO NOTHING;

INSERT INTO fact_news (published_at, ticker, source, headline, sentiment_label, sentiment_score)
VALUES (NOW(), 'AAPL', 'Placeholder', 'Sample headline', 'neutral', 0.0)
ON CONFLICT (published_at, ticker, headline) DO NOTHING;

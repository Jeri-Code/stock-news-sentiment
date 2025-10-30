# Stocks + News + Sentiment — Data Platform

An open-source, production-style data platform that ingests **market prices**, **news**, and optional **social posts**, scores **sentiment** (FinBERT/VADER), models data with **dbt**, schedules with **Airflow**, and serves analytics via **Superset**

## Features
- Automated pipelines (daily prices; hourly news/social deltas)
- NLP sentiment scoring (FinBERT for headlines, VADER for social)
- dbt models: `fact_price`, `fact_news`, `mart_sentiment_trend`, `mart_event_study`
- Dashboards: sentiment vs price, event study, source mix
- Slack alerts on spikes & data-quality failures

## Stack
**Ingestion:** Python extractors \
**Warehouse:** Postgres (prod) / DuckDB (CI)\
**Transforms:** dbt \
**Orchestration:** Airflow \
**NLP:** FinBERT, VADER\
**BI:** Apache Superset\
**CI:** GitHub Actions 

## Architechture

```mermaid
flowchart TD
    A1[Price APIs] --> B[Python Extractors]
    A2[News APIs] --> B
    A3[Reddit API] --> B
    B --> C["RAW Storage (Parquet / JSON)"]
    C --> D["dbt STAGING"]
    D --> E["dbt CORE (facts / dims)"]
    E --> F["dbt MARTS (analytics)"]
    F --> G["Superset Dashboards"]
    F --> H["Slack Alerts"]
```

## Repo Layout (initial)
```text
├── README.md
├── airflow/          (next)
├── ingestion/        (next)
├── sentiment/        (next)
├── warehouse/        (dbt; next)
└── dashboards/       (later)
```


## Roadmap
- Docker compose (Postgres, Airflow, dbt, Streamlit)
- Price + News extractors (placeholders → real APIs)
- FinBERT/VADER scoring service
- dbt models + tests + freshness
- Dashboards (3 MVP charts)
- Optional FastAPI signals endpoint

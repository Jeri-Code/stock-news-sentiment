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
[ Price APIs ]     [ News APIs ]     [ Reddit ]
       │                 │               │
       ├────► Python Extractors ◄────────┤
                     │
                     ▼
              RAW Storage (Parquet / JSON)
                     │
                     ▼
                dbt STAGING
                     │
                     ▼
             dbt CORE (facts / dims)
                     │
                     ▼
             dbt MARTS (analytics)
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
   Superset Dashboards     Slack Alerts


## Repo Layout (initial)
├── README.md                 → project overview
├── airflow/                  → Airflow DAGs (next commit)
├── ingestion/                → Python extractors (next commit)
├── sentiment/                → NLP models (next commit)
├── warehouse/                → dbt project (next commit)
│   └── models/
├── dashboards/               → Superset exports (later)
└── docs/                     → architecture, data dictionary, runbook


## Roadmap
- Docker compose (Postgres, Airflow, dbt, Streamlit)
- Price + News extractors (placeholders → real APIs)
- FinBERT/VADER scoring service
- dbt models + tests + freshness
- Dashboards (3 MVP charts)
- Optional FastAPI signals endpoint

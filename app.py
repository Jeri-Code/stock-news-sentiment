import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import os

st.set_page_config(page_title="Stocks + News + Sentiment", layout="wide")
st.title("Stocks + News + Sentiment")
st.caption("Home • overview and quick links")

dsn = os.getenv("WAREHOUSE_DSN")
st.write("Connecting to:", dsn)

engine = create_engine(dsn)

try:
    with engine.connect() as conn:
        df = pd.read_sql("SELECT * FROM fact_price ORDER BY ts DESC LIMIT 5;", conn)
    st.dataframe(df)
except Exception as e:
    st.error(f"Error: {e}")

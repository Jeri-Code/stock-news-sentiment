import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import os


st.set_page_config(page_title="Price Explorer", layout="wide")
st.title("Price Explorer")

dsn = os.getenv("WAREHOUSE_DSN")

engine = create_engine(dsn)

try:
    with engine.connect() as conn:
        df = pd.read_sql("SELECT * FROM dim_ticker LIMIT 5;", conn)
    st.dataframe(df)
except Exception as e:
    st.error(f"Error: {e}")

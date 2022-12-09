from sqlalchemy import create_engine, MetaData
import pandas as pd
import sqlalchemy as sql


engine = create_engine("mysql+pymysql://root:Daniela123#@localhost:3306/platforms")

conn = engine.connect()
 
cur = conn.begin()

meta = MetaData()




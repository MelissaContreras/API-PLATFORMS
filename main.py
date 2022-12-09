from fastapi import FastAPI

import pandas as pd
from router.router import user


app= FastAPI(title= "API Plataforms")


app.include_router(user)



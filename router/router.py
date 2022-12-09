from fastapi import APIRouter
from config.db import conn 
# from config.db import engine
import sqlalchemy
import pandas as pd
import mysql.connector as myconn
from mysql.connector import Error
import os
from config.db import meta 
os.system("cls")



user= APIRouter()


@user.post("/Bienvenid@ a mi API Platforms")
async def Saludo():
    return "Un gusto tenerte aquí"

@user.post("/api/Consulta1/{anio}/{plataforma}/{min}")
async def get_max_duration(anio, plataforma, min):
        
    query = f'select maxduration(%s, %s, %s)'  
   
    df = pd.read_sql(query,conn,params=[anio, plataforma, min],index_col=None)
    
    
    titulo = ''
    for column_name, item in df.iteritems():
        titulo = item[0]
    
    return {f"Título: {titulo}"}


@user.post("/api/Consulta2/{plataforma}") 
async def get_count_plataform(plataforma):

    co = myconn.connect(host="localhost",
                            database="platforms",
                            user="root",
                            password="Daniela123#")
    
    try:

        if co.is_connected():                                    
            cursor = co.cursor()

            params=[plataforma, '', 0, 0]

            data = cursor.callproc('cantidad', params)
     
            co.commit()

            return {f'Plataforma: {data[1]},Cantidad de Peliculas{data[2]},cantidadd de TV Shows{data[3]}'}

    except Error as ex:
        return "Error durante la conección:", ex
    finally:
        if co.is_connected():
           co.close()

@user.post("/api/Consulta3/{genero}") 
async def get_listedin(genero):        

    co = myconn.connect(host="localhost",
                            database="platforms",
                            user="root",
                            password="Daniela123#")
    
    try:

        if co.is_connected():                                    
            cursor = co.cursor()

            params=[genero, '', 0]

            data = cursor.callproc('genero', params)
     
            co.commit()

            return {f'Plataforma: {data[1]}, Cantidad: {data[2]}'}

    except Error as ex:
        return "Error durante la conección:", ex
    finally:
        if co.is_connected():
           co.close()



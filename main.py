from typing import Union
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector

app = FastAPI()

def connectMySQL():
    return mysql.connector.connect(
        host="localhost",
        port="3305",
        user="root",
        password="",
        database="Automaat"
    )

def query(q):
    conn = connectMySQL()
    cursor = conn.cursor()
    cursor.execute(q)
    result = cursor.fetchall()
    conn.close()
    return result


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/getRentals")
def read_item():
    Cars = query("SELECT * FROM rental")
    return {"Rentals": Cars}

@app.get("/getCars")
def read_item():
    Cars = query("SELECT * FROM car")
    return {"Cars": Cars}

@app.get("/getdashboard")
def read_item():
    Cars = query("SELECT count(*) FROM car;")
    Rentals = query("SELECT count(*) FROM rental;")
    Costumers = query("SELECT count(*) FROM costumer;")
    return {"Dashboard": {"Cars": Cars, "Rentals": Rentals, "Costumers": Costumers}}
    
    
@app.get("/getCar/{id}")
def read_item(id: int):
    Car = query("SELECT * FROM car WHERE id = " + str(id) + " LIMIT 1;")
    return {"Car": Car}

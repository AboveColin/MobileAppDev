from http.client import HTTPException
from typing import Union
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector
from mysql.connector import Error
from jose import JWTError, jwt
from passlib.context import CryptContext
from datetime import datetime, timedelta
from pydantic import BaseModel, EmailStr
from fastapi import Depends, HTTPException, Header, Body, BackgroundTasks
import secrets


class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str

class RegisterRequest(BaseModel):
    email: str
    password: str
    last_name: str
    first_name: str
    birth_date: str
    profile_picture: str

class LoginRequest(BaseModel):
    email: str
    password: str

class UpdateProfileRequest(BaseModel):
    email: str
    first_name: str
    last_name: str
    birth_date: str
    profile_picture: str

class ChangePasswordRequest(BaseModel):
    current_password: str
    new_password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class Rental(BaseModel):
    latitude: float
    longitude: float
    fromDate: str
    toDate: str
    customerNr: int
    carId: int

class Rental(BaseModel):
    latitude: float
    longitude: float
    fromDate: str
    toDate: str
    customerNr: int
    carId: int


app = FastAPI()

# Secret key to encode JWT tokens - keep it secret
SECRET_KEY = "Se53lighQTBr6ovZTMEQixlxvjWyd7ii"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 180

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    print(plain_password, hashed_password)
    answer =pwd_context.verify(plain_password, hashed_password)
    print(answer)
    return answer

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

    
def get_token(authorization: str = Header(None)):
    if authorization:
        # Extract the token part from the Authorization header
        token = authorization.split(" ")[1]
        return token
    else:
        raise HTTPException(status_code=401, detail="Authorization header missing")

def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        print(payload)
        return payload
    except JWTError:
        return None


def query_db(query, params=None):
    try:
        conn = connectMySQL()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params)
        if query.strip().upper().startswith("SELECT"):
            result = cursor.fetchall()
        else:
            conn.commit()
            result = cursor.rowcount
        cursor.close()
        conn.close()
        return result
    except Error as e:
        print(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")

def check_token(token: str):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception

    return True

def connectMySQL():
    return mysql.connector.connect(
        host="localhost",
        port="3306",
        user="",
        password="",
        database="automaat"
    )

def send_reset_email(email: str, token: str):
    print(f"Sending password reset email to {email} with token: {token}")
    # Here, integrate with an email sending service

def generate_password_reset_token():
    return secrets.token_urlsafe(16)  # generates a 16-byte (128-bit) secure token

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/getRentals")
def read_item(token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    print(datetime.now());
    Cars = query_db("SELECT * FROM rental")
    return {"Rentals": Cars}

@app.get("/getCars")
def read_item(token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    print(datetime.now());
    Cars = query_db("SELECT * FROM car")
    print({"Cars": Cars})
    return {"Cars": Cars}

@app.get("/getdashboard")
def read_item(token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    print(datetime.now());
    Cars = query_db("SELECT count(*) AS cars FROM car;")
    Rentals = query_db("SELECT count(*) AS rentals FROM rental;")
    Costumers = query_db("SELECT count(*) AS costumers FROM costumer;")
    print({"Dashboard": {"Cars": Cars, "Rentals": Rentals, "Costumers": Costumers}})
    return {"Dashboard": {"Cars": Cars, "Rentals": Rentals, "Costumers": Costumers}}
    
@app.get("/getCustomer")
def read_item(token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    Customer = query_db("SELECT * FROM costumer WHERE email = %s", (username,))
    return {"Customer": Customer}


@app.post("/updateProfile")
def update_profile(request: UpdateProfileRequest = Body(...), token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    update_query = """
    UPDATE costumer 
    SET email = %s, firstName = %s, lastName = %s, birthDate = %s, profilePicture = %s
    WHERE email = %s
    """
    params = (request.email, request.first_name, request.last_name, request.birth_date, request.profile_picture, username)
    result = query_db(update_query, params)
    if result == 1:
        return {"message": "Profile updated successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to update profile")



    
@app.get("/getCar/{id}")
def read_item(id: int, token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception

    print(datetime.now());
    Car = query_db("SELECT * FROM car WHERE id = %s", (id,))
    return {"Car": Car}
    
    


@app.post("/register")
def register_user(request: RegisterRequest):
    hashed_password = get_password_hash(request.password)

    sql_query = """
    INSERT INTO costumer (email, password, lastName, firstName, birthDate, profilePicture)
    VALUES (%s, %s, %s, %s, %s, %s);
    """
    params = (
        request.email, hashed_password, request.last_name, 
        request.first_name, request.birth_date, request.profile_picture
    )
    
    query_db(sql_query, params)
    return {"message": "User registered"}

@app.get("/getCostumers")
def read_item():
    print(datetime.now());
    Costumers = query_db("SELECT * FROM costumer")
    return {"Costumers": Costumers}

@app.post("/login")
def login_for_access_token(request: LoginRequest):
    email = request.email
    password = request.password
    user = query_db("SELECT * FROM costumer WHERE email = %s", (email,))
    print(user)
    if not user or not verify_password(password, user[0]['password']):
        raise HTTPException(status_code=400, detail="Incorrect email or password")


    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": email}, expires_delta=access_token_expires
    )
    print({"access_token": access_token, "token_type": "bearer"})
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/protected-route")
def read_protected_route(token: str = Depends(get_token)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
    
    return {"message": "You are logged in!"}

@app.post("/changePassword")
def change_password(request: ChangePasswordRequest, token: str = Depends(get_token)):
    try:
        # Decode the token to get user info
        user_data = decode_token(token)
        if user_data is None:
            raise HTTPException(status_code=401, detail="Invalid token")

        email = user_data["sub"]

        # Fetch the current password hash from the database
        current_password_hash = query_db("SELECT password FROM costumer WHERE email = %s", (email,))
        
        print(request.current_password, current_password_hash[0]['password'])
        # Verify current password
        
        if not verify_password(request.current_password, current_password_hash[0]['password']):
            raise HTTPException(status_code=403, detail="Incorrect password")

        # Hash the new password
        new_password_hash = get_password_hash(request.new_password)

        # Update the password in the database
        query_db("UPDATE costumer SET password = %s WHERE email = %s", (new_password_hash, email))

        return {"message": "Password successfully changed"}

    except Error as e:
        print(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")


@app.post("/forgot-password")
def forgot_password(request: ForgotPasswordRequest, background_tasks: BackgroundTasks):
    user = query_db("SELECT * FROM costumer WHERE email = %s", (request.email,))
    if not user:
        raise HTTPException(status_code=404, detail="Email not found")

    reset_token = generate_password_reset_token()

    # Store the token in the database with an expiration time
    expiration_time = datetime.utcnow() + timedelta(hours=1)  # token expires in 1 hour
    print(expiration_time)
    query_db("UPDATE costumer SET reset_token = %s, token_expiration = %s WHERE email = %s", 
             (reset_token, expiration_time, request.email))

    background_tasks.add_task(send_reset_email, request.email, reset_token)

    return {"message": "If your email is registered, you will receive a password reset link", "token": reset_token}

@app.post("/reset-password")
def reset_password(request: ResetPasswordRequest = Body(...)):
    token = request.token
    new_password = request.new_password
    # Validate the token and get the user
    user = query_db("SELECT * FROM costumer WHERE reset_token = %s AND token_expiration > %s", 
                    (token, datetime.utcnow()))

    if not user:
        raise HTTPException(status_code=400, detail="Invalid or expired token")

    # Hash the new password
    new_password_hash = get_password_hash(new_password)

    # Update the password in the database and clear the reset token
    query_db("UPDATE costumer SET password = %s, reset_token = NULL, token_expiration = NULL WHERE email = %s", 
             (new_password_hash, user[0]['email']))

    return {"message": "Password has been reset successfully"}


@app.get("/getRentalsFor/{id}")
def get_rentals_for_car(id: int, token: str = Depends(get_token)):
    credentials_exception = HTTPException(
            status_code=401,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception

    query = """
    SELECT fromDate, toDate 
    FROM rental 
    JOIN car ON rental.carId = car.id 
    WHERE car.id = %s;
    """
    params = (id,)
    rentals = query_db(query, params)
    return {"Rentals": rentals}

@app.get("/getAvailableCarsOnDateRange/{dateFrom}/{dateTo}")
def get_availability_for_date_range(dateFrom: str, dateTo: str, token: str = Depends(get_token)):
    credentials_exception = HTTPException(
            status_code=401,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception

    query = """
    SELECT c.ID, c.brand
    FROM car c
    JOIN rental r
    ON r.carId = c.id 
    AND ((r.toDate < %s AND r.toDate < %s) 
    OR 
    (r.fromDate > %s AND r.fromDate > %s));
    """
    params = (dateFrom, dateTo, dateFrom, dateTo)
    cars = query_db(query, params)
    return {"Cars": cars}

@app.get("/getAvailabilityFor/{id}/{dateFrom}/{dateTo}")
def get_availability_for_car(id: int, dateFrom: str, dateTo: str, token: str = Depends(get_token)):
    credentials_exception = HTTPException(
            status_code=401,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception

    query = """
    SELECT fromDate, toDate 
    FROM rental 
    JOIN car ON rental.carId = car.id 
    WHERE car.id = %s 
    AND ((toDate < %s AND toDate < %s) OR (fromDate > %s AND fromDate > %s));
    """
    params = (id, dateFrom, dateTo, dateFrom, dateTo)
    rentals = query_db(query, params)
    return {"Rentals": rentals}



@app.post("/rentCar")
def create_rental(rental: Rental, token: str = Depends(get_token)):
    credentials_exception = HTTPException(
            status_code=401,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    payload = decode_token(token)
    if payload is None:
        raise credentials_exception
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception


    insert_query = """
    INSERT INTO rental (longitude, latitude, fromDate, toDate, customerNr, carID) 
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    params = (rental.longitude, rental.latitude, rental.fromDate, rental.toDate, rental.customerNr, rental.carId)
    result = query_db(insert_query, params)
    if result:
        return {"message": "Rental created successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to create rental")

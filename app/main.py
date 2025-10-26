from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas, database

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="VirtualBank API")

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Example: Get all users
@app.get("/users/", response_model=list[schemas.UserOut])
def read_users(db: Session = Depends(get_db)):
    return db.query(models.User).all()

# Example: Create new user
@app.post("/users/", response_model=schemas.UserOut)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = models.User(
        full_name=user.full_name,
        email=user.email,
        phone=user.phone,
        address=user.address,
        national_id=user.national_id
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

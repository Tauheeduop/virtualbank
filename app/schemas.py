from pydantic import BaseModel

class UserCreate(BaseModel):
    full_name: str
    email: str
    phone: str
    address: str
    national_id: str

class UserOut(UserCreate):
    user_id: int
    kyc_status: str
    status: str

    class Config:
        orm_mode = True

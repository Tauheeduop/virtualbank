from sqlalchemy import Column, Integer, String, DECIMAL, Boolean, ForeignKey, DateTime
from sqlalchemy.sql import func
from .database import Base

class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    phone = Column(String(20), unique=True)
    address = Column(String(255))
    national_id = Column(String(20), unique=True)
    kyc_status = Column(String(20), default="pending")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String(20), default="active")

class Account(Base):
    __tablename__ = "accounts"

    account_id = Column(Integer, primary_key=True, index=True)
    account_number = Column(String(20), unique=True, nullable=False)
    account_title = Column(String(100), nullable=False)
    iban = Column(String(34), unique=True, nullable=False)
    account_type = Column(String(20), default="savings")
    balance = Column(DECIMAL(15,2), default=0.0)
    currency = Column(String(10), default="PKR")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String(20), default="active")

from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserRole(str, Enum):
    USER = "user"
    EMPLOYER = "employer"
    ADMIN = "admin"

class ApplicationStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"

class UserBase(BaseModel):
    username: str
    email: EmailStr
    phone: Optional[str] = None
    role: UserRole = UserRole.USER
    skills: Optional[str] = ""

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    phone: Optional[str] = None
    skills: Optional[str] = None

class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True

class JobBase(BaseModel):
    title: str
    description: str
    location: str
    salary: Optional[str] = None
    skill_required: str

class JobCreate(JobBase):
    pass

class JobResponse(JobBase):
    id: int
    is_active: bool
    created_at: datetime
    employer_id: int
    employer: UserResponse

    class Config:
        from_attributes = True

class JobApplicationBase(BaseModel):
    job_id: int

class JobApplicationCreate(JobApplicationBase):
    pass

class JobApplicationUpdate(BaseModel):
    status: ApplicationStatus

class JobApplicationResponse(BaseModel):
    id: int
    status: ApplicationStatus
    applied_at: datetime
    user_id: int
    job_id: int
    user: UserResponse
    job: JobResponse

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    role: str
    name: str

class TokenData(BaseModel):
    username: Optional[str] = None

class JobRecommendation(BaseModel):
    score: int
    matching_skills: List[str]
    job: JobResponse

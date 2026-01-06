from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional
from datetime import datetime

# User models
class UserRegister(BaseModel):
    name: str = Field(..., min_length=2, max_length=100)
    email: EmailStr
    password: str = Field(..., min_length=6)
    dob: Optional[str] = None
    
    @validator('password')
    def password_strength(cls, v):
        if len(v) < 6:
            raise ValueError('Password must be at least 6 characters')
        return v

class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Addiction models
class AddictionCreate(BaseModel):
    type: str = Field(..., min_length=1, max_length=100)
    start_date: str
    counter_start_at: str
    goal_type: str = Field(default='quit')
    daily_target: Optional[int] = None
    note: Optional[str] = None
    motivation: Optional[str] = None
    time_saved_per_day: int = Field(default=0)
    money_saved_per_day: Optional[float] = None

class AddictionUpdate(BaseModel):
    type: Optional[str] = None
    status: Optional[str] = None
    note: Optional[str] = None
    motivation: Optional[str] = None
    time_saved_per_day: Optional[int] = None
    money_saved_per_day: Optional[float] = None

# Survey models
class SurveyCreate(BaseModel):
    addiction_id: int
    date: str
    slipped: int = Field(default=0, ge=0, le=1)
    slip_amount: int = Field(default=0, ge=0)
    mood: Optional[str] = None
    urge_level: Optional[int] = Field(default=None, ge=0, le=10)
    note: Optional[str] = None
    
    @validator('mood')
    def validate_mood(cls, v):
        if v and v not in ['bad', 'neutral', 'good', 'great']:
            raise ValueError('Invalid mood value')
        return v

# Milestone models
class MilestoneCreate(BaseModel):
    addiction_id: int
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = None
    target_value: int = Field(..., gt=0)
    type: str = Field(default='milestone')
    reward_points: int = Field(default=0, ge=0)
    deadline: Optional[str] = None

class MilestoneClaim(BaseModel):
    milestone_id: int

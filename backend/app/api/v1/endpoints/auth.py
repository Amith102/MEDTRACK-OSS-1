from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from app.core import security
from app.core.config import settings
from app.schemas.user import User, UserCreate, Token
from app.services import user_service
from app.db.session import get_database

router = APIRouter()

@router.post("/register", response_model=User)
async def register(user_in: UserCreate, db = Depends(get_database)):
    user = await user_service.get_user_by_email(db, user_in.email)
    if user:
        raise HTTPException(
            status_code=400,
            detail="The user with this username already exists in the system.",
        )
    return await user_service.create_user(db, user_in)

@router.post("/login", response_model=Token)
async def login(db = Depends(get_database), form_data: OAuth2PasswordRequestForm = Depends()):
    user = await user_service.get_user_by_email(db, form_data.username)
    if not user or not security.verify_password(form_data.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    elif not user.get("is_active", True):
        raise HTTPException(status_code=400, detail="Inactive user")
        
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    return {
        "access_token": security.create_access_token(
            user["email"], expires_delta=access_token_expires
        ),
        "token_type": "bearer",
    }

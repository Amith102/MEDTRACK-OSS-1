from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from pydantic import ValidationError
from app.core import security
from app.core.config import settings
from app.db.session import get_database
from app.schemas.user import TokenData
from app.services import user_service

reusable_oauth2 = OAuth2PasswordBearer(
    tokenUrl=f"{settings.API_V1_STR}/auth/login"
)

async def get_current_user(
    db = Depends(get_database), token: str = Depends(reusable_oauth2)
) -> dict:
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[security.ALGORITHM]
        )
        token_data = TokenData(**payload)
    except (jwt.JWTError, ValidationError):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Could not validate credentials",
        )
    user = await user_service.get_user_by_email(db, token_data.sub if hasattr(token_data, 'sub') else payload.get("sub"))
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

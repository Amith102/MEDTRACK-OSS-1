from fastapi import APIRouter, Depends
from app.api import deps
from app.schemas.user import User

router = APIRouter()

@router.get("/me", response_model=User)
async def read_user_me(
    current_user: dict = Depends(deps.get_current_user)
):
    return current_user

@router.get("/", response_model=list[User])
async def read_users(
    db = Depends(deps.get_database),
    current_user: dict = Depends(deps.get_current_user)
):
    # This is a placeholder for actual user listing logic
    return [current_user]

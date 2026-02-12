from typing import Optional
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.user import UserInDB # I should probably define this properly or use a dict
from app.schemas.user import UserCreate
from app.core.security import get_password_hash

async def get_user_by_email(db: AsyncIOMotorDatabase, email: str) -> Optional[dict]:
    return await db["users"].find_one({"email": email})

async def create_user(db: AsyncIOMotorDatabase, user_in: UserCreate) -> dict:
    user_data = user_in.dict()
    user_data["hashed_password"] = get_password_hash(user_data.pop("password"))
    user_data["is_active"] = True
    
    result = await db["users"].insert_one(user_data)
    user_data["id"] = str(result.inserted_id)
    return user_data

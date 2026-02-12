from pydantic import BaseModel
from typing import Optional, List

class MedicationBase(BaseModel):
    name: str
    dosage: str
    frequency: str
    frequency_weekly: Optional[List[bool]] = [True, True, True, True, True, True, True]
    purpose: Optional[str] = None
    icon: Optional[str] = None
    color: Optional[int] = None # store rgb color as integer
    next_due: Optional[str] = None
    is_active: Optional[bool] = True
    instructions: Optional[str] = None

class MedicationCreate(MedicationBase):
    pass

class MedicationUpdate(MedicationBase):
    name: Optional[str] = None
    dosage: Optional[str] = None
    frequency: Optional[str] = None

class Medication(MedicationBase):
    id: str
    owner_id: str

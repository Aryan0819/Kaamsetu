from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()  # <-- Define app BEFORE using it

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8000",
        "http://127.0.0.1:8000",
        "http://localhost:63342",   # Use your Flutter web port
        "http://localhost:5000",
        "http://127.0.0.1:5000"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ... rest of your imports and route definitions

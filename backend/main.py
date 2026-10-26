
import os
import secrets
from pathlib import Path

from dotenv import load_dotenv
from fastapi import Depends, FastAPI, Header, HTTPException

from backend.friend_lookup import find_friend
from mangum import Mangum

# Load the .env file from the project root
PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")

def load_api_key():
    # Local development: read from .env
    local_key = os.getenv("MIA_API_KEY")
    if local_key:
        return local_key

    # AWS Lambda: retrieve from Secrets Manager
    secret_id = os.getenv("MIA_API_SECRET_ID")
    if secret_id:
        import boto3

        response = boto3.client(
            "secretsmanager"
        ).get_secret_value(SecretId=secret_id)

        return response["SecretString"]

    raise RuntimeError("Mia API key is not configured")


API_KEY = load_api_key()

app = FastAPI(title="Mia Memory API")


def verify_api_key(x_api_key: str | None = Header(default=None)):
    if not x_api_key or not secrets.compare_digest(x_api_key, API_KEY):
        raise HTTPException(status_code=401, detail="Unauthorized")


@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "Mia Memory API"
    }


@app.get("/friend", dependencies=[Depends(verify_api_key)])
def get_friend(name: str):
    matches = find_friend(name)

    if len(matches) == 0:
        return {
            "status": "unknown",
            "message": "Friend not found"
        }

    if len(matches) > 1:
        return {
            "status": "ambiguous",
            "message": (
                "Which Mike? Guinness-beer-loving Mike Wyse "
                "or cottage-loving Mike Cerilli?"
            ),
            "options": [friend["name"] for friend in matches]
        }

    return {
        "status": "found",
        "friend": matches[0]
    }

# AWS Lambda entry point
handler = Mangum(app, lifespan="off")
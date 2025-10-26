import os
import requests
from dotenv import load_dotenv

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_API_URL = os.getenv("GEMINI_API_URL")

def call_gemini(prompt: str):
    headers = {"Authorization": f"Bearer {GEMINI_API_KEY}"}
    data = {"prompt": prompt}
    response = requests.post(f"{GEMINI_API_URL}/generate", json=data, headers=headers)
    return response.json()

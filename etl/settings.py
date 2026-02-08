import os
import yaml
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()

CONFIG_PATH = Path(__file__).parent.parent / "config.yml"

with open(CONFIG_PATH) as f:
    yaml_config = yaml.safe_load(f)


class Settings:
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", "5432")
    DB_NAME = os.getenv("DB_NAME")
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")

    DATA = [
        {
            'name': item['name'],
            'url': item['url'],
            'path': Path(item['path'])
        }
        for item in yaml_config['data']
    ]

    PIPELINE = yaml_config['pipeline']['steps']

settings = Settings()

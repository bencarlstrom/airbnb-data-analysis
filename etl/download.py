import gzip
import requests
from pathlib import Path
from settings import settings


def download_data():
    for item in settings.DATA:
        path = item['path']
        path.parent.mkdir(parents=True, exist_ok=True)

        r = requests.get(item['url'])
        r.raise_for_status()

        decompressed = gzip.decompress(r.content)
        path.write_bytes(decompressed)

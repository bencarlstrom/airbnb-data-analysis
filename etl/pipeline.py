import os
import subprocess
from settings import settings


def run_command(script):
    # each subprocess needs copy of environment
    env = os.environ.copy()
    if settings.DB_PASSWORD:
        env['PGPASSWORD'] = settings.DB_PASSWORD

    cmd = [
        "psql",
        "-h", settings.DB_HOST,
        "-U", settings.DB_USER,
        "-d", settings.DB_NAME,
        "-f", script
    ]

    subprocess.run(cmd, env=env, check=True)


def run_pipeline():
    for step in settings.PIPELINE:
        print(f"-------{step}-------")
        for script in step['scripts']:
            print(f"{script}")
            run_command(script)

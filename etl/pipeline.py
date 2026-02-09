import os
import subprocess
from settings import settings


def create_database():
    env = os.environ.copy()
    if settings.DB_PASSWORD:
        env['PGPASSWORD'] = settings.DB_PASSWORD

    cmd = [
        "psql",
        "-h", settings.DB_HOST,
        "-U", settings.DB_USER,
        "-d", "postgres",
        "-c", f"CREATE DATABASE {settings.DB_NAME};",
        "-q"
    ]

    result = subprocess.run(cmd, env=env, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"Created database '{settings.DB_NAME}'")
    elif "already exists" in result.stderr:
        print(f"Database '{settings.DB_NAME}' already exists")
    else:
        print(f"Error: {result.stderr}")
        raise subprocess.CalledProcessError(result.returncode, cmd)


def run_command(script):
    env = os.environ.copy()
    if settings.DB_PASSWORD:
        env['PGPASSWORD'] = settings.DB_PASSWORD

    env['PGOPTIONS'] = '-c client_min_messages=warning -c log_error_verbosity=terse'

    cmd = [
        "psql",
        "-h", settings.DB_HOST,
        "-U", settings.DB_USER,
        "-d", settings.DB_NAME,
        "-f", script,
        "-q"
    ]

    try:
       subprocess.run(cmd, env=env, check=True)
    except subprocess.CalledProcessError as e:
        print(f"\nError executing {script}")
        print(f"{e.returncode}")
        raise


def run_pipeline():
    print(f"{'─'*50} DATABASE {'─'*50}")
    create_database()

    for step in settings.PIPELINE:
        print(f"{'─'*50} {step['name'].upper()} {'─'*50}")
        for script in step['scripts']:
            print(f"{script}")
            run_command(script)
        print()

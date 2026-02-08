from download import download_data
from pipeline import run_pipeline


def main():
    download_data()
    run_pipeline()


if __name__ == "__main__":
    main()

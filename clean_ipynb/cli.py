import glob
from pathlib import Path

import plac
from wasabi import Printer

from .clean_ipynb import clean_ipynb, clean_py

msg = Printer()


@plac.annotations(
    path=("File or dir to clean", "positional", None, str),
    py=("Apply to .py source", "option", None, bool),
    ipynb=("Apply to .ipynb source", "option", None, bool),
    autoflake=("Apply autoflake to source", "option", None, bool),
    isort=("Apply isort to source", "option", None, bool),
    black=("Apply black to source", "option", None, bool),
)
def main(path, py=True, ipynb=True, autoflake=True, isort=True, black=True):
    path = Path(path)
    if not path.exists():
        raise ValueError("Provide a valid path to a file or directory")

    if path.is_dir():
        # recursively apply to all .py source within dir
        msg.info(f"Recursively cleaning directory: {path}")
        if py:
            for e in glob.iglob(path.as_posix() + "/**/*.py", recursive=True):
                try:
                    msg.info(f"Cleaning file: {e}")
                    clean_py(e, autoflake, isort, black)
                except:
                    msg.fail(f"Unable to clean file: {e}")
        if ipynb:
            # recursively apply to all .ipynb source within dir
            for e in glob.iglob(path.as_posix() + "/**/*.ipynb", recursive=True):
                try:
                    msg.info(f"Cleaning file: {e}")
                    clean_ipynb(e, autoflake, isort, black)
                except:
                    msg.fail(f"Unable to clean file: {e}")

    if path.is_file():
        msg.info(f"Cleaning file: {path}")

        if path.suffix not in [".py", ".ipynb"]:
            # valid extensions
            raise ValueError("Ensure valid .py or .ipynb path is provided")

            if py and path.suffix == ".py":
                clean_py(path, autoflake, isort, black)

            if ipynb and path.suffix == ".ipynb":
                clean_ipynb(path, autoflake, isort, black)


def main_wrapper():
    plac.call(main)

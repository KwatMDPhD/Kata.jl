import glob
from pathlib import Path

import plac
from wasabi import Printer

from .clean_ipynb import clean_ipynb, clean_py

msg = Printer()


@plac.annotations(
    path=("File or dir to clean", "positional", None, str),
    no_py=("Do not apply to .py source", "flag"),
    no_ipynb=("Do not apply to .ipynb source", "flag"),
    no_autoflake=("Do not apply autoflake to source", "flag"),
    no_isort=("Do not apply isort to source", "flag"),
    no_black=("Do not apply black to source", "flag"),
    keep_output=("Do not clear jupyter notebook output", "flag"),
)
def main(
    path,
    no_py=False,
    no_ipynb=False,
    no_autoflake=False,
    no_isort=False,
    no_black=False,
    keep_output=False,
):
    if no_py and no_ipynb:
        raise ValueError(
            "Processing of both Python and Jupyter notebook files disabled."
        )
    if no_autoflake and no_isort and no_black and keep_output:
        raise ValueError(
            "All processing disabled. Remove one or more flags to permit processing."
        )

    py = not no_py
    ipynb = not no_ipynb
    autoflake = not no_autoflake
    isort = not no_isort
    black = not no_black
    clear_output = not keep_output

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
                    clean_ipynb(e, clear_output, autoflake, isort, black)
                except:
                    msg.fail(f"Unable to clean file: {e}")

    if path.is_file():
        if path.suffix not in [".py", ".ipynb"]:
            # valid extensions
            raise ValueError("Ensure valid .py or .ipynb path is provided")

        if py and path.suffix == ".py":
            msg.info(f"Cleaning file: {path}")
            clean_py(path, autoflake, isort, black)

        elif ipynb and path.suffix == ".ipynb":
            msg.info(f"Cleaning file: {path}")
            clean_ipynb(path, clear_output, autoflake, isort, black)


def main_wrapper():
    plac.call(main)

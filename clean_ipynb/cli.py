import argparse
import glob
from pathlib import Path

from wasabi import Printer

from .clean_ipynb import clean_ipynb, clean_py

msg = Printer()


def main(
    path, py=True, ipynb=True, autoflake=True, isort=True, black=True, clear_output=True
):
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

    elif path.is_file():
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
    parser = argparse.ArgumentParser(description="Clean .py and .ipynb files.")
    parser.add_argument("path", nargs="+", help="File(s) or dir(s) to clean")
    parser.add_argument("-p", "--no-py", help="Ignore .py sources", action="store_true")
    parser.add_argument(
        "-n", "--no-ipynb", help="Ignore .ipynb sources", action="store_true"
    )
    parser.add_argument(
        "-f", "--no-autoflake", help="Do not apply autoflake", action="store_true"
    )
    parser.add_argument(
        "-i", "--no-isort", help="Do not apply isort", action="store_true"
    )
    parser.add_argument(
        "-b", "--no-black", help="Do not apply black", action="store_true"
    )
    parser.add_argument(
        "-o",
        "--keep-output",
        help="Do not clear jupyter notebook output",
        action="store_true",
    )
    args = parser.parse_args()

    if args.no_py and args.no_ipynb:
        raise ValueError(
            "Processing of both Python and Jupyter notebook files disabled."
        )
    if args.no_autoflake and args.no_isort and args.no_black and args.keep_output:
        raise ValueError(
            "All processing disabled. Remove one or more flags to permit processing."
        )

    for path in args.path:
        main(
            path,
            py=not args.no_py,
            ipynb=not args.no_ipynb,
            autoflake=not args.no_autoflake,
            isort=not args.no_isort,
            black=not args.no_black,
            clear_output=not args.keep_output,
        )

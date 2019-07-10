import argparse
import glob
from json import dumps
from pathlib import Path

from wasabi import Printer

from . import VERSION
from .clean_ipynb import clean_ipynb, clean_py

msg = Printer()


def main(
    path, py=True, ipynb=True, autoflake=True, tools_json=False, clear_output=True
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
                    clean_py(e, autoflake, tools_json)
                except:
                    msg.fail(f"Unable to clean file: {e}")
        if ipynb:
            # recursively apply to all .ipynb source within dir
            for e in glob.iglob(path.as_posix() + "/**/*.ipynb", recursive=True):
                try:
                    msg.info(f"Cleaning file: {e}")
                    clean_ipynb(e, clear_output, autoflake, tools_json)
                except:
                    msg.fail(f"Unable to clean file: {e}")

    elif path.is_file():
        if path.suffix not in [".py", ".ipynb"]:
            # valid extensions
            raise ValueError("Ensure valid .py or .ipynb path is provided")

        if py and path.suffix == ".py":
            msg.info(f"Cleaning file: {path}")
            clean_py(path, autoflake, tools_json)

        elif ipynb and path.suffix == ".ipynb":
            msg.info(f"Cleaning file: {path}")
            clean_ipynb(path, clear_output, autoflake, tools_json)


def main_wrapper():
    parser = argparse.ArgumentParser(
        description=(
            "Tidy and remove redundant imports (via autoflake), sort imports (via "
            "isort), lint and standardize (via black: default / yapf: enable via flag). "
            "Custom formatters are allowed using JSON. Apply equally to entire .py or "
            ".ipynb files, or directories containing such files. Additionally, clear "
            "all .ipynb cell outputs and execution counts (squeeze those diffs!)."
        )
    )
    parser.add_argument("path", nargs="+", help="File(s) or dir(s) to clean")
    parser.add_argument("-p", "--no-py", help="Ignore .py sources", action="store_true")
    parser.add_argument(
        "-n", "--no-ipynb", help="Ignore .ipynb sources", action="store_true"
    )
    parser.add_argument(
        "-f", "--no-autoflake", help="Do not apply autoflake (By default does not use autoflake for ipynb)", action="store_true"
    )
    parser.add_argument(
        "-i", "--no-isort", help="Do not apply isort", action="store_true"
    )
    parser.add_argument(
        "-b", "--no-black", help="Do not apply black", action="store_true"
    )
    parser.add_argument(
        "-y", "--yes-yapf", help="Apply yapf instead of black", action="store_true"
    )
    parser.add_argument(
        "-j",
        "--tools-json",
        help="Use Custom Tools using JSON (This has higher precedence over flags -b, -y, -i if conficting intentions are made) - either provide json as string to this flag or give path of json to this flag",
        action="store_true",
    )
    parser.add_argument(
        "-o",
        "--clear-output",
        help="Clear jupyter notebook output",
        action="store_true",
    )
    parser.add_argument(
        "-v",
        "--version",
        help=f"Show the %(prog)s version number",
        action="version",
        version=f"%(prog)s {VERSION}",
    )
    args = parser.parse_args()

    if args.no_py and args.no_ipynb:
        raise ValueError(
            "Processing of both Python and Jupyter notebook files disabled."
        )
    if (
        args.no_autoflake
        and args.no_isort
        and args.no_black
        and (not args.yes_yapf)
        and (not args.json_tools)
        and (not args.keep_output)
    ):
        raise ValueError(
            "All processing disabled. Remove one or more flags to permit processing."
        )

    json_create_helper_dict = {}

    if args.no_black or args.yes_yapf:
        # Disable black in json
        json_create_helper_dict["black"] = {
            "command": "black",
            "args": ["-"],
            "active": False,
        }
    if args.no_isort:
        # Disable isort in json
        json_create_helper_dict["isort"] = {
            "command": "isort",
            "args": ["-"],
            "active": False,
        }
    if args.yes_yapf:
        # Enable yapf in json
        json_create_helper_dict["yapf"] = {
            "command": "yapf",
            "args": [],
            "active": True,
        }

    json_final = False

    if args.tools_json:
        test_file = Path(args.tools_json)
        if not (args.no_black or args.yes_yapf or args.no_isort):
            json_final = args.tools_json
        elif test_file.is_file():
            # json file's path is provided
            with open(args.tools_json, "r") as f:
                user_tools_with_pipe = load(f)
            json_create_helper_dict = {
                **json_create_helper_dict,
                **user_tools_with_pipe,
            }
        else:
            # json directly provided as string
            user_tools_with_pipe = loads(tools_json)
            json_create_helper_dict = {
                **json_create_helper_dict,
                **user_tools_with_pipe,
            }

    json_final = dumps(json_create_helper_dict)

    for path in args.path:
        main(
            path,
            py=not args.no_py,
            ipynb=not args.no_ipynb,
            autoflake=not args.no_autoflake,
            tools_json=json_final,
            clear_output=args.clear_output,
        )


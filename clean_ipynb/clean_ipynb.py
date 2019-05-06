import glob
from json import dump, load
from shutil import copyfile
from subprocess import run
from multiprocessing.dummy import Pool
from multiprocessing import cpu_count
from wasabi import Printer
from pathlib import Path
from subprocess import PIPE, Popen
from autoflake import fix_code
import plac

pool = Pool(cpu_count())
msg = Printer()


def clean_python_code(python_code, isort=True, black=True, autoflake=True):
    # run source code string through autoflake, isort, and black
    if autoflake:
        # programmatic autoflake
        python_code = fix_code(
            python_code,
            expand_star_imports=True,
            remove_all_unused_imports=True,
            remove_duplicate_keys=True,
            remove_unused_variables=True,
        )

    pipe = Popen(
        ("echo", python_code), stdout=PIPE, stderr=PIPE, universal_newlines=True
    )

    if isort:
        pipe = Popen(
            ("isort", "-"),
            stdin=pipe.stdout,
            stdout=PIPE,
            stderr=PIPE,
            universal_newlines=True,
        )

    if black:
        pipe = Popen(
            ("black", "-"),
            stdin=pipe.stdout,
            stdout=PIPE,
            stderr=PIPE,
            universal_newlines=True,
        )

    return pipe.communicate()[0].strip()


def clear_ipynb_output(ipynb_file_path):
    # clear cell outputs, reset cell execution count of each cell in a jupyer notebook
    run(
        (
            "jupyter",
            "nbconvert",
            "--ClearOutputPreprocessor.enabled=True",
            "--inplace",
            ipynb_file_path,
        ),
        check=True,
    )


def clean_ipynb_cell(cell_dict):
    # clean a single cell within a jupyter notebook
    if cell_dict["cell_type"] == "code":
        clean_lines = clean_python_code("".join(cell_dict["source"])).split("\n")

        if len(clean_lines) == 1 and clean_lines[0] == "":
            clean_lines = []
        else:
            clean_lines[:-1] = [clean_line + "\n" for clean_line in clean_lines[:-1]]
        cell_dict["source"] = clean_lines
        return cell_dict
    else:
        return cell_dict


def clean_ipynb(
    ipynb_file_path, clear_output=True, autoflake=True, isort=True, black=True
):
    # load, clean and write .ipynb source in-place, back to original file
    if clear_output:
        clear_ipynb_output(ipynb_file_path)

    with open(ipynb_file_path) as ipynb_file:
        ipynb_dict = load(ipynb_file)

    # mulithread the map operation
    processed_cells = pool.map(clean_ipynb_cell, ipynb_dict["cells"])
    ipynb_dict["cells"] = processed_cells

    with open(ipynb_file_path, "w") as ipynb_file:
        dump(ipynb_dict, ipynb_file, indent=1)
        ipynb_file.write("\n")


def create_file(file_path, contents):
    file_path.touch()
    file_path.open("w", encoding="utf-8").write(contents)


def clean_py(py_file_path, autoflake=True, isort=True, black=True):
    # load, clean and write .py source, write cleaned file back to disk
    with open(py_file_path, "r") as file:
        source = file.read()

    clean_lines = clean_python_code("".join(source))
    create_file(Path(py_file_path), clean_lines)


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
        msg.info(f"Recursively cleaning directory: {path}")
        if py:
            for e in glob.iglob(path.as_posix() + "/**/*.py", recursive=True):
                try:
                    msg.info(f"Cleaning file: {e}")
                    clean_py(e, autoflake, isort, black)
                except:
                    msg.fail(f"Unable to clean file: {e}")
        if ipynb:
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


if __name__ == "main":
    plac.call(main)

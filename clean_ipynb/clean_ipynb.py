import re
from functools import partial
from json import dump, load
from multiprocessing import cpu_count
from multiprocessing.dummy import Pool
from pathlib import Path
from subprocess import PIPE, Popen, run

from autoflake import fix_code

pool = Pool(cpu_count())


def clean_python_code(python_code, isort=True, black=True, autoflake=True):
    # temporarily comment out ipython %magic to avoid black errors
    python_code = re.sub("^%", "##%##", python_code, flags=re.M)

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

    cleaned_code = pipe.communicate()[0].strip()
    # restore ipython %magic
    cleaned_code = re.sub("^##%##", "%", cleaned_code, flags=re.M)
    return cleaned_code


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


def clean_ipynb_cell(cell_dict, autoflake=True, isort=True, black=True):
    # clean a single cell within a jupyter notebook
    if cell_dict["cell_type"] == "code":
        clean_lines = clean_python_code(
            "".join(cell_dict["source"]), isort=isort, black=black, autoflake=autoflake
        ).split("\n")

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

    clean_cell_with_options = partial(
        clean_ipynb_cell, isort=isort, black=black, autoflake=autoflake
    )
    # mulithread the map operation
    processed_cells = pool.map(clean_cell_with_options, ipynb_dict["cells"])
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

    clean_lines = clean_python_code(
        "".join(source), isort=isort, black=black, autoflake=autoflake
    )
    create_file(Path(py_file_path), clean_lines + "\n")

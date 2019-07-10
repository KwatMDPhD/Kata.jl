import re
from functools import partial
from json import dump, load, loads
from multiprocessing import cpu_count
from multiprocessing.dummy import Pool
from pathlib import Path
from subprocess import PIPE, Popen, run

from autoflake import fix_code

pool = Pool(cpu_count())

# These are default tools which are run using piping
tools_with_pipe = {
    "black": {"command": "black", "args": ["-q", "-"], "active": True},
    "isort": {"command": "isort", "args": ["-"], "active": True},
    "yapf": {"command": "yapf", "args": [], "active": False},
}


def check_user_input_format(inp):
    for key, value in inp.items():
        if not isinstance(value, dict):
            raise ValueError(
                f'Error in JSON provided: `{key}` doesn\'t have attribute of type JSON Object - "{key}": {value}'
            )
        if not ("command" in value) or not isinstance(value["command"], str):
            raise ValueError(
                f"Error in JSON provided: `{key}`'s JSON Object either doesn't have attribute `command` or it is not a string - \"{key}\": {value}"
            )
        if not ("args" in value) or not isinstance(value["args"], list):
            raise ValueError(
                f"Error in JSON provided: `{key}`'s JSON Object either doesn't have attribute `args` or it is not a array - \"{key}\": {value}"
            )
        if not ("active" in value) or not isinstance(value["active"], bool):
            raise ValueError(
                f"Error in JSON provided: `{key}`'s JSON Object either doesn't have attribute `active` or it is not a boolean - \"{key}\": {value}"
            )


def clean_python_code(python_code, autoflake=True, tools_json=False):
    global tools_with_pipe
    # temporarily comment out ipython %magic to avoid black / yapf errors
    python_code = re.sub("^%", "##%##", python_code, flags=re.M)
    python_code = re.sub("^!", "##!##", python_code, flags=re.M)

    # run source code string through autoflake
    if autoflake:
        # programmatic autoflake
        python_code = fix_code(
            python_code,
            expand_star_imports=True,
            remove_all_unused_imports=True,
            remove_duplicate_keys=True,
            remove_unused_variables=True,
        )

    # process tools_json if provided
    if isinstance(tools_json, str):
        test_file = Path(tools_json)
        if test_file.is_file():
            # json file's path is provided
            with open(tools_json, "r") as f:
                user_tools_with_pipe = load(f)
        else:
            # json directly provided as string
            user_tools_with_pipe = loads(tools_json)
        check_user_input_format(user_tools_with_pipe)
        # Update tools_with_pipe from configurations of user with users preferences taking precedence
        tools_with_pipe = {**tools_with_pipe, **user_tools_with_pipe}

    # run source code through elements in tools_with_pipe.keys()
    for tool in tools_with_pipe.values():
        if tool["active"]:
            pipe = Popen(
                ([tool["command"]] + tool["args"]),
                stdin=PIPE,
                stdout=PIPE,
                stderr=PIPE,
                universal_newlines=True,
            )
            python_code, stderrdata = pipe.communicate(python_code)
            if stderrdata != "":
                raise Exception(stderrdata)

    # restore ipython %magic
    python_code = re.sub("^##%##", "%", python_code, flags=re.M)
    python_code = re.sub("^##!##", "!", python_code, flags=re.M)
    return python_code


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


def clean_ipynb_cell(cell_dict, autoflake=False, tools_json=False):
    autoflake = False # So that imports wont be removed and cause errors for future cells
    # clean a single cell within a jupyter notebook
    if cell_dict["cell_type"] == "code":
        clean_lines = clean_python_code(
            "".join(cell_dict["source"]), tools_json=tools_json, autoflake=autoflake
        ).split(sep="\n")
        if len(clean_lines) == 1 and clean_lines[0] == "":
            clean_lines = []
        else:
            clean_lines[:-1] = [clean_line + "\n" for clean_line in clean_lines[:-1]]
        rem_extra_new_line = clean_lines[-2][:-1]
        clean_lines[-2] = rem_extra_new_line
        cell_dict["source"] = clean_lines
        return cell_dict
    else:
        return cell_dict


def clean_ipynb(ipynb_file_path, clear_output=False, autoflake=False, tools_json=False):
    autoflake = False # So that imports wont be removed and cause errors for future cells
    # load, clean and write .ipynb source in-place, back to original file
    if clear_output:
        clear_ipynb_output(ipynb_file_path)

    with open(ipynb_file_path) as io:
        ipynb_dict = load(io)

    clean_cell_with_options = partial(
        clean_ipynb_cell, tools_json=tools_json, autoflake=autoflake
    )
    # mulithread the map operation
    processed_cells = pool.map(clean_cell_with_options, ipynb_dict["cells"])
    ipynb_dict["cells"] = processed_cells

    with open(ipynb_file_path, "w") as io:
        dump(ipynb_dict, io, indent=1)
        io.write("\n")


def create_file(file_path, contents):
    file_path.touch()
    file_path.open("w", encoding="utf-8").write(contents)


def clean_py(py_file_path, autoflake=True, tools_json=False):
    # load, clean and write .py source, write cleaned file back to disk
    with open(py_file_path, "r") as io:
        source = io.read()

    clean_lines = clean_python_code(
        "".join(source), tools_json=tools_json, autoflake=autoflake
    )
    create_file(Path(py_file_path), clean_lines + "\n")


from json import dump, load
from shutil import copyfile

from .can_clean_julia_code import can_clean_julia_code
from .clean_julia_code import clean_julia_code
from .clean_python_code import clean_python_code
from .clear_ipynb_output import clear_ipynb_output


def clean_ipynb(ipynb_file_path, overwrite):

    if not overwrite:

        ipynb_file_path = copyfile(
            ipynb_file_path, ipynb_file_path.replace(".ipynb", ".cleaned.ipynb")
        )

    clear_ipynb_output(ipynb_file_path)

    with open(ipynb_file_path) as io:

        ipynb_dict = load(io)

    language = ipynb_dict["metadata"]["language_info"]["name"]

    can_clean_julia_code_ = can_clean_julia_code()

    if language == "python":

        clean_code = clean_python_code

    elif language == "julia" and can_clean_julia_code_:

        clean_code = clean_julia_code

    for cell_dict in ipynb_dict["cells"]:

        if cell_dict["cell_type"] == "code":

            clean_lines = clean_code("".join(cell_dict["source"])).split(sep="\n")

            if len(clean_lines) == 1 and clean_lines[0] == "":

                clean_lines = []

            else:

                clean_lines[:-1] = [
                    "{}\n".format(clean_line) for clean_line in clean_lines[:-1]
                ]

            cell_dict["source"] = clean_lines

    with open(ipynb_file_path, mode="w") as io:

        dump(ipynb_dict, io, indent=1)

        io.write("\n")

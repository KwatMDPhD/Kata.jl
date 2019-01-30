from json import dump, load
from shutil import copyfile

from .clean_python_code import clean_python_code
from .clear_ipynb_output import clear_ipynb_output


def clean_ipynb(ipynb_file_path, black_opts, back_up, keep_output):
    """
    :param black_opts: additional arguments to pass to black utility
    :type black_opts: list of str
    """

    if back_up:

        copyfile(ipynb_file_path, ipynb_file_path.replace(".ipynb", ".back_up.ipynb"))

    if not keep_output:

        clear_ipynb_output(ipynb_file_path)

    with open(ipynb_file_path) as ipynb_file:

        ipynb_dict = load(ipynb_file)

    for cell_dict in ipynb_dict["cells"]:

        if cell_dict["cell_type"] == "code":

            clean_lines = clean_python_code("".join(cell_dict["source"]), black_opts).split("\n")

            if len(clean_lines) == 1 and clean_lines[0] == "":

                clean_lines = []

            else:

                clean_lines[:-1] = [
                    clean_line + "\n" for clean_line in clean_lines[:-1]
                ]

            cell_dict["source"] = clean_lines

    with open(ipynb_file_path, "w") as ipynb_file:

        dump(ipynb_dict, ipynb_file, indent=1)

        ipynb_file.write("\n")

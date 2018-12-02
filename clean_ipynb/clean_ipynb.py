from json import dump, load
from shutil import copyfile

from .clean_python_code import clean_python_code
from .clear_ipynb_output import clear_ipynb_output


def clean_ipynb(ipynb_file_path, back_up=True, clear_output=True):

    if back_up:

        copyfile(ipynb_file_path, ipynb_file_path.replace(".ipynb", ".back_up.ipynb"))

    if clear_output:

        clear_ipynb_output(ipynb_file_path)

    with open(ipynb_file_path) as ipynb_file:

        ipynb_dict = load(ipynb_file)

    for cell_dict in ipynb_dict["cells"]:

        if cell_dict["cell_type"] == "code":

            cell_dict["source"] = clean_python_code("".join(cell_dict["source"]))

    with open(ipynb_file_path, "w") as ipynb_file:

        dump(ipynb_dict, ipynb_file)

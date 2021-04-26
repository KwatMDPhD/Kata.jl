from json import dump, load
from shutil import copyfile

from .clean_jl import clean_jl
from .clean_py import clean_py
from .has_julia_and_juliaformatter import has_julia_and_juliaformatter


def clean_nb(path, new):

    if new:

        path = copyfile(path, path.replace(".ipynb", ".clean.ipynb"))

    with open(path) as io:

        nb = load(io)

    if "language_info" in nb["metadata"]:

        language = nb["metadata"]["language_info"]["name"]

        if language == "ipython" or "colab" in nb["metadata"]:

            language = "python"

    else:

        language = ""

    if language == "julia" and has_julia_and_juliaformatter():

        clean_function = clean_jl

    elif language == "python":

        clean_function = clean_py

    else:

        clean_function = None

    clean_cell_ = []

    for cell in nb["cells"]:

        if "execution_count" in cell:

            cell["execution_count"] = None

        if "outputs" in cell:

            cell["outputs"] = []

        if (
            "jupyter" in cell["metadata"]
            and "source_hidden" in cell["metadata"]["jupyter"]
        ):

            cell["metadata"]["jupyter"].pop("source_hidden")

        if cell["cell_type"] == "code" and clean_function is not None:

            code = "".join(cell["source"])

            if code.strip() == "":

                continue

            clean_line_ = clean_function(code).splitlines()

            clean_line_[:-1] = ["{}\n".format(line) for line in clean_line_[:-1]]

            cell["source"] = clean_line_

        clean_cell_.append(cell)

    nb["cells"] = clean_cell_

    with open(path, mode="w") as io:

        dump(nb, io, indent=1)

        io.write("\n")

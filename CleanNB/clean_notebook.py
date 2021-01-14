from json import dump, load
from shutil import copyfile

from .clean_code import clean_code
from .log import log


def clean_notebook(path, new):

    if new:

        path = copyfile(path, path.replace(".ipynb", ".clean.ipynb"))

    with open(path) as io:

        nb = load(io)

    language = ""

    if "language_info" in nb["metadata"]:

        language = nb["metadata"]["language_info"]["name"]

    if language == "ipython" or "colab" in nb["metadata"]:

        language = "python"

    if language == "julia":

        log("Cleaning julia code is coming soon...", kind="whisper")

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

        if "solution2" in cell["metadata"]:

            cell["metadata"]["solution2"] = "hidden"

        if cell["cell_type"] == "code":

            if language == "python":

                code = "".join(cell["source"])

                if code.strip() == "":

                    continue

                clean_line_ = clean_code(code).splitlines()

                clean_line_[:-1] = ["{}\n".format(line) for line in clean_line_[:-1]]

                cell["source"] = clean_line_

        clean_cell_.append(cell)

    nb["cells"] = clean_cell_

    with open(path, mode="w") as io:

        dump(nb, io, indent=1)

        io.write("\n")

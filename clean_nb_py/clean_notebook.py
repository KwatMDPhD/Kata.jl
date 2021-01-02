from click import secho
from json import dump, load
from shutil import copyfile

from .clean_code import clean_code


def clean_notebook(path, new):

    if new:

        path = copyfile(path, path.replace(".ipynb", ".clean.ipynb"))

    with open(path) as io:

        nb = load(io)

    metadata = nb["metadata"]

    if not (
        metadata.get("language_info", {}).get("name") in ("python", "ipython")
        or "colab" in metadata
    ):

        secho("Skipped notebook (is not python).", dim=True)

        return

    clean_cells = []

    for cell in nb["cells"]:

        if "execution_count" in cell:

            cell["execution_count"] = None

        if "outputs" in cell:

            cell["outputs"] = []

        if cell["cell_type"] == "code":

            code = "".join(cell["source"])

            if code.strip() == "":

                continue

            clean_lines = clean_code(code).splitlines()

            clean_lines[:-1] = ["{}\n".format(line) for line in clean_lines[:-1]]

            cell["source"] = clean_lines

        clean_cells.append(cell)

    nb["cells"] = clean_cells

    with open(path, mode="w") as io:

        dump(nb, io, indent=1)

        io.write("\n")

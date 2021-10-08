from json import dump, load
from shutil import copyfile

from . import CAN_JL, CAN_PY
from .clean_jl import clean_jl
from .clean_py import clean_py


def clean_nb(pa, ne):

    if ne:

        pa = copyfile(pa, pa.replace(".ipynb", ".clean.ipynb"))

    with open(pa) as io:

        nb = load(io)

    if "language_info" in nb["metadata"]:

        la = nb["metadata"]["language_info"]["name"]

        if la == "ipython" or "colab" in nb["metadata"]:

            la = "python"

    else:

        la = ""

    if la == "julia" and CAN_JL:

        fu = clean_jl

    elif la == "python" and CAN_PY:

        fu = clean_py

    else:

        fu = None

    ce_ = []

    for ce in nb["cells"]:

        if "execution_count" in ce:

            ce["execution_count"] = None

        if "outputs" in ce:

            ce["outputs"] = []

        if "jupyter" in ce["metadata"] and "source_hidden" in ce["metadata"]["jupyter"]:

            ce["metadata"]["jupyter"].pop("source_hidden")

        if ce["cell_type"] == "code" and fu is not None:

            co = "".join(ce["source"])

            if co.strip() == "":

                continue

            ce["source"] = fu(co).splitlines(keepends=True)

        ce_.append(ce)

    nb["cells"] = ce_

    with open(pa, mode="w") as io:

        dump(nb, io, indent=1)

        io.write("\n")

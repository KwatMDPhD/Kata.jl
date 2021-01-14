from click import Path, argument, command, option

from .clean_notebook import clean_notebook
from .log import log


@command()
@argument("path", type=Path(exists=True), required=True, nargs=-1)
@option("--new", is_flag=True)
def cli(path, new):
    """
    Clean Jupyter notebook.

    https://github.com/KwatME/CleanNB.py
    """

    for a_path in path:

        log(a_path)

        clean_notebook(a_path, new)

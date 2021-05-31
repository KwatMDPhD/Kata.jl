from click import Path, argument, command, option

from .clean_nb import clean_nb
from .log import log


@command()
@argument("path", type=Path(exists=True), required=True, nargs=-1)
@option("--new", is_flag=True)
def cli(path, new):
    """
    Clean Jupyter notebook.

    https://github.com/KwatME/cleannb
    """

    for pa in path:

        log(pa)

        clean_nb(pa, new)

from click import Path, argument, command, option, secho

from . import VERSION
from .clean_ipynb import clean_ipynb


@command()
@argument("ipynb-file-paths", nargs=-1, type=Path(exists=True))
@option("--back-up", is_flag=True, help="Flag to back up .ipynb.")
@option("--keep-output", is_flag=True, help="Flag to keep .ipynb output.")
@option("--version", is_flag=True, help="Show the version and exit.")
def command_line_interface(ipynb_file_paths, back_up, keep_output, version):
    """
    Clean .ipynb one cell at a time inplace by: running isort, running black, and clearing output.

    (clean_ipynb is in beta, so use --back-up flag just in case.)
    """

    if version:

        secho(VERSION)

        return

    for ipynb_file_path in ipynb_file_paths:

        secho(ipynb_file_path, bg="black", fg="bright_green")

        clean_ipynb(ipynb_file_path, back_up, keep_output)

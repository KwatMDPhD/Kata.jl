from click import Path, argument, command, option, secho

from .clean_ipynb import clean_ipynb


@command()
@argument("ipynb-file-paths", nargs=-1, type=Path(exists=True))
@option("--back-up", "-b", is_flag=True, help="Whether to back up .ipynb")
@option("--keep-output", "-k", is_flag=True, help="Whether to keep output .ipynb")
def command_line_interface(ipynb_file_paths, back_up, keep_output):
    """
    Clean .ipynb one cell at a time inplace by: running isort, running black, and clearing output.

    clean_ipynb is in beta, so use --back-up flag just in case.
    """

    for ipynb_file_path in ipynb_file_paths:

        secho(ipynb_file_path, bg="black", fg="bright_green")

        clean_ipynb(ipynb_file_path, back_up, keep_output)

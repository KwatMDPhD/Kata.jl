from click import Path, argument, command, option, secho

from .clean_ipynb import clean_ipynb


@command()
@argument("ipynb-file-paths", nargs=-1, type=Path(exists=True))
@option("--back-up", "-b", is_flag=True, help="Whether to back up")
@option("--clear-output", "-c", is_flag=True, help="Whether to clear output")
def command_line_interface(ipynb_file_paths, back_up, clear_output):

    for ipynb_file_path in ipynb_file_paths:

        secho(ipynb_file_path, bg="black", fg="bright_green")

        clean_ipynb(ipynb_file_path, back_up=back_up, clear_output=clear_output)

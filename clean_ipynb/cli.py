from click import Path, argument, command, option, secho

from .clean_ipynb import clean_ipynb


@command(context_settings={"help_option_names": ("-h",)})
@argument("ipynb_file_paths", nargs=-1, type=Path(exists=True))
@option("--back-up", is_flag=True)
@option("--keep-output", is_flag=True)
def cli(ipynb_file_paths, back_up, keep_output):
    """
    Clean .ipynb by clearning output and formatting Python (isort and black) and Julia code (JuliaFormatter.jl).
    """

    for ipynb_file_path in ipynb_file_paths:

        secho(ipynb_file_path, bg="black", fg="bright_green")

        clean_ipynb(ipynb_file_path, back_up, keep_output)

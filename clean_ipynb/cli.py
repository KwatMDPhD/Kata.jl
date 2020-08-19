from click import Path, argument, command, option, secho

from .clean_ipynb import clean_ipynb


@command(context_settings={"help_option_names": ("-h",)})
@argument("ipynb_file_paths", nargs=-1, type=Path(exists=True))
@option("--overwrite", is_flag=True)
#@option("--formatOnly", is_flag=True)
def cli(ipynb_file_paths, overwrite): #, formatOnly):
    """
    Clean .ipynb.

    https://github.com/kwatme/clean_ipynb
    """

    for ipynb_file_path in ipynb_file_paths:

        secho(ipynb_file_path, bg="black", fg="bright_green")

        clean_ipynb(ipynb_file_path, overwrite, formatOnly=True)

from click import Path, argument, command, option, secho

from .clean_notebook import clean_notebook


@command(context_settings={"help_option_names": ("-h",)})
@argument("paths", nargs=-1, type=Path(exists=True))
@option("--new", is_flag=True)
def cli(paths, new):
    """
    Clean Jupyter notebook (python).

    https://github.com/KwatME/clean_nb_py
    """

    for path in paths:

        secho(path, fg="bright_green", bold=True)

        clean_notebook(path, new)

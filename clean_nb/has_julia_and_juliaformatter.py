from subprocess import CalledProcessError, run

from .log import log


def has_julia_and_juliaformatter():

    try:

        run(["julia", "--eval", "using JuliaFormatter"], check=True)

        return True

    except (CalledProcessError, FileNotFoundError):

        log("Missing julia or JuliaFormatter.", ty="warn")

        return False

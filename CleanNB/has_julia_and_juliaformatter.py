from subprocess import CalledProcessError

from .log import log
from .run_command import run_command2


def has_julia_and_juliaformatter():

    try:

        run_command2(("julia", "--eval", "using JuliaFormatter"))

        return True

    except (CalledProcessError, FileNotFoundError):

        log("Missing julia or JuliaFormatter.", kind="warn")

        return False

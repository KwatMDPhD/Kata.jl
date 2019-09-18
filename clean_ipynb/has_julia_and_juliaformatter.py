from subprocess import CalledProcessError, run


def has_julia_and_juliaformatter():

    try:

        run(("julia", "--eval", "using JuliaFormatter"), check=True)

        return True

    except CalledProcessError:

        return False

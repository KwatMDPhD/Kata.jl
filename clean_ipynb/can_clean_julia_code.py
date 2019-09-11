from subprocess import CalledProcessError, run


def can_clean_julia_code():

    try:

        run(("julia", "--eval", "using JuliaFormatter"), check=True)

        return True

    except CalledProcessError:

        return False

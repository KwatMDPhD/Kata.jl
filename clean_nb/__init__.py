from os.path import dirname, expanduser, isfile, join
from subprocess import CalledProcessError, run

from .log import log

SO = join(expanduser("~"), ".juliaformatter.sysimage.so")


JL = join(dirname(__file__), "execution_file.jl")

try:

    log("Trying julia", ty="whisper")

    run(
        'julia --eval "using PackageCompiler; using JuliaFormatter"',
        shell=True,
        check=True,
    )

    if not isfile(SO):

        log("Precompiling {}".format(SO), ty="whisper")

        run(
            [
                "julia",
                "--eval",
                'using PackageCompiler; create_sysimage(["JuliaFormatter"]; sysimage_path = "{}", precompile_execution_file="{}")'.format(
                    SO, JL
                ),
            ],
            check=True,
        )

    CAN_JL = True

except:

    log("Problem with julia, PackageCompiler, or JuliaFormatter.", ty="warn")

    CAN_JL = False

log("Can{}clean julia code.".format([" not ", " "][CAN_JL]), ty="whisper")

CAN_PY = True

log("Can clean python code.", ty="whisper")

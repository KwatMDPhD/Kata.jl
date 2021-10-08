from os.path import dirname, expanduser, isfile, join
from subprocess import CalledProcessError, run

from .log import log

SO = join(expanduser("~"), ".juliaformatter.sysimage.so")


JL = join(dirname(__file__), "execution_file.jl")

try:

    print("Trying julia")

    run(
        'julia --eval "using PackageCompiler; using JuliaFormatter"',
        shell=True,
        check=True,
    )

    if not isfile(SO):

        print("Precompiling {}".format(SO))

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

print("Can{}clean julia code.".format([" not ", " "][CAN_JL]))

CAN_PY = True

print("Can clean python code.")

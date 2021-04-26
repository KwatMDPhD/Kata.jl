from .log import log
from .run_command import run_command


def clean_jl(code):

    completed_process = run_command(
        (
            "julia",
            "--eval",
            'using JuliaFormatter: format_text; print(format_text("""{}"""))'.format(
                code
            ),
        ),
    )

    communicate = completed_process.communicate()

    if communicate[1][:5] == "ERROR":

        log("Skipped cleaning cell:", kind="warn")

        log(code, kind="code")

        print()

        return code

    return communicate[0].strip()

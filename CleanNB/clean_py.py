from .log import log
from .run_command import run_command


def clean_py(code):

    completed_process = run_command(("echo", code))

    completed_process = run_command(
        ("isort", "-"),
        stdin=completed_process.stdout,
    )

    completed_process = run_command(
        ("black", "-"),
        stdin=completed_process.stdout,
    )

    communicate = completed_process.communicate()

    if communicate[1][:5] == "error":

        log("Skipped cleaning cell:", kind="warn")

        log(code, kind="code")

        print()

        return code

    return communicate[0].strip()

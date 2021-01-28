from .log import log
from .run_command import run_command


def clean_code(code):

    completed_process = run_command(("echo", code), None)

    completed_process = run_command(
        ("isort", "-"),
        completed_process.stdout,
    )

    completed_process = run_command(
        ("black", "-"),
        completed_process.stdout,
    )

    communicate = completed_process.communicate()

    if communicate[1][:5] == "error":

        log("Failed and skipped cleaning cell:", kind="warn")

        log(code, kind="code")

        print()

        return code

    return communicate[0].strip()

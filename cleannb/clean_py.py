from .log import log
from .pipe_command import pipe_command
from .return_completed_process import return_completed_process


def clean_py(code):

    completed_process = pipe_command(None, ("echo", code))

    completed_process = pipe_command(
        completed_process.stdout,
        ("isort", "-"),
    )

    completed_process = pipe_command(
        completed_process.stdout,
        ("black", "-"),
    )

    return return_completed_process(completed_process, code)

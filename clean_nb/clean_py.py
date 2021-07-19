from .pipe_command import pipe_command
from .return_completed_process import return_completed_process


def clean_py(co):

    pr = pipe_command(None, ["echo", co])

    pr = pipe_command(pr.stdout, ["isort", "-"])

    pr = pipe_command(pr.stdout, ["black", "-"])

    return return_completed_process(pr, co)

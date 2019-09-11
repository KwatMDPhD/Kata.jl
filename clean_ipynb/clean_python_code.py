from subprocess import PIPE, Popen


def clean_python_code(code):

    completed_process = Popen(
        ("echo", code), stdout=PIPE, stderr=PIPE, universal_newlines=True
    )

    completed_process = Popen(
        ("isort", "-"),
        stdin=completed_process.stdout,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )

    completed_process = Popen(
        ("black", "-"),
        stdin=completed_process.stdout,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )

    return completed_process.communicate()[0].strip()

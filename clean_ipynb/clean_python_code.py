from subprocess import PIPE, Popen


def clean_python_code(python_code, black_opts):
    """
    :param black_opts: additional arguments to pass to black utility
    :type black_opts: list of str
    """

    completed_process_echo = Popen(
        ("echo", python_code), stdout=PIPE, stderr=PIPE, universal_newlines=True
    )

    completed_process_isort = Popen(
        ("isort", "-"),
        stdin=completed_process_echo.stdout,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )

    completed_process_black = Popen(
        ["black"] + black_opts + ["-"],
        stdin=completed_process_isort.stdout,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True,
    )

    return completed_process_black.communicate()[0].strip()

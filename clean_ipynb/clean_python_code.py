from re import M, sub
from subprocess import PIPE, Popen


def clean_python_code(code):

    code_ = sub("^%", "# cleaning...%", code, flags=M)

    completed_process = Popen(
        ("echo", code_), stdout=PIPE, stderr=PIPE, universal_newlines=True
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

    # TODO: try [:-1] instead of strip
    clean_code = sub(
        r"^# cleaning...%", "%", completed_process.communicate()[0].strip(), flags=M
    )

    return clean_code

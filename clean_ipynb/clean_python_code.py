import re
from subprocess import PIPE, Popen


def clean_python_code(code):

    # temporarily comment out IPython %magic to avoid black errors
    code = re.sub("^%", "##%##", python_code, flags=re.M)

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

    cleaned_code = completed_process.communicate()[0].strip()

    # restore IPython %magic
    cleaned_code = re.sub("^##%##", "%", cleaned_code, flags=re.M)

    return cleaned_code

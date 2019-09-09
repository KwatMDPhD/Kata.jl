from subprocess import run


def clear_ipynb_output(ipynb_file_path):

    run(
        (
            "jupyter",
            "nbconvert",
            "--inplace",
            "--ClearOutputPreprocessor.enabled=True",
            "--log-level=0",
            ipynb_file_path,
        ),
        check=True,
    )

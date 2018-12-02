from subprocess import run


def clear_ipynb_output(ipynb_file_path):

    run(
        "jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace {}".format(
            ipynb_file_path
        ),
        shell=True,
        check=True,
    )

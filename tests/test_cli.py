import os
from subprocess import run


def test_cli():
    """Test the cleaning of a single Python notebook using the CLI."""
    raw_notebook = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "test_files",
        "raw_python_notebook.ipynb",
    )
    target_clean_notebook = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "test_files",
        "clean_python_notebook.ipynb",
    )

    # Make sure that the command ran successfully.
    assert not run(("clean_ipynb", raw_notebook)).returncode

    cleaned_notebook = raw_notebook.replace(".ipynb", ".cleaned.ipynb")
    with open(cleaned_notebook) as f:
        cleaned = f.read()
    os.remove(cleaned_notebook)

    with open(target_clean_notebook) as f:
        target_clean = f.read()

    assert target_clean == cleaned

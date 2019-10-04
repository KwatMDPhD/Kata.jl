import os

from clean_ipynb.clean_ipynb import clean_ipynb


def test_python_ipynb():
    """Test the cleaning of a single Python notebook."""
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

    clean_ipynb(raw_notebook, False)
    cleaned_notebook = raw_notebook.replace(".ipynb", ".cleaned.ipynb")
    with open(cleaned_notebook) as f:
        cleaned = f.read()
    os.remove(cleaned_notebook)

    with open(target_clean_notebook) as f:
        target_clean = f.read()

    assert target_clean == cleaned

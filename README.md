# Clean .ipynb

Clean .ipynb one cell at a time inplace by: running [isort](https://github.com/timothycrosley/isort), running [black](https://github.com/ambv/black), and clearing output :sunflower:

`clean_ipynb` is in beta, so use `--back-up` flag just in case.

## Install

```sh
pip install clean_ipynb
```

## Use

Clean `notebook/test.ipynb`

```sh
clean_ipynb --back-up notebook/input.ipynb
```

Find and clean `*.ipynb` recursively

```sh
find . -name '*.ipynb' -exec clean_ipynb --back-up {} \;
```

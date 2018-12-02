# Clean .ipynb

Clean .ipynb (isort, black, clear output, and more) :sunflower:

Install

```sh
pip install clean_ipynb
```

Example

Clean `notebook/input.ipynb`

```sh
clean_ipynb notebook/input.ipynb
```

Find and clean ``\*.ipynb\`

```sh
find . -name '*.ipynb' -exec clean_ipynb {} \;
```

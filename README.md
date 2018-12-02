# Clean .ipynb

Clean .ipynb ([isort](https://github.com/timothycrosley/isort), [black](https://github.com/ambv/black), clear output, and more) :sunflower:

# Install

```sh
pip install clean_ipynb
```

# Example

Clean `notebook/test.ipynb`

```sh
clean_ipynb notebook/input.ipynb
```

Find and clean `*.ipynb` recursively

```sh
find . -name '*.ipynb' -exec clean_ipynb {} \;
```

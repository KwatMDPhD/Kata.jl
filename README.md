# Clean .ipynb

Clean .ipynb inplace by clearing output and formatting the code with [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black) :sunflower:

## Install

Install from PyPI

```sh
pip install clean_ipynb
```

Install from GitHub (here)

```sh
git clone https://github.com/KwatME/clean_ipynb

cd clean_ipynb

pip install .
```

## Use

Clean 1 .ipynb

```sh
clean_ipynb eagle.ipynb
```

Clean 2 .ipynb

```sh
clean_ipynb eagle.ipynb honeybadger.ipynb
```

Clean all .ipynb

```sh
clean_ipynb *.ipynb
```

Recursively find and clean all .ipynb

```sh
find -name '*.ipynb' -exec clean_ipynb {} \;
```

## Improve

When you encounter a problem, please [submitting an issue](https://github.com/KwatME/clean_ipynb/issues/new).

When you want to improve the code, please fork it and open a pull request when ready.

Thank you :)

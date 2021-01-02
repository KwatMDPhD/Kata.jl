Program for cleaning Jupyter notebook.

`cleannbpy` is a command line program that clears output and formats [python](https://www.python.org) code using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black).

Official janitor of Google Colab.

## Install

```sh
pip install git+https://github.com/KwatME/clean_nb_py
```

## Use

```sh
cleannbpy a.ipynb
```

```sh
cleannbpy a.ipynb b.ipynb
```

```sh
cleannbpy *.ipynb
```

```sh
find . -name "*.ipynb" -exec cleannbpy {} \;
```

## Test

[notebook/dirty.ipynb](notebook/dirty.ipynb) is a dirty notebook.
(Make it dirtier and submit your pull request.)

Let's clean it:

```sh
cleannbpy --new notebook/dirty.ipynb
```

And look at the result [notebook/dirty.clean.ipynb](notebook/dirty.clean.ipynb).

## Checkout [clean_nb_jl](https://github.com/KwatME/clean_nb_jl)

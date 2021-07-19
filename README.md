`clean_nb` is a command line program for cleaning jupyter notebook.

It removes empty cells, clears output, and formats code written in [python](https://www.python.org) (using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and [julia](https://julialang.org) (using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

Official janitor of Google Colab.

## Install

```sh
python3 -m pip install git+https://github.com/KwatME/clean_nb
```

## Use

```sh
clean_nb a.ipynb
```

```sh
clean_nb a.ipynb b.ipynb
```

```sh
clean_nb *.ipynb
```

```sh
find . -name "*.ipynb" -exec clean_nb {} \;
```

## Test

[nb](nb) has dirty notebooks: [dirty_py.ipynb](nb/dirty_py.ipynb) and [dirty_jl.ipynb](nb/dirty_jl.ipynb).

Let's clean them:

```sh
clean_nb --new nb/dirty_py.ipynb nb/dirty_jl.ipynb
```

And look at the results: [dirty_py.clean.ipynb](nb/dirty_py.clean.ipynb) and [dirty_jl.clean.ipynb](nb/dirty_jl.clean.ipynb).

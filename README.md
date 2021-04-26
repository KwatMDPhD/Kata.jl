`cleannb` is a command line program for cleaning jupyter notebook.

It removes empty cells, clears output, and formats code written in [python](https://www.python.org) (using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and [julia](https://julialang.org) (using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

Official janitor of Google Colab.

## Install

```sh
python3 -m pip install git+https://github.com/KwatME/CleanNB.py
```

## Use

```sh
cleannb a.ipynb
```

```sh
cleannb a.ipynb b.ipynb
```

```sh
cleannb *.ipynb
```

```sh
find . -name "*.ipynb" -exec cleannb {} \;
```

## Test

[notebook/](notebook/) has dirty notebooks.

Let's clean them:

```sh
cleannb --new notebook/dirty_py.ipynb
```

```sh
cleannb --new notebook/dirty_jl.ipynb
```

And look at the results: [notebook/dirty_py.clean.ipynb](notebook/dirty_py.clean.ipynb) and [notebook/dirty_jl.clean.ipynb](notebook/dirty_jl.clean.ipynb).

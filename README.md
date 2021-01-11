Program for cleaning Jupyter notebook.

`cleannb` is a command line program that clears output and formats code written in:
- [python](https://www.python.org) (using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black))
- (coming soon) [julia](https://julialang.org) (using [CleanCode.jl](https://github.com/KwatME/CleanCode.jl))

Official janitor of Google Colab.

## Install

```sh
pip install git+https://github.com/KwatME/CleanNB.py
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

[notebook/dirty.ipynb](notebook/dirty.ipynb) is a dirty notebook.
(Make it dirtier and submit your pull request.)

Let's clean it:

```sh
cleannb --new notebook/dirty.ipynb
```

And look at the result [notebook/dirty.clean.ipynb](notebook/dirty.clean.ipynb).

## To do

Clean julia code

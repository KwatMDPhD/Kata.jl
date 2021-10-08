`clean-nb` is a command line program for cleaning jupyter notebook.

It removes empty cells, clears output, and formats code written in [python](https://www.python.org) (using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and [julia](https://julialang.org) (using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

Official janitor of Google Colab.

## Install

```sh
python -m pip install git+https://github.com/KwatME/clean_nb
```

Cleaning python code comes out of the box.
For cleaning julia code, install the following:

```julia
using Pkg: add, build

for na in (
    "JuliaFormatter",
    "PackageCompiler",
)

    add(na)

end
```

## Use

```sh
clean-nb a.ipynb
```

```sh
clean-nb a.ipynb b.ipynb
```

```sh
clean-nb *.ipynb
```

```sh
find . -name "*.ipynb" -exec clean-nb {} \;
```

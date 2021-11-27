# clean_nb

Command-line program for cleaning `Jupyter notebook` (`.ipynb`) written in `Python` and `Julia` :broom: Official janitor of [Google Colab](https://colab.research.google.com) :construction_worker:

`clean-nb` removes empty cells, clears output, and formats code written in `Python` (using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and `Julia` (using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

## Use

```sh
clean-nb luffy.ipynb
```

```sh
clean-nb zoro.ipynb nami.ipynb usopp.ipynb
```

```sh
clean-nb *.ipynb
```

```sh
clean-nb **/*.ipynb
```

## Install

```sh
python -m pip install git+https://github.com/KwatMDPhD/clean_nb
```

Cleaning `Python` code comes out of the box.
For cleaning `Julia` code, install the following:

```julia
using Pkg

for na in [
    "JuliaFormatter",
    "PackageCompiler",
]

    Pkg.add(na)

end
```

:tada:

---

## Howdy :wave: :cowboy_hat_face:

To report a bug, request a feature, or leave a comment, just [submit an issue](https://github.com/KwatMDPhD/clean_nb/issues/new/choose).

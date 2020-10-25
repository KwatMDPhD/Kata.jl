Program for cleaning Jupyter notebooks (.ipynb).

`clean_ipynb` clears output and formats [Python](https://www.python.org) code using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black) (out of the box) and [Julia](https://julialang.org) code using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) (if `Julia` and `JuliaFormatter.jl` exist).

## Get

```sh
pip install git+https://github.com/kwatme/clean_ipynb
```

## Use

```sh
clean_ipynb a.ipynb
```

```sh
clean_ipynb --overwrite b.ipynb
```

```sh
clean_ipynb *.ipynb
```

```sh
find . -name "*.ipynb" -exec clean_ipynb {} \;
```

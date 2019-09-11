# Clean .ipynb

Simple program that cleans Jupyter notebook (.ipynb)

clean_ipynb clears output and formats code cell of [Python](https://www.python.org) using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black) and [Julia](https://julialang.org) using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl).

## Install

``` bash
pip install clean_ipynb
```

Optionally, install Julia and JuliaFormatter.jl for formatting Julia code.

## Use

``` bash
clean_ipynb a.ipynb
```

``` bash
clean_ipynb a.ipynb b.ipynb
```

``` bash
clean_ipynb *.ipynb
```

``` bash
find . -name "*.ipynb" -exec clean_ipynb --overwrite {} \;
```

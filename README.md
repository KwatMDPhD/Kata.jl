# Clean .ipynb

Clean .ipynb by clearning output and formatting [Python](https://www.python.org) (with [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and [Julia](https://julialang.org) (with [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)) code cells.

## Install

### Install clean_ipynb

``` bash
pip install clean_ipynb
```

### Install Julia and JuliaFormatter.jl

## Use

### Clean specified .ipynb

``` bash
clean_ipynb a.ipynb
```

``` bash
clean_ipynb a.ipynb b.ipynb
```

``` bash
clean_ipynb *.ipynb
```

### Find and clean multiple .ipynb

``` bash
find . -name "*.ipynb" -exec clean_ipynb {} \;
```

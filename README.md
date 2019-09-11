# Clean .ipynb

Clean .ipynb by clearning output and formatting code cells of [Python](https://www.python.org) (with [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and [Julia](https://julialang.org) (with [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

## Install

### Install clean_ipynb

``` bash
git clone https://github.com/KwatME/clean_ipynb

cd clean_ipynb

pip install .
```

### Install Julia and JuliaFormatter.jl

Without these installation, `clean_ipynb` skips formatting Julia code.

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
find . -name "*.ipynb" -exec clean_ipynb --overwrite {} \;
```

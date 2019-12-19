# Clean .ipynb

Simple program that cleans Jupyter notebooks (.ipynb)

`clean_ipynb` clears output and formats [Python](https://www.python.org) code cell using [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black) (out of the box) and [Julia](https://julialang.org) code cell using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) (if `Julia` and `JuliaFormatter.jl` exist).

## Install

```bash
pip install clean_ipynb
```

or

```bash
pip install git+https://github.com/KwatME/clean_ipynb
```

## Use

```bash
clean_ipynb a.ipynb
```

```bash
clean_ipynb --overwrite a.ipynb b.ipynb
```

```bash
clean_ipynb *.ipynb
```

```bash
find . -name "*.ipynb" -exec clean_ipynb {} \;
```

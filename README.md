# Clean .ipynb

Clean .ipynb by clearning output and formatting Python ([isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black)) and Julia code ([JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)).

## Install

``` bash
pip install clean_ipynb
```

## Clean specified .ipynb

``` bash
clean_ipynb eagle.ipynb
```

``` bash
clean_ipynb eagle.ipynb honeybadger.ipynb
```

``` bash
clean_ipynb *.ipynb
```

## Find and clean multiple .ipynb

``` bash
find . -name "*.ipynb" -exec clean_ipynb {} \;
```

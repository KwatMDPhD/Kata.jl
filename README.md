# Clean .ipynb

Clean `.ipynb` inplace by clearing output and formatting the code with [isort](https://github.com/timothycrosley/isort) and [black](https://github.com/ambv/black) :sunflower:

(`clean_ipynb` is in beta, so use `--back-up` flag just in case.)

## Install

```sh
pip install clean_ipynb
```

## Clean specified `.ipynb`

```sh
clean_ipynb eagle.ipynb
```

```sh
clean_ipynb eagle.ipynb honeybadger.ipynb
```

```sh
clean_ipynb *.ipynb
```

## Find and clean multiple `.ipynb`

```sh
find . -name '*.ipynb' -exec clean_ipynb --back-up {} \;
```

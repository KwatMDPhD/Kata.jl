### Clean IPYNB/PY
Small CLI program capable of cleaning ```.ipynb``` and ```.py``` source. Tidy and remove redundant imports (via [autoflake](https://github.com/myint/autoflake)), sort imports (via [isort](https://github.com/timothycrosley/isort)), lint and standardize (via [black](https://github.com/ambv/black)). Apply equally to entire ```.py``` or ```.ipynb``` files. Additionally, clear all ```.ipynb``` cell outputs and execution counts (squeeze those diffs!). Forked from KwatMe's orginal [repo](https://github.com/KwatME/clean_ipynb).

### 1.0 Up and Running
Via git pip:
```sh
pip install git+https://github.com/KwatME/clean_ipynb
```

Via source:
```sh
git clone https://github.com/KwatME/clean_ipynb
cd clean_ipynb
pip install .
```

### 2.0 Use
Clean ```.ipynb``` source:
```sh
clean_ipynb a_single_notebook.ipynb
```

Or ```.py``` source:
```sh
clean_ipynb a_single_script.py
```

Or an entire directory recursively:
```sh
clean_ipynb <some_dir_containing_py_ipynb_source>
```

Clean with specific features if necessary (uses all features by default):
```sh
clean_ipynb <some_dir_containing_py_ipynb_source> -no-black -no-autoflake
```

A full list of parameters can be found via:
```sh
clean_ipynb --help
```

### Todo
* **Unit tests.** Null parameter, invalid parameter edge cases etc.
* **Reimplement sub-command arg parsing.** Parse specific black/autoflake/isort args to main CLI.
* **Remove subprocess calls.** Reach into subprograms, natively use without subprocess calls.
* **Autoflake for ipynb sources.** Keep imported modules which are not used immediately in the cell they are imported in. The current default behaviour is problematic when imports are re-used throughout a notebook but only defined once in a cell dedicated just to this. Current workaround: use the flags `-no-py -no-autoflake` for jupyter notebooks, and `-no-ipynb` for python files (to avoid repeat operations when applied to directories).

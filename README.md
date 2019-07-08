### Clean IPYNB/PY
Small CLI program capable of cleaning ```.ipynb``` and ```.py``` sources. Tidy and remove redundant imports (via [autoflake](https://github.com/myint/autoflake)), sort imports (via [isort](https://github.com/timothycrosley/isort)), lint and standardize (via [black](https://github.com/ambv/black)). Apply equally to entire ```.py``` or ```.ipynb``` files. Additionally, clear all ```.ipynb``` cell outputs and execution counts (squeeze those diffs!). Forked from KwatMe's orginal [repo](https://github.com/KwatME/clean_ipynb).

### 1.0 Up and Running
Via git pip:
```bash
pip install git+https://github.com/KwatME/clean_ipynb
```

Via source:
```bash
git clone https://github.com/KwatME/clean_ipynb
cd clean_ipynb
pip install .
```

### 2.0 Use
Clean ```.ipynb``` source:
```bash
clean_ipynb a_single_notebook.ipynb
```

Or ```.py``` source:
```bash
clean_ipynb a_single_script.py
```

Or an entire directory recursively:
```bash
clean_ipynb <some_dir_containing_py_ipynb_source>
```

Or a list of files and directories:
```bash
clean_ipynb a_single_script.py <some_dir_containing_py_ipynb_source>
```

Clean without specific features if necessary (uses all features by default):
```bash
clean_ipynb <some_dir_containing_py_ipynb_source> --no-black --no-autoflake
```

A full list of parameters can be found via:
```bash
clean_ipynb --help
```

### 3.0 Features

- Added support for generic tooling i.e, use any tool for python code 
- It is reqired that the `command` when passed with `args` takes input from stdin & returns output in stdout, else your file wont get updated by tool
- Use of generic is supported by using `JSON`
  - `-j` or `--tools-json` flag is used to provide `json`
  - This flag takes both `<path/to/json>` and also `json` as string `{...}`
- Generic tooling has by default:
  - `black` enabled
  - `isort` enabled
  - `yapf` disabled
- Important to note:
  - Generic Tools mentioned in `json` are done in order, so you can decide which order to run formatters (this is enabled through ordered dicts)
    - This ensures that your tools are used in the order you specified (Except for `black` & `isort` which if active, will always be run at first in order `black`, `isort`)
    - And the
  - If conflicting configurations are specified in flags & `json` (Ex: for which formatter to use `black` or `yapf`), the one in `json` takes precedence

#### JSON Format

```json
{
    "<name_of_your_choice_for_tool>": {
        "command": "<command>",
        "args": ["<arg1>", "<arg2>", ...],
        "active": <boolean_incicating_whether_to_use_this_tool>
    }, 
    "<other_tool>": {
        ...
    }, 
    ...
}
```

Ex: If you want to use `autopep8` instead of `black`
```json
{
    "black": {
        "command": "black",
        "args": ["-"],
        "active": false
    },
    "autopep8": {
        "command": "autopep8",
        "args": [],
        "active": true
    }
}
```

### Todo
* **Unit tests.** Null parameter, invalid parameter edge cases etc.
* **Reimplement sub-command arg parsing.** Parse specific black/autoflake/isort args to main CLI.
* **Remove subprocess calls.** Reach into subprograms, natively use without subprocess calls.
* **Autoflake for ipynb sources.** Keep module imports which are only used in other cells. This will require awareness of all code cells at once for the application of autoflake. Current workaround: use the flags `--no-py --no-autoflake` for Jupyter notebooks, and `--no-ipynb` for Python files (to avoid repeat operations when applied to identical inputs for both sets of flags).
* **Read from standard input and write to standard output.** Exhibit behaviour analogous to other tools such as [black](https://github.com/ambv/black) which do this if `-` is used as a filename.
* **Handle errors of pipes gracefully** Use try to catch errors

from setuptools import setup

name = "clean_ipynb"

setup(
    name=name,
    version="0.0.1b",
    url="https://github.com/KwatME/clean_ipynb",
    author="Kwat ME",
    author_email="kwatme8@gmail.com",
    python_requires=">=3.6",
    install_requires=("black", "click"),
    packages=(name,),
    py_modules=(name,),
    entry_points={
        "console_scripts": ("{0}={0}.{1}:{1}".format(name, "command_line_interface"),)
    },
)

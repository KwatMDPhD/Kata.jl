from setuptools import setup

name = "clean_ipynb"

setup(
    name=name,
    version="1.1.1",
    python_requires=">=3.7",
    install_requires=("autoflake", "black", "click", "isort"),
    packages=(name,),
    entry_points={"console_scripts": ("{0}={0}.{1}:{1}".format(name, "cli"),)},
)

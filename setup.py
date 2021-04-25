from setuptools import setup

name = "cleannb"

setup(
    name=name,
    version="3.0.0",
    python_requires=">=3.6",
    install_requires=("black", "click", "isort"),
    packages=(name,),
    entry_points={
        "console_scripts": ("{0}={1}.{2}:{2}".format(name.lower(), name, "cli"),)
    },
)

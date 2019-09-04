from setuptools import setup

name = "clean_ipynb"

setup(
    name=name,
    url="https://github.com/KwatME/{}".format(name),
    version="0.6.0",
    author="Kwat Medetgul-Ernar",
    author_email="kwatme8@gmail.com",
    python_requires=">=3.7",
    install_requires=("black", "click==7.0"),
    packages=(name,),
    entry_points={"console_scripts": ("{0}={0}.{1}:{1}".format(name, "cli"),)},
)

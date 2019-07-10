from setuptools import find_packages, setup

from clean_ipynb import NAME, VERSION

setup(
    name=NAME,
    version=VERSION,
    url=f"https://github.com/KwatME/{NAME}",
    author="Kwat Medetgul-Ernar",
    author_email="kwatme8@gmail.com",
    packages=find_packages(),
    entry_points={"console_scripts": ["clean_ipynb=clean_ipynb.cli:main_wrapper"]},
    python_requires=">=3.6",
    install_requires=("black", "yapf", "wasabi", "isort", "jupyter", "autoflake"),
)

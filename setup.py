from clean_ipynb import NAME, VERSION
from setuptools import find_packages, setup

setup(
    name=NAME,
    version=VERSION,
    url="https://github.com/KwatME/{}".format(NAME),
    author="Kwat Medetgul-Ernar (Huwate Yeerna)",
    author_email="kwatme8@gmail.com",
    packages=find_packages(),
    python_requires=">=3.6",
    install_requires=("black", "click==7.0"),
    entry_points={
        "console_scripts": ("{0}={0}.{1}:{1}".format(NAME, "command_line_interface"),)
    },
)

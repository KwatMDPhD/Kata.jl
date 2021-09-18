from setuptools import find_packages, setup

na = "clean_nb"

setup(
    name=na,
    version="4.2.0",
    url="https://github.com/KwatME/clean_nb",
    python_requires=">=3.6.0",
    install_requires=["black", "click", "isort"],
    packages=find_packages(),
    entry_points={"console_scripts": ["{0}={1}.{2}:{2}".format(na.replace("_", "-"), na, "cli")]},
)

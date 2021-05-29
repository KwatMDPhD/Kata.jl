from setuptools import (
    setup,
)

n = "cleannb"

setup(
    name=n,
    version="3.1.0",
    python_requires=">=3.6",
    install_requires=(
        "black",
        "click",
        "isort",
    ),
    packages=(n,),
    entry_points={
        "console_scripts": (
            "{0}={1}.{2}:{2}".format(
                n.lower(),
                n,
                "cli",
            ),
        )
    },
)

from setuptools import setup

na = "clean_nb"

setup(
    name=na,
    version="4.0.0",
    python_requires=">=3.6",
    install_requires=["black", "click", "isort"],
    packages=[na],
    entry_points={
        "console_scripts": ["{0}={0}.{1}:{1}".format(na, "cli")],
    },
)

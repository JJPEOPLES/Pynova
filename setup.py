from setuptools import setup, find_packages

setup(
    name="pynova",
    version="0.1.0",
    description="PyNova Programming Language",
    author="PyNova Team",
    author_email="info@pynova.dev",
    url="https://github.com/pynova-dev/pynova",
    packages=find_packages(),
    install_requires=[
        "numba>=0.56.0",
        "PyQt5>=5.15.0",
        "ply>=3.11",
    ],
    entry_points={
        "console_scripts": [
            "pynova=pynova_core.cli:main",
            "pynova-ide=pynova_ide.main:main",
            "pynova-publish=pynova_publisher.cli:main",
        ],
    },
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires=">=3.6",
)
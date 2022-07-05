#!/bin/bash

pip3 install pytest -y
python3 -m pytest -v --junitxml=pytest_basics.xml --durations=10 test_basics.py

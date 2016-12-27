#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2016 Herman Bergwerf
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Dependencies:
# - Dart SDK in PATH (uses `pub` and `dart`)

# Variables
OBSERVATORY_PORT=8000
COVERAGE_OUTPUT=coverage.json
LCOV_OUTPUT=coverage.lcov

# Fast fail
set -e

# Get coverage package
pub global activate coverage

# 1. Run tests entry file (env `DART_TESTS_MAIN`)
# 2. Collect coverage report
# 3. Wait until ready
dart --checked --observe=$OBSERVATORY_PORT $DART_TESTS_MAIN & \
pub global run coverage:collect_coverage \
    --port=$OBSERVATORY_PORT \
    --out $COVERAGE_OUTPUT \
    --wait-paused \
    --resume-isolates & \
wait

# Format coverage as LCOV
pub global run coverage:format_coverage \
    --packages=./.packages \
    --report-on lib \
    --in $COVERAGE_OUTPUT \
    --out $LCOV_OUTPUT \
    --lcov

# Upload coverage to Codecov
# Note that you need to set `CODECOV_TOKEN` in your CI to make this work.
bash <(curl -s https://codecov.io/bash)

# Remove coverage data
rm $COVERAGE_OUTPUT
rm $LCOV_OUTPUT

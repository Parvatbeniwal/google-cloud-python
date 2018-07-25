#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

cd github/google-cloud-python

# Disable buffering, so that the logs stream through.
export PYTHONUNBUFFERED=1

# Debug: show build environment
env

# Find out if this package was modified.
python3.6 -m pip install git+https://github.com/tswast/ci-diff-helper.git
python3.6 test_utils/scripts/get_target_packages_kokoro.py > ~/target_packages
cat ~/target_packages

if [[ ! -n $(grep -x "$PACKAGE" ~/target_packages) ]]; then
    echo "$PACKAGE was not modified, returning."
    exit;
fi

cd "$PACKAGE"

python3.6 -m pip install --quiet nox-automation

nox
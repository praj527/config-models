#!/usr/bin/env bash

# Copyright 2018 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is to validate that a model Docker image does not already exists
# TODO as of now the models will always publish both a `latest` and `tagged` image,
# regardless of whether there is `-dev` version or not (we should not publish -dev tags)

set -eu -o pipefail

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

function is_version_up_to_date() {
    # returns false if files for the model have changed but the version has not been updated
    n_files_changed=$(git diff --name-only origin/master . | wc -l)
    version_changed=$(git diff --name-only origin/master . | grep VERSION | wc -l)

    if [[ $n_files_changed == 0 ]]; then
      # no files have changed, good to go
      echo "true"
    else
      # files have changed, check if VERSION is updated
      if [[ $version_changed == 0 ]]; then
        echo "false"
      else
        echo "true"
      fi
    fi
}

if [[ "$(is_version_up_to_date)" != "true" ]]; then
  echo -e "${RED}Plugin files have changed but version is not updated.${RESET}"
  exit 1
fi

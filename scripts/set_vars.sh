#!/usr/bin/env bash
set -eo pipefail

DM_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

export DM_ROOT_PATH="${DM_ROOT_PATH}"
export LD_LIBRARY_PATH="${DM_ROOT_PATH}/sc-machine/bin"
export REPO_PATH_FILE="${DM_ROOT_PATH}/repo.path"
export CONFIG_PATH="${DM_ROOT_PATH}/ostis-discrete-math.ini"

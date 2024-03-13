#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."
export REPO_PATH_FILE="$ROOT/repo.path"
export CONFIG_PATH="$ROOT/ostis-discrete-math.ini"

"$ROOT/sc-web/scripts/run_sc_web.sh" "$@"

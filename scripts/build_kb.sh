#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."
export REPO_PATH_FILE="$ROOT/repo.path"
export CONFIG_PATH="$ROOT/ostis-discrete-math.ini"
"$ROOT"/scripts/copy_ims_kb.sh

export LD_LIBRARY_PATH="$ROOT"/sc-machine/bin
if [ ! -d "$ROOT/kb.bin" ]; then
    mkdir "$ROOT"/kb.bin
fi
cd "$ROOT"
"$ROOT/sc-machine/scripts/build_kb.sh" -i "$ROOT"/repo.path

cd "$ROOT"/scripts


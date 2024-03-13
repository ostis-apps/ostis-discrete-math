#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${DM_ROOT_PATH}/sc-machine/scripts/build_kb.sh" -i "${DM_ROOT_PATH}/repo.path"

#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${DM_ROOT_PATH}/sc-web/scripts/run_sc_web.sh" "$@"

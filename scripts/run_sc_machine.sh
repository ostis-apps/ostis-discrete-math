#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${SC_MACHINE_PATH}/build/Release/bin/sc-machine" -c "${CONFIG_PATH}" \
  -e "${SC_MACHINE_PATH}/build/Release/lib/extensions;${SCP_MACHINE_PATH}/build/Debug/lib/extensions"

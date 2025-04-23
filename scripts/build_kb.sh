#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${SC_MACHINE_PATH}/build/Release/bin/sc-builder" -i "${REPO_PATH_FILE}" -c "${CONFIG_PATH}" --clear

echo "knowledge base was built successfully"

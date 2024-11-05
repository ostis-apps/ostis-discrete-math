#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${PLATFORM_PATH}/scripts/install_dependencies.sh" --dev

echo "dependencies were successfully installed"

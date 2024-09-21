#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

"${DM_SUBMODULE_SCRIPTS_PATH}/install_graph_theory_kb.sh"
"${DM_SUBMODULE_SCRIPTS_PATH}/install_graph_theory_ps.sh"
"${DM_SUBMODULE_SCRIPTS_PATH}/install_set_theory.sh"

"${PLATFORM_PATH}/scripts/install_submodules.sh"

echo "submodules were successfully installed"

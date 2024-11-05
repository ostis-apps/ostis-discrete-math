#!/usr/bin/env bash
set -eo pipefail

if [ -z "${PLATFORM_SUBMODULE_SCRIPTS_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/../set_vars.sh"
fi
UTILS_DIR="${PLATFORM_SUBMODULE_SCRIPTS_PATH}/utils"

if [[ -z "${GRAPH_THEORY_KB_REPO}" || -z "${GRAPH_THEORY_KB_PATH}" || -z "${GRAPH_THEORY_KB_BRANCH}" || -z "${GRAPH_THEORY_KB_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/install_submodule.sh" --repo "${GRAPH_THEORY_KB_REPO}" --path "${GRAPH_THEORY_KB_PATH}" --branch "${GRAPH_THEORY_KB_BRANCH}" --commit "${GRAPH_THEORY_KB_COMMIT}"

#!/usr/bin/env bash
set -eo pipefail

if [ -z "${PLATFORM_SUBMODULE_SCRIPTS_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/../set_vars.sh"
fi
UTILS_DIR="${PLATFORM_SUBMODULE_SCRIPTS_PATH}/utils"

if [[ -z "${SET_THEORY_REPO}" || -z "${SET_THEORY_PATH}" || -z "${SET_THEORY_BRANCH}" || -z "${SET_THEORY_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/install_submodule.sh" --repo "${SET_THEORY_REPO}" --path "${SET_THEORY_PATH}" --branch "${SET_THEORY_BRANCH}" --commit "${SET_THEORY_COMMIT}"

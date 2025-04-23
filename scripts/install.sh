#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

cd ${DM_ROOT_PATH} \
  && git clone "${PLATFORM_REPO}" --branch "${PLATFORM_BRANCH}" --single-branch \
  || { echo "OSTIS web platform wasn't installed"; exit 1; }

if [ -n "${PLATFORM_COMMIT}" ]
  then
    cd "${PLATFORM_PATH}" \
    && git checkout "${PLATFORM_COMMIT}"\
    || { echo "OSTIS web platform wasn't installed - unable to check out to the specified commit"; exit 1; }
fi

"${DM_SCRIPTS_PATH}/install_submodules.sh"
"${DM_SCRIPTS_PATH}/build_submodules.sh"
"${DM_SCRIPTS_PATH}/build_kb.sh"

echo "ostis-discrete-math was successfully installed"

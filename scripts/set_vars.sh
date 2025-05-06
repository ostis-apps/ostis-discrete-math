#!/usr/bin/env bash
set -eo pipefail

DM_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

export DM_ROOT_PATH="${DM_ROOT_PATH}"

export PLATFORM_REPO="https://github.com/ostis-ai/ostis-web-platform.git"
export PLATFORM_BRANCH="develop"
export PLATFORM_COMMIT="4c44df665a2daa8dd7395830cf30060f0dd999e3"
export PLATFORM_PATH="${DM_ROOT_PATH}/ostis-web-platform"
export PLATFORM_SUBMODULE_SCRIPTS_PATH="${DM_ROOT_PATH}/ostis-web-platform/scripts/submodule-scripts"

export SC_MACHINE_REPO="https://github.com/ostis-ai/sc-machine.git"
export SC_MACHINE_BRANCH="main"
export SC_MACHINE_COMMIT="24bebbffabacdb29ebcce9aa621aa23fe8bb504a"
export SC_MACHINE_PATH="${PLATFORM_PATH}/sc-machine"

export SCP_MACHINE_REPO="https://github.com/kilativ-dotcom/scp-machine.git"
export SCP_MACHINE_BRANCH="feat/increase_default_wait_time"
export SCP_MACHINE_COMMIT="f045854e848a741dcd783dc5a81947f3f46f987c"
export SCP_MACHINE_PATH="${PLATFORM_PATH}/scp-machine"

export SC_COMPONENT_MANAGER_REPO="https://github.com/ostis-ai/sc-component-manager.git"
export SC_COMPONENT_MANAGER_BRANCH="main"
export SC_COMPONENT_MANAGER_COMMIT="609b2e8dad83d59b28c07a5bc4bc8269504a8c0d"
export SC_COMPONENT_MANAGER_PATH="${PLATFORM_PATH}/sc-component-manager"

export SC_WEB_REPO="https://github.com/ostis-ai/sc-web.git"
export SC_WEB_BRANCH="main"
export SC_WEB_COMMIT="d4429622e303c00bc5a52c342f01579e93add2e0"
export SC_WEB_PATH="${PLATFORM_PATH}/interface/sc-web"

export IMS_KB_REPO="https://github.com/ostis-ai/ims.ostis.kb.git"
export IMS_KB_BRANCH="main"
export IMS_KB_COMMIT="592145835643500878d5fc837df99009cd756c24"
export IMS_KB_PATH="${PLATFORM_PATH}/kb/ims.ostis.kb"

export GRAPH_THEORY_KB_REPO="https://github.com/ostis-apps/gt-knowledge-base.git"
export GRAPH_THEORY_KB_BRANCH="master"
export GRAPH_THEORY_KB_COMMIT="ac711912930b0e8d2a737a94c873637cce2631b3"
export GRAPH_THEORY_KB_PATH="${PLATFORM_PATH}/kb/gt-knowledge-base"

export GRAPH_THEORY_PS_REPO="https://github.com/ostis-apps/gt-knowledge-processing-machine.git"
export GRAPH_THEORY_PS_BRANCH="master"
export GRAPH_THEORY_PS_COMMIT="3e4dbccd18c92e72a4a0a360e5de9aa7e4984157"
export GRAPH_THEORY_PS_PATH="${PLATFORM_PATH}/kb/gt-knowledge-processing-machine"

export SET_THEORY_REPO="https://github.com/ostis-apps/set-theory.git"
export SET_THEORY_BRANCH="master"
export SET_THEORY_COMMIT="d41614835745757b61eddafb4ad53e9a1337ccdc"
export SET_THEORY_PATH="${PLATFORM_PATH}/kb/set-theory"

export REPO_PATH_FILE="${DM_ROOT_PATH}/repo.path"
export CONFIG_PATH="${DM_ROOT_PATH}/ostis-discrete-math.ini"
export DM_SCRIPTS_PATH="${DM_ROOT_PATH}/scripts"
export DM_SUBMODULE_SCRIPTS_PATH="${DM_ROOT_PATH}/scripts/submodule-scripts"

if [ -d "${PLATFORM_PATH}" ];
then
  source "${PLATFORM_PATH}/scripts/set_vars.sh"
fi


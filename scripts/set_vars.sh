#!/usr/bin/env bash
set -eo pipefail

DM_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

export DM_ROOT_PATH="${DM_ROOT_PATH}"

export PLATFORM_REPO="https://github.com/ostis-ai/ostis-web-platform.git"
export PLATFORM_BRANCH="develop"
export PLATFORM_COMMIT="07b04bf543369d40c0b8b14220d98bc4b7865f76"
export PLATFORM_PATH="${DM_ROOT_PATH}/ostis-web-platform"
export PLATFORM_SUBMODULE_SCRIPTS_PATH="${DM_ROOT_PATH}/ostis-web-platform/scripts/submodule-scripts"

export SC_MACHINE_REPO="https://github.com/ostis-ai/sc-machine.git"
export SC_MACHINE_BRANCH="main"
export SC_MACHINE_COMMIT=""
export SC_MACHINE_PATH="${PLATFORM_PATH}/sc-machine"

export SCP_MACHINE_REPO="https://github.com/kilativ-dotcom/scp-machine.git"
export SCP_MACHINE_BRANCH="feat/remove_codegen"
export SCP_MACHINE_COMMIT=""
export SCP_MACHINE_PATH="${PLATFORM_PATH}/scp-machine"

export SC_COMPONENT_MANAGER_REPO="https://github.com/kilativ-dotcom/sc-component-manager.git"
export SC_COMPONENT_MANAGER_BRANCH="refactor/remove_codegen"
export SC_COMPONENT_MANAGER_COMMIT=""
export SC_COMPONENT_MANAGER_PATH="${PLATFORM_PATH}/sc-component-manager"

export SC_WEB_REPO="https://github.com/ostis-ai/sc-web.git"
export SC_WEB_BRANCH="main"
export SC_WEB_COMMIT=""
export SC_WEB_PATH="${PLATFORM_PATH}/interface/sc-web"

export IMS_KB_REPO="https://github.com/ostis-ai/ims.ostis.kb.git"
export IMS_KB_BRANCH="main"
export IMS_KB_COMMIT=""
export IMS_KB_PATH="${PLATFORM_PATH}/kb/ims.ostis.kb"

export GRAPH_THEORY_KB_REPO="https://github.com/ostis-apps/gt-knowledge-base.git"
export GRAPH_THEORY_KB_BRANCH="master"
export GRAPH_THEORY_KB_COMMIT="191912aca62dd7ee04df1ecc872b00f07ba1121f"
export GRAPH_THEORY_KB_PATH="${PLATFORM_PATH}/kb/gt-knowledge-base"

export GRAPH_THEORY_PS_REPO="https://github.com/ostis-apps/gt-knowledge-processing-machine.git"
export GRAPH_THEORY_PS_BRANCH="master"
export GRAPH_THEORY_PS_COMMIT="391402d755c2be0084cf3ef5d1faa5dbaab1b787"
export GRAPH_THEORY_PS_PATH="${PLATFORM_PATH}/kb/gt-knowledge-processing-machine"

export SET_THEORY_REPO="https://github.com/ostis-apps/set-theory.git"
export SET_THEORY_BRANCH="master"
export SET_THEORY_COMMIT="7114369acab0544ed9423a55d3d0df237dd870ac"
export SET_THEORY_PATH="${PLATFORM_PATH}/kb/set-theory"

export REPO_PATH_FILE="${DM_ROOT_PATH}/repo.path"
export CONFIG_PATH="${DM_ROOT_PATH}/ostis-discrete-math.ini"
export DM_SCRIPTS_PATH="${DM_ROOT_PATH}/scripts"
export DM_SUBMODULE_SCRIPTS_PATH="${DM_ROOT_PATH}/scripts/submodule-scripts"

if [ -d "${PLATFORM_PATH}" ];
then
  source "${PLATFORM_PATH}/scripts/set_vars.sh"
fi

if [ -d "${SC_MACHINE_PATH}" ];
then
  source "${SC_MACHINE_PATH}/scripts/set_vars.sh"
fi

if [ -d "${SCP_MACHINE_PATH}" ];
then
  source "${SCP_MACHINE_PATH}/scripts/set_vars.sh"
fi

if [ -d "${SC_COMPONENT_MANAGER_PATH}" ];
then
  source "${SC_COMPONENT_MANAGER_PATH}/scripts/set_vars.sh"
fi

if [ -d "${SC_WEB_PATH}" ];
then
  source "${SC_WEB_PATH}/scripts/set_vars.sh"
fi


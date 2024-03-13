#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

if [ ! -d "${DM_ROOT_PATH}/ims.ostis.kb_copy" ]; then
    mkdir "${DM_ROOT_PATH}/ims.ostis.kb_copy"
else
    rm -rf "${DM_ROOT_PATH}/ims.ostis.kb_copy/*"
fi

cp -a "${DM_ROOT_PATH}/ims.ostis.kb/ims/ostis_tech/semantic_network_represent/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
cp -a "${DM_ROOT_PATH}/ims.ostis.kb/ims/ostis_tech/unificated_models/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
cp -a "${DM_ROOT_PATH}/ims.ostis.kb/ims/ostis_tech/semantic_networks_processing/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
cp -a "${DM_ROOT_PATH}/ims.ostis.kb/ims/ostis_tech/lib_ostis/sectn_lib_of_reusable_comp_ui/ui_menu/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
cp -a "${DM_ROOT_PATH}/ims.ostis.kb/to_check/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
cp -a "${DM_ROOT_PATH}/ims.ostis.kb/ui/" "${DM_ROOT_PATH}/ims.ostis.kb_copy/"
rm -rf "${DM_ROOT_PATH}/ims.ostis.kb_copy/ui/menu"

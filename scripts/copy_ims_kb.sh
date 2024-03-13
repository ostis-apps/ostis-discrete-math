#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."
export LD_LIBRARY_PATH="$ROOT"/sc-machine/bin
if [ ! -d "$ROOT/ims.ostis.kb_copy" ]; then
    mkdir "$ROOT"/ims.ostis.kb_copy
else
    rm -rf "$ROOT"/ims.ostis.kb_copy/*
fi

cd "$ROOT"

cp -a "$ROOT"/ims.ostis.kb/ims/ostis_tech/semantic_network_represent/ "$ROOT"/ims.ostis.kb_copy/
cp -a "$ROOT"/ims.ostis.kb/ims/ostis_tech/unificated_models/ "$ROOT"/ims.ostis.kb_copy/
cp -a "$ROOT"/ims.ostis.kb/ims/ostis_tech/semantic_networks_processing/ "$ROOT"/ims.ostis.kb_copy/
cp -a "$ROOT"/ims.ostis.kb/ims/ostis_tech/lib_ostis/sectn_lib_of_reusable_comp_ui/ui_menu/ "$ROOT"/ims.ostis.kb_copy/
cp -a "$ROOT"/ims.ostis.kb/to_check/ "$ROOT"/ims.ostis.kb_copy/
cp -a "$ROOT"/ims.ostis.kb/ui/ "$ROOT"/ims.ostis.kb_copy/
rm -rf "$ROOT"/ims.ostis.kb_copy/ui/menu

cd "$ROOT"/scripts




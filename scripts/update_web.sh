#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

green="\e[0;32m"
rst="\e[0m"     # Text reset

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "Update web component"

cd "${DM_ROOT_PATH}/sc-web"
npx grunt build
cd "${DM_ROOT_PATH}/gt-ostis-drawings"
npx grunt build
cd "${DM_ROOT_PATH}/set-ostis-drawings"
npx grunt build
#cd "${DM_ROOT_PATH}/web-scn-editor"
#npx grunt build
#npx grunt exec:renewComponentsHtml

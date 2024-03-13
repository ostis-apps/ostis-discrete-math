#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"

red="\e[1;31m"  # Red B
blue="\e[1;34m" # Blue B
green="\e[0;32m"

bwhite="\e[47m" # white background

rst="\e[0m"     # Text reset

st=1

stage()
{
    echo -en "$green[$st] "$blue"$1...$rst\n"
    let "st += 1"
}

clone_project()
{
    if [ ! -d "${DM_ROOT_PATH}/$2" ]; then
        echo -en $green"Clone $1 into $DM_ROOT_PATH/$2$rst\n"
        git clone "$1" --branch "$3" --single-branch "${DM_ROOT_PATH}/$2" --recursive
        if [ -n "$4" ]; then
          ( cd "${DM_ROOT_PATH}/$2"; git checkout "$4" )
        fi
    else
        echo -en "You can update "$green"$2"$rst" manualy$rst\n"
    fi
}

stage "Clone projects"

clone_project https://github.com/ostis-ai/sc-machine.git sc-machine main
clone_project https://github.com/ostis-ai/sc-web.git sc-web main
clone_project https://github.com/ostis-ai/ims.ostis.kb.git ims.ostis.kb main
clone_project https://github.com/ostis-apps/gt-ostis-drawings.git gt-ostis-drawings update-2024
clone_project https://github.com/ostis-apps/set-ostis-drawings set-ostis-drawings master
clone_project https://github.com/ostis-apps/gt-knowledge-processing-machine.git kb/graph_theory/gt-knowledge-processing-machine 0.8.0_fix
clone_project https://github.com/ostis-apps/gt-knowledge-base.git kb/graph_theory/gt-knowledge-base 0.8.0
clone_project https://github.com/ostis-apps/set-theory.git kb/set-theory 0.8.0-kb
#clone_project https://bitbucket.org/iit-ims-team/web-scn-editor web-scn-editor

stage "Prepare projects"

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "sc-machine"

"${DM_ROOT_PATH}/sc-machine/scripts/install_dependencies.sh" --dev
"${DM_ROOT_PATH}/sc-machine/scripts/build_sc_machine.sh"

prepare "sc-web"
"${DM_ROOT_PATH}/sc-web/scripts/install.sh"

( cd "${DM_ROOT_PATH}/gt-ostis-drawings"; npm install; npx grunt build )
( cd "${DM_ROOT_PATH}/set-ostis-drawings"; npm install; npx grunt build )

stage "Build knowledge base"
./build_kb.sh

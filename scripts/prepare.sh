#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."
export REPO_PATH_FILE="$ROOT/repo.path"
export CONFIG_PATH="$ROOT/ostis-discrete-math.ini"

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
    if [ ! -d "$ROOT/$2" ]; then
        echo -en $green"Clone $2$rst\n"
        git clone $1 --branch "$3" --single-branch "$ROOT"/$2
        cd "$ROOT"/$2
        if [ -n "$4" ];
        then
          git checkout "$4"
        fi
        cd "$ROOT"
    else
        echo -en "You can update "$green"$2"$rst" manualy$rst\n"
    fi
}

stage "Clone projects"

clone_project https://github.com/ostis-ai/sc-machine.git sc-machine main 02b6eb20edefca4e1c1b0c468fc0e8e28fc8194e
clone_project https://github.com/ostis-ai/sc-web.git sc-web main
clone_project https://github.com/ostis-ai/ims.ostis.kb.git ims.ostis.kb main
clone_project https://github.com/ostis-apps/gt-ostis-drawings.git gt-ostis-drawings master
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
cd "$ROOT"/sc-machine/scripts
./install_dependencies.sh

./make_all.sh
cd "$ROOT"

prepare "sc-web"
cd "$ROOT"/sc-web/scripts
./install.sh

cd "$ROOT"/sc-web
npm install
grunt build
cd "$ROOT"
echo -en $green"Copy server.conf"$rst"\n"
cp -f "$ROOT"/config/server.conf "$ROOT"/sc-web/server/

cd "$ROOT"/gt-ostis-drawings
npm install
grunt build
cd "$ROOT"/set-ostis-drawings
npm install
grunt build

cd "$ROOT"/scripts

stage "Build knowledge base"

rm -rf "$ROOT"/kb/menu || echo "kb/menu is not found"
rm "$ROOT"/ims.ostis.kb/ui/ui_start_sc_element.scs || echo "ui_start_sc_element.scs is not found"

./build_kb.sh

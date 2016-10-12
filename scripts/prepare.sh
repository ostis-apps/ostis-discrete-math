#!/bin/bash

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
    if [ ! -d "../$2" ]; then
        echo -en $green"Clone $2$rst\n"
        git clone $1 ../$2
        cd ../$2
        git checkout $3
        cd -
    else
        echo -en "You can update "$green"$2"$rst" manualy$rst\n"
    fi
}

stage "Clone projects"

clone_project https://github.com/deniskoronchik/sc-machine.git sc-machine master
clone_project https://github.com/blrB/sc-web-tg.git sc-web master
clone_project https://github.com/ShunkevichDV/ims.ostis.kb.git ims.ostis.kb master
clone_project https://github.com/PtaxaMagic/gt.ostis-Drawings.git gt.ostis-Drawings master
clone_project https://github.com/KovalM/sc-agents_for_TG kb/sc-agents_for_TG master
clone_project https://github.com/KovalM/gt_knowledge_base kb/gt_knowledge_base master
clone_project https://github.com/blrB/tg_book kb/tg_book master

stage "Prepare projects"

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "sc-machine"
cd ../sc-machine/scripts
./install_deps_ubuntu.sh

./clean_all.sh
./make_all.sh
cd -

prepare "gt.ostis-Drawings"
cp -r ../gt.ostis-Drawings/kb/graph_drawings/ ../kb/
rsync --recursive ../gt.ostis-Drawings/sc-web/ ../sc-web/
cat ../gt.ostis-Drawings/files_for_addition/add_to_common.html>>../sc-web/client/templates/common.html
cat ../gt.ostis-Drawings/files_for_addition/add_to_components.html>>../sc-web/client/templates/components.html
rm -rf ../gt.ostis-Drawings

prepare "sc-web"
sudo apt-get install python-dev # required for numpy module
cd ../sc-web/scripts
./install_deps_ubuntu.sh
./prepare_js.sh
python build_components.py -i -a
cd -
echo -en $green"Copy server.conf"$rst"\n"
cp -f ../config/server.conf ../sc-web/server/

stage "Build knowledge base"

rm -rf ../kb/menu
rm ../ims.ostis.kb/ui/ui_start_sc_element.scs

./build_kb.sh

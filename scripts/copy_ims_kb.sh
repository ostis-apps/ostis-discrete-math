#!/bin/bash
export LD_LIBRARY_PATH=../sc-machine/bin
if [ ! -d "../ims.ostis.kb_copy" ]; then
    mkdir ../ims.ostis.kb_copy
else
    rm -rf ../ims.ostis.kb_copy/*
fi

cd ../

cp -a ims.ostis.kb/ims/ostis_tech/semantic_network_represent/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/ostis_tech/unificated_models/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/ostis_tech/semantic_networks_processing/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/ostis_tech/lib_ostis/sectn_lib_of_reusable_comp_ui/ui_menu/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/to_check/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ui/ ims.ostis.kb_copy/
rm -rf ims.ostis.kb_copy/ui/menu

cd -




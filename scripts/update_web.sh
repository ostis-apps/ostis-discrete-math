#!/bin/bash

green="\e[0;32m"
rst="\e[0m"     # Text reset

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "Update web component"

cd ../sc-web/
grunt build
cd ../gt-ostis-drawings
grunt build
cd ../set-ostis-drawings
grunt build
cd ../web-scn-editor/
grunt build
grunt exec:renewComponentsHtml
cd ../scripts

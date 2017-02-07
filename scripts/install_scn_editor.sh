#!/bin/bash
#rst="\e[0m"     # Text reset

# https://github.com/ShunkevichDV/ostis/blob/master/scripts/install_scn.sh
 

cd ../
if [ -d web-scn-editor/ ]; then
echo 'Web-scn-editor already cloned, i will delete it.'
rm -rf web-scn-editor/
fi
git clone https://bitbucket.org/iit-ims-team/web-scn-editor
cd scripts/
cd ../

cd sc-web
echo "var scWebPath = '">../text1.txt
pwd>>../text1.txt
echo "/';">>../text1.txt
cat ../text1.txt | tr -d '\n'> ../out.txt
grep -v "var scWebPath = '" ../web-scn-editor/build_config.js > ../out.js
cat ../out.js > ../web-scn-editor/build_config.js
rm -rf ../out.js
cd ..
pwd
awk '{print} NR==3 {while (getline < "out.txt") print}'  web-scn-editor/build_config.js > out.js
cat out.js > web-scn-editor/build_config.js
rm -rf out.js
rm -rf text1.txt
rm -rf out.txt
cd web-scn-editor/
npm install
pwd
git update-index --assume-unchanged build_config.js
grunt build
grunt exec:renewComponentsHtml
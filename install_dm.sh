#!/bin/bash
set -e
RED='\033[0;91m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m'

docker=$DOCKER
deep=$DM_DEEP
expose=$DM_EXPOSE
while [[ "$#" -gt 0 ]]; do
  case $1 in
    docker) docker=true;;
    deep) deep=true;;
    expose) expose=true;;
    *) echo -e "${RED}Unknown option passed: $1${NC}"; exit 1;;
  esac
  shift
done

dm_install="${DM_INSTALL:-$HOME/.ostis}"
bin_dir=""
exe="$dm_install/bin/dm"

if [[ ! -d "$dm_install/bin" ]]; then
  mkdir -p $dm_install/bin
fi

working_dir=$(pwd -P)
parent_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
cd $parent_path




case $working_dir in
  /|$HOME) source_dir="${DM_SOURCE:-$dm_install/dm}";;
  *) source_dir="${DM_SOURCE:-$working_dir}";;
esac

cat >$dm_install/.dm.config <<EOL
# DM app configuration.
# Change default options by commenting and uncommenting lines below.

DOCKER=$docker
# BUILD=true
# BG=true

DM_SOURCE=$source_dir
EOL

echo "Source dir for DM is set to: $source_dir"
echo "Pass DM_SOURCE env variable before running any dm command to use a different source dir, or use 'dm config' to change the default value."
echo



# Installation ...
cp ./dm $exe
cp ./Dockerfile $dm_install/Dockerfile
cp ./ostis-web-platform.ini $dm_install/ostis-web-platform.ini
cp ./repo.path $dm_install/repo.path
cp ./run $dm_install/run

cmd="$exe upgrade${docker:+ --docker}${deep:+ --deep}${expose:+ --expose}"
command $cmd

echo "DM was installed successfully to $exe"
echo



if command -v dm >/dev/null; then
  echo "Run 'dm --help' to get started"
else
  echo "It looks like DM_INSTALL and PATH variables are missing."
  read -p "Do you want me to add them to your shell config? [Y/n] " answer
  if [[ "${answer:-y}" =~ ^[Yy]$ ]]; then
    read -p "Please specify the path to your shell config (e.g. ~/.zshrc or ~/.bashrc): " config_path
    config_path="${config_path/#\~/$HOME}"
    if [[ ! -f $config_path ]]; then
      read -p "It looks like the specified file does not exist yet. Do you want me to create it? [y/N] " confirmation
      if [[ ! "${confirmation:-n}" =~ ^[Yy]$ ]]; then
        echo
        echo "Manually add the following lines to your shell config (e.g. ~/.zshrc or ~/.bashrc)"
        echo "  export DM_INSTALL=\"$dm_install\""
        echo "  export PATH=\"\$DM_INSTALL/bin:\$PATH\""
        exit 0
      fi
    fi
    echo "" >> $config_path
    echo "export DM_INSTALL=\"$dm_install\"" >> $config_path
    echo "export PATH=\"\$DM_INSTALL/bin:\$PATH\"" >> $config_path
    echo
    echo "Restart your terminal and run 'dm --help' to get started"
  else
    echo
    echo "Manually add the following lines to your shell config (e.g. ~/.zshrc or ~/.bashrc)"
    echo "  export DM_INSTALL=\"$dm_install\""
    echo "  export PATH=\"\$DM_INSTALL/bin:\$PATH\""
  fi
fi

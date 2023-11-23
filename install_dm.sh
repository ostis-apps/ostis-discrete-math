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
# expose=$DM_EXPOSE
while [[ "$#" -gt 0 ]]; do
  case $1 in
    docker) docker=true;;
    deep) deep=true;;
    # expose) expose=true;;
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
# parent_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
# cd $parent_path

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
curl -fsSLo $exe https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/dm
cd $dm_install
curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/Dockerfile
curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/ostis-web-platform.ini
curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/repo.path
curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/run



if command -v dm >/dev/null; then
  echo "DM was installed successfully to $exe"
else
  if [[ -n $rc ]]; then
    echo "" >> $rc
    echo "export DM_INSTALL=\"$dm_install\"" >> $rc
    echo "export PATH=\"\$DM_INSTALL/bin:\$PATH\"" >> $rc
    echo "" >> $rc
    echo
    echo "DM was installed successfully to $exe"
    # For current session
    export DM_INSTALL="$dm_install"
    export PATH="$DM_INSTALL/bin:$PATH"
  else
    echo "It looks like DM_INSTALL and PATH variables are missing."
    echo
    echo "Manually add the following lines to your shell config (e.g. ~/.zshrc or ~/.bashrc)"
    echo "  export DM_INSTALL=\"$dm_install\""
    echo "  export PATH=\"\$DM_INSTALL/bin:\$PATH\""
    echo
    echo "And run 'dm upgrade' to install the platform"
    exit 0
  fi
fi

# cmd="$exe upgrade${docker:+ --docker}${deep:+ --deep}${expose:+ --expose}"
cmd="$exe upgrade${docker:+ --docker}${deep:+ --deep}"
chmod 777 $exe
chmod 777 "$dm_install/run"
command $cmd

echo
if $needs_restart; then
  echo "Restart your terminal and run 'dm' to get started"
else
  echo "Run 'dm' to get started"
fi

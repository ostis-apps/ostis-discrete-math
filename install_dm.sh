#!/bin/bash
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


# Requirements
if [[ -n $docker ]]; then
  docker_exists="$(command -v docker)"
  if [[ ! $docker_exists ]]; then
    echo
    echo -e "${RED}Please install ${BLUE}docker${RED} first${NC}"
    exit 1
  fi
  buildx_exists="$(docker buildx)"
  if [[ ! $buildx_exists ]]; then
    echo
    echo -e "${RED}Please install ${BLUE}docker-buildx${RED} first${NC}"
    exit 1
  fi
fi
set -e


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

# Define web-platform components

platform_repos=(
  "ostis-ai/ostis-web-platform:test_scp_machine:ostis-web-platform"
  "NikitaZotov/sc-machine-1:fix/deadlocks:ostis-web-platform/sc-machine"
  "ostis-ai/scp-machine:main:ostis-web-platform/scp-machine"
  "ostis-ai/sc-web:main:ostis-web-platform/sc-web"
  "qaip/ims.ostis.kb:main:ostis-web-platform/ims.ostis.kb"
)

# Define DM components

dm_repos=(
  "ostis-apps/gt-knowledge-base:0.8.0:knowledge-base"
  "ostis-apps/gt-knowledge-processing-machine:0.8.0_fix:agents"
)
EOL

echo "Source dir for DM is set to: $source_dir"
echo "Pass DM_SOURCE env variable before running any dm command to use a different source dir, or use 'dm config' to change the default value."
echo



# Installation ...
if [[ $DM_ENV == "dev" ]]; then
  echo "Enabled DEV mode"
  echo
  cp ./dm $exe
  cp ./Dockerfile $dm_install/Dockerfile
  cp ./ostis-web-platform.ini $dm_install/ostis-web-platform.ini
  cp ./repo.path $dm_install/repo.path
  cp ./run $dm_install/run
else
  curl -fsSLo $exe https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/dm
  cd $dm_install
  curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/Dockerfile
  curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/ostis-web-platform.ini
  curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/repo.path
  curl -fsSLO https://raw.githubusercontent.com/ostis-apps/ostis-discrete-math/master/run
fi



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

echo "Run 'dm' to get started"

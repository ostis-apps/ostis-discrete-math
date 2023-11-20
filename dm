#!/bin/bash

set -e
RED='\033[0;91m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
BOLD='\033[1m'
NC='\033[0m'

if [[ ! -f /.dockerenv ]]; then
  # working_dir=$(pwd -P) # not used anywhere yet
  cd $DM_INSTALL
  source $DM_INSTALL/.dm.config
  ENV_TITLE="Natively"
else
  ENV_TITLE="Inside Docker Container"
fi

_terminate_prompt() {
  if docker ps -af name=dm | grep dm ; then
    echo
    read -p "Web-platform is already running. ${1:-''} [y/N] " answer
    if [[ "${answer:-n}" =~ ^[Yy]$ ]]; then
      docker rm dm --force > /dev/null
    else
      echo -e "${RED}Canceled${NC}"
      exit 1
    fi
  fi
}

build() {
  docker=$DOCKER
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --docker) docker=true;;
      *) echo "Unknown option passed: $1"; exit 1;;
    esac
    shift
  done

  if [[ -n $docker ]]; then
    if [[ ! -n $DOCKER ]]; then flag=" --docker"; fi
    echo -e "${RED}Building knowledge base in Docker without starting web-platform is not possible."
    echo -e "Please use ${BLUE}dm start --build${flag}${NC}"
  else
    ./ostis-web-platform/scripts/build_kb.sh || (echo; echo -e "${RED}Unable to build knowledge base ${ENV_TITLE}${NC}")
  fi
}

stop() {
  docker=$DOCKER
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --docker) docker=true;;
      *) echo "Unknown option passed: $1"; exit 1;;
    esac
    shift
  done

  if [[ -n $docker ]]; then
    exists=$(echo "$(docker ps -a | grep dm)")
    if [[ -n $exists ]]; then
      docker rm dm --force > /dev/null
      echo -e "${GREEN}Web-platform has been terminated${NC}"
    else
      echo -e "${RED}No running web-platform found${NC}"
    fi
  else
    echo -e "${RED}Terminating web-platform running in background is currently only supported in Docker${NC}"
    exit 1
  fi
}

start() {
  build=$BUILD
  docker=$DOCKER
  bg=$BG
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --build) build=true;;
      --docker) docker=true;;
      --bg) bg=true;;
      --save) save=true;;
      --force) force=true;;
      *) echo "Unknown option passed: $1"; exit 1;;
    esac
    shift
  done

  if [[ -n $docker ]]; then
    echo -e "${GREEN}Starting web-platform in Docker${NC}"
    _terminate_prompt 'Do you want to restart it?'
    cmd="/dm/run${build:+ --build}${save:+ --save}${force:+ --force}"
    if [[ -n $bg ]]; then
      docker run -d --rm -p 8000:8000 -p 8090:8090 -v $DM_SOURCE:/dm/kb --name dm dm $cmd
    else
      docker run -it --rm -p 8000:8000 -p 8090:8090 -v $DM_SOURCE:/dm/kb --name dm dm $cmd
    fi
  else
    if [[ -n $bg ]]; then
      echo -e "Running web-platform in background is currently only supported in Docker."
      exit 1
    else
      if [[ -n $build ]]; then
        ./ostis-web-platform/scripts/build_kb.sh
      fi
      ./ostis-web-platform/scripts/run_sc_server.sh & ./ostis-web-platform/scripts/run_sc_web.sh
    fi
  fi
}

config() {
  "${EDITOR:-nano}" .dm.config
}

_clone_repos() {
  local repos=("$@")

  for repo in "${repos[@]}"; do
    IFS=':' read -ra repo_info <<< "$repo"
    repo_name="${repo_info[0]}"
    branch="${repo_info[1]:-''}"
    directory="${repo_info[2]:-''}"

    if [[ -d $directory ]]; then
      if [[ -n $deep ]]; then
        git -C "$directory" pull --unshallow
      else
        git -C "$directory" pull --depth 1
      fi
    else
      if [[ -n $deep ]]; then
        echo -e "${GREEN}Cloning $repo_name and setting branch to \'$branch\'${NC}"
        git clone --branch "$branch" "https://github.com/$repo_name.git" "$directory"
      else
        echo -e "${GREEN}Shallowly cloning $repo_name with a single branch '$branch'${NC}"
        git clone --depth 1 --single-branch --branch "$branch" "https://github.com/$repo_name.git" "$directory"
      fi
    fi
  done
}

upgrade() {
  docker=$DOCKER
  deep=$DM_DEEP
  # expose=$DM_EXPOSE

  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --docker) docker=true;;
      --deep) deep=true;;
      # --expose) expose=true;;
      *) echo "Unknown option passed: $1"; exit 1;;
    esac
    shift
  done

  repos=(
    "ostis-ai/ostis-web-platform:test_scp_machine:ostis-web-platform"
    "ostis-ai/scp-machine:main:ostis-web-platform/scp-machine"
  )

  _clone_repos "${repos[@]}"

  if [[ ! -n $deep ]]; then
    # Modify scripts for shallow cloning
    find ./ostis-web-platform/scripts -type f -exec sed -i 's/git clone "/git clone --depth 1 --shallow-submodules "/g' {} +
  fi

  if [[ -n $docker ]]; then
    # Fix machine's ws not being exposed:
    sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' ostis-web-platform/ostis-web-platform.ini
    # if [[ -n $expose ]]; then
    ./ostis-web-platform/scripts/install_submodules.sh
    sed -i '/"${PLATFORM_PATH}\/scripts\/install_submodules.sh"/d' ./ostis-web-platform/scripts/install_platform.sh
    # fi
    echo -e "${GREEN}Installing web-platform in Docker${NC}"
    docker buildx build --progress auto --force-rm --tag dm .
  else
    echo -e "${GREEN}Installing web-platform ${ENV_TITLE}${NC}"
    ./ostis-web-platform/scripts/install_platform.sh
  fi
}

cache() {
  if [[ $@ == *"--docker"* || -n $DOCKER ]]; then
    echo -e "${RED}Cache manager is currently only supported in Docker${NC}"
    exit 1
  fi

  save() {
    if [[ ! -f $DM_SOURCE/.bin/.temp ]]; then
      echo -e "${RED}No built kb found.${NC}"
      exit 0
    fi

    hash=$(cat $DM_SOURCE/.bin/.temp)
    if [[ -d $DM_SOURCE/.bin/$hash ]]; then
      echo -e "${GREEN}Already saved.${NC}"
      exit 0
    fi

    mv $DM_SOURCE/.bin/.current $DM_SOURCE/.bin/$hash
    ln -s /dm/kb/.bin/$hash $DM_SOURCE/.bin/.current
    echo -e "${GREEN}Saved to cache.${NC}"
  }

  prune() {
    all=false
    while [[ "$#" -gt 0 ]]; do
      case $1 in
        -a|--all) all=true;;
        *) echo "Unknown option passed: $1"; exit 1;;
      esac
      shift
    done

    if $all; then
      rm -rf $DM_SOURCE/.bin
      exit 0
    fi

    if target=$(readlink $DM_SOURCE/.bin/.current); then
      hash="${target##*/}"
    else
      hash=.current
    fi
    find $DM_SOURCE/.bin/* -maxdepth 1 -type d -not -name $hash | xargs echo
    find $DM_SOURCE/.bin/* -maxdepth 1 -type d -not -name $hash -print0 | xargs -0 rm -rf
  }
  
  help() {
    echo -e "${YELLOW}dm${NC} ${ORANGE}— Discrete Math (ostis app)${NC}"
    echo -e ""
    echo -e "${BOLD}Cache manager:${NC}"
    echo -e "  ${BLUE}save${NC}  ${BLUE} ${NC}     — Save current state of built kb to cache."
    echo -e "  ${BLUE}prune${NC}  ${BLUE} ${NC}    — Remove outdated states of built kb from cache."
  }

  case $1 in
    save) shift; save "$@";;
    prune) shift; prune "$@";;
    *) help;;
  esac
}

pull() {
  repos=(
    "ostis-apps/gt-knowledge-base:0.8.0:$DM_SOURCE/knowledge-base"
    "ostis-apps/gt-knowledge-processing-machine:0.8.0_fix:$DM_SOURCE/agents"
  )
  _clone_repos "${repos[@]}"
}

help() {
  echo -e "${YELLOW}dm${NC} ${ORANGE}— Discrete Math (ostis app)${NC}"
  echo -e ""
  echo -e "  ${BLUE}build${NC}, ${BLUE}b${NC}     — Build knowledge base files."
  echo -e "  ${BLUE}start${NC}, ${BLUE}s${NC}     — Start web-platform (http://localhost:8000)."
  echo -e "  ${BLUE}stop${NC}  ${BLUE} ${NC}      — Terminate web-platform running in background or another process."
  echo -e "  ${BLUE}config${NC}  ${BLUE} ${NC}    — Change app configuration."
  echo -e "  ${BLUE}upgrade${NC}  ${BLUE} ${NC}   — Upgrade web-platform. Pick up all updates from sc-machine, scp-machine, sc-web."
  echo -e "  ${BLUE}pull${NC}  ${BLUE} ${NC}      — Pull all changes from DM components: kb, agents, set theory."
  echo -e "  ${BLUE}cache${NC}  ${BLUE} ${NC}     — Run cache manager."
  echo -e ""
  echo -e "${BOLD}Shortcuts:${NC}"
  echo -e "  ${BLUE}sb${NC}    ${BLUE} ${NC}      — dm start --build"
  echo -e "  ${BLUE}sa${NC}    ${BLUE} ${NC}      — dm start --build --save"
}

case $1 in
  b|build) shift; build "$@";;
  s|start) shift; start "$@";;
  stop) shift; stop "$@";;
  config) shift; config "$@";;
  upgrade) shift; upgrade "$@";;
  pull) shift; pull "$@";;
  cache) shift; cache "$@";;
  
  sb) shift; start --build "$@";;
  sa) shift; start --build --save "$@";;
  *) help;;
esac

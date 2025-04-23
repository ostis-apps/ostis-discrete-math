#!/usr/bin/env bash
set -eo pipefail

if [ -z "${SCP_MACHINE_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/../set_vars.sh"
fi

cd "${SCP_MACHINE_PATH}"
conan install . -s build_type=Debug --build=missing
cmake --preset debug-conan
cmake --build --preset debug


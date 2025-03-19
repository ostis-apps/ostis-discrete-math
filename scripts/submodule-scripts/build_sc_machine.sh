#!/usr/bin/env bash
set -eo pipefail

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/../set_vars.sh"
fi

cd "${SC_MACHINE_PATH}"
cmake --preset release-conan
cmake --build --preset release
conan install . --build=missing
conan export-pkg .


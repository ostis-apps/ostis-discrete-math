#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."

export LD_LIBRARY_PATH="$ROOT"/sc-machine/bin
"$ROOT"/sc-machine/bin/sctp-server "$ROOT"/config/sc-web.ini
cd "$ROOT"/scripts || exit 1

#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."


"$ROOT"/scripts/build_kb.sh
"$ROOT"/sc-machine/bin/sctp-server "$ROOT"/config/sc-web.ini

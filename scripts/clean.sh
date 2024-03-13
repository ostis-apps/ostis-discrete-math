#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."

rm -rf "$ROOT"/sc-machine
rm -rf "$ROOT"/sc-web
rm -rf "$ROOT"/kb.bin
rm -rf "$ROOT"/geometry.drawings

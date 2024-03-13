#!/bin/bash

set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."

cd "$ROOT"/sc-web/server/
python2 app.py
cd -

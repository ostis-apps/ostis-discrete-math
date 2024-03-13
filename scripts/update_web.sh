#!/bin/bash
set -eo pipefail
ROOT="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/.."

green="\e[0;32m"
rst="\e[0m"     # Text reset

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "Update web component"

cd "$ROOT"/sc-web/
grunt build
cd "$ROOT"/gt-ostis-drawings
grunt build
cd "$ROOT"/set-ostis-drawings
grunt build
cd "$ROOT"/web-scn-editor/
grunt build
grunt exec:renewComponentsHtml
cd "$ROOT"/scripts

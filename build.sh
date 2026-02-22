#!/bin/bash
set -euo pipefail

cd "${0%/*}" || exit
rm -rf public
rm -rf resources
hugo --minify --gc
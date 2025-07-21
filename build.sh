#!/bin/bash
cd "${0%/*}" || exit
rm -rf public
rm -rf resources
hugo --minify --gc
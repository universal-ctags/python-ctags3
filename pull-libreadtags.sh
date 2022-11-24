#!/bin/sh
#
# This script is for pulling the latest libreadtags code
#
cd $(git rev-parse --show-toplevel)
git subtree pull --prefix src/libreadtags https://github.com/universal-ctags/libreadtags.git master --squash

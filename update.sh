#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd $SCRIPT_PATH



git add *
git commit -m "$(date)"
git push --all

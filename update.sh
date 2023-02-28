#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd "$SCRIPT_PATH" || exit

for file in ./* ; do
    [ ! -d "$file" ] && continue
    [ ! "$(find "$file" -regex "^.*\.tex$")" ] && continue

    cd "$file" || continue

    # if the file contains not tex file changed go to the next one
    [ ! "$(git ls-files -m | grep -E "^.*\.tex$")" ] && cd .. && continue

    pwd
    echo "Converting $(fing . -regex "^.*\.tex$") ..."
    pdflatex "$(find . -regex "^.*\.tex$")"
    cd ..
done


echo "Adding to git..."
git add ./*
echo "Performing commit..."
git commit -m "$(date)"
git push --all

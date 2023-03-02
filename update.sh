#! /bin/sh

contains() {
    for first in $1; do
        for second in $2; do
            [ "$first" = "$second" ] && return 0
        done
    done
    return 1
}

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd "$SCRIPT_PATH" || exit


for file in ./* ; do
    [ ! -d "$file" ] && continue

    tex_files="$(find "$file" -regex "^.*\.tex$")"
    [ ! "$tex_files" ] && continue

    cd "$file" || continue

    for git_file in $(git ls-files -m); do
        (echo "$git_file" | grep -Eq "^.*\.tex$") && continue
        
        pwd
        echo "Converting $git_file ..."
        pdflatex "$git_file"
    done

    cd ..
done


echo "Adding to git..."
git add ./*
echo "Performing commit..."
git commit -m "$(date)"
git push --all

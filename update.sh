#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd "$SCRIPT_PATH" || exit


for file in ./* ; do
    [ ! -d "$file" ] && continue

    cd "$file" || continue

    for git_file in $(git ls-files -m); do
        (echo "$git_file" | grep -Eq "^.*\.tex$") || continue
        
        pwd
        echo "Converting $git_file ..."
        latexmk -pdf "$git_file"
    done

    cd ..
done


echo "Adding to git..."
git add ./*
echo "Performing commit..."
git commit -m "$(date)"
git push --all


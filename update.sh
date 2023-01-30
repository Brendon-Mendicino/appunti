#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd "$SCRIPT_PATH" || exit

for file in ./* ; do
    ! [ -d "$file" ] && continue
    ! [ $(ls "$file" | grep -E "^.*\.tex$") ] && continue

    cd "$file" || continue

    # if the file contains not tex file changed go to the next one
    ! [ $(git ls-files -m | grep -E "^.*\.tex$") ] && cd .. && continue

    echo $(pwd)
    echo "Converting $(ls | grep -E "^.*\.tex$") ..."
    pdflatex "$(ls | grep -E "^.*\.tex$")" &
    cd ..
done

wait

echo "Adding to git..."
git add *
echo "Performing commit..."
git commit -m "$(date)"
git push --all

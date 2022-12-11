#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd $SCRIPT_PATH

for file in $(ls -C); do
    ! [ -d "$file" ] && continue
    ! [ $(ls $file | grep -E "^.*\.tex$") ] && continue

    cd $file

    # if the file contains not tex file changed go to the next one
    ! [ $(git ls-files -m | grep -E "^.*\.tex$") ] && cd .. && continue

    echo $(pwd)
    echo "Converting $(ls | grep -E "^.*\.tex$") ..."
    pdflatex "$(ls | grep -E "^.*\.tex$")"
    cd ..
done


echo "Adding to git..."
git add *
echo "Performing commit..."
git commit -m "$(date)"
git push --all

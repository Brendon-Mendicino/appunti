#! /bin/sh

SCRIPT_PATH="$( dirname -- "$( readlink -f -- "$0"; )"; )"

cd $SCRIPT_PATH

for file in $(ls -C); do
    ! [ -d "$file" ] && continue
    ! [ $(ls $file | grep -E "^.*\.tex$") ] && continue

    # Removed in the force update version.
    ## if the file has not been changed then go to the next one
    ##! [ $(git ls-files -m | grep "$file") ] && continue

    cd $file
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

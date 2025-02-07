#!/bin/sh
for file in `find . -name "*.idx.*" -type f`
do
    [ -e "$file" ] || continue
    echo $file
    filename=${file%.idx*}
    extension="${file#*.idx}"
    mv "$file" "${filename}${extension}"
done
if [ "$#" -eq  "0" ]
then
    echo "No arguments supplied"
else
    if [ "$1" == "flutter" ]
    then
        rm -rf ./ios ./windows
    fi
fi

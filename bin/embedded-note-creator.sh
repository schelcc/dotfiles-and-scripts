#!/bin/bash

while getopts ":a:v:" option; do
    case $option in
        a)
            ATTACHMENT_PATH="$OPTARG"
            ;;
        v)
            VAULT_PATH="$OPTARG"
            ;;
        *)
            echo "Usage: $0 [-a attachment_path] [-v vault_path]"
            exit 1
            ;;
    esac
done

OIFS="$IFS"
IFS=$'\n'
for f in `find $ATTACHMENT_PATH -type f -name "*.pdf" -print`
do
    vault_rel_path=$(echo "${f#$VAULT_PATH}")
    fname=$(echo $f | sed 's/.pdf//' | sed 's/\.\///')
    fname=$(basename $fname)
    cur_note=$VAULT_PATH''reMarkable/$fname.md
    echo ""
    echo $f
    echo $fname
    echo $vault_rel_path
    echo $cur_note
    echo ""
    if [ ! -f $cur_note ]; then

        template='status:: 📔\ntag-tags::\nlink-tags::\n___\n\n![['"${vault_rel_path}"']]\n\n___\nReferences:\n'
        echo -e $template >> $cur_note
    fi
done
IFS="$OIFS"

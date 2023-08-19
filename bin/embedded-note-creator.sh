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
    vault_rel_path=$(echo $f | sed 's/.pdf//' | sed 's/\.\///')
    cur_note=$VAULT_PATH/$vault_rel_path.md
    if [ ! -f $cur_note ]; then
        note_dir=$(dirname $cur_note)
        if [ ! -d $note_dir ]; then
            mkdir -p $note_dir
        fi

        template='status:: #📔\ntag-tags::\nlink-tags::\n___\n\n![[Attachments/reMarkable/'"${vault_rel_path}"'.pdf]]\n\n___\nReferences:\n'
        echo -e $template >> $cur_note
    fi
done
IFS="$OIFS"
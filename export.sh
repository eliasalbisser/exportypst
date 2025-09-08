#!/bin/bash

# Compile the contents of a folder into a pdf and save into export/ folder.

if [ -z $1 ]; then
    echo "Please supply name of the directory for which you want to export your documents"
    exit 1
fi

CURRENT_PATH=$(pwd)
DIRECTORY_NAME=$1
FULL_MODULE_PATH=$CURRENT_PATH/$DIRECTORY_NAME

if [ ! -d $FULL_MODULE_PATH ]; then
    echo "Directory $FULL_MODULE_PATH does not exist"
    exit 1
fi

# create export directory
EXPORT_PATH="$CURRENT_PATH/export"
mkdir -p $EXPORT_PATH

# clear text from ".export.typ" file
echo >"$FULL_MODULE_PATH/.export.typ"

for f in $FULL_MODULE_PATH/*.typ; do
    basename=${f##*/}
    # insert pagebreak before each lecture note
    echo "#pagebreak()" >>"$FULL_MODULE_PATH/.export.typ"
    # append each typst module as an include into the export file
    echo "#include \"/$DIRECTORY_NAME/$basename\"" >>"$FULL_MODULE_PATH/.export.typ"
done

typst compile \
    --root=$CURRENT_PATH \
    --input="directory_name=$DIRECTORY_NAME" \
    main.typ "${EXPORT_PATH}/${DIRECTORY_NAME}.pdf"

status=$?

if [[ $status -ne 0 ]]; then
    echo "Could not export folder \"$1\""
    exit $status
else
    echo "Successfully exported folder \"$1\""
fi

#!/bin/bash

# Compile the contents of a folder into a pdf and save into export/ folder.

if [ -z $1 ]; then
    echo "Please supply name of the directory for which you want to export your documents"
    exit 1
fi

# absolute path
PROJECT_ROOT=$(dirname $(realpath "$0"))
MODULE_DIR=$1
FULL_MODULE_PATH=$PROJECT_ROOT/$MODULE_DIR

if [ ! -d $FULL_MODULE_PATH ]; then
    echo "Directory $FULL_MODULE_PATH does not exist"
    exit 1
fi

# TODO: export files directly into MODULE_DIR and update "upload.sh" script
# create export directory
EXPORT_PATH="$PROJECT_ROOT/export"
mkdir -p $EXPORT_PATH

NOTES_SUBDIR="notes"

# clear text from ".export.typ" file
echo >"$FULL_MODULE_PATH/.export.typ"

# find all files with extension ".typ" but must not start with a dot
for f in $(find "$FULL_MODULE_PATH/$NOTES_SUBDIR" -type f -name "[^.]*.typ" | sort); do
    # basename
    typ_filename=${f##*/}
    # insert pagebreak before each lecture note
    echo "#pagebreak()" >>"$FULL_MODULE_PATH/.export.typ"
    # append each typst module as an include into the export file
    echo "#include \"/$MODULE_DIR/$NOTES_SUBDIR/$typ_filename\"" >>"$FULL_MODULE_PATH/.export.typ"
done

typst compile \
    --root=$PROJECT_ROOT \
    --input="directory_name=$MODULE_DIR" \
    main.typ "${EXPORT_PATH}/${MODULE_DIR}.pdf"

status=$?

if [[ $status -ne 0 ]]; then
    echo "Could not export folder \"$1\""
    exit $status
else
    echo "Successfully exported folder \"$1\""
fi

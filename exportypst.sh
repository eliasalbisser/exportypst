#!/bin/bash

# CONNECT TO A VPN OR SIMILAR THINGS HERE
fn_connection_prelude() {
    echo "Opening connections..."
    echo
}

# CLOSE CONNECTIONS AFTERWARDS
fn_connection_postlude() {
    echo "Closing connections..."
    echo
}

# TODO: display usage here
# fn_display_usage() {; }

# export only the pdf from notes inside the directory basename "$1"
fn_export_pdf() {
    # TODO: decide if validation should happend outside of function or in different function
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
}

fn_export_pdf_all() {
    ABS_PATH=$(dirname $(realpath "$0"))

    DIRECTORIES=()

    for d in $(ls "$ABS_PATH"); do
        if [[ -d $d ]]; then
            DIRECTORIES=("${DIRECTORIES[@]}" "$d")
        fi
    done

    # TODO: make a global var containing those folders, and perhaps put .rsync_exclude contents into a var as well?
    # remove certain folders from DIRECTORIES array
    exclude_dirs=(".git" "export") # ADD EXCLUDED DIRECTORIES HERE
    for exclude in ${exclude_dirs[@]}; do
        DIRECTORIES=("${DIRECTORIES[@]/$exclude/}") #Quotes when working with strings
    done

    for module_dir in ${DIRECTORIES[@]}; do
        echo "Exporting \"$module_dir\"..."
        fn_export_pdf $module_dir
    done
}

# push only pdfs to remote
fn_push_exports() {
    fn_connection_prelude
    RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz ./export/*.pdf rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_EXPORT"
    fn_connection_postlude
}

# pull all relevant files from remote
fn_pull_remote_files() {
    fn_connection_prelude
    RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_NOTES"/ --update ./
    fn_connection_postlude
}

# push all relevant files to remote
fn_push_remote_files() {
    fn_connection_prelude
    RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz ./ \
        --exclude=".git" \
        --include="*/ */* */*.typ *.typ *.sh" \
        --exclude="*" \
        rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_NOTES"/
    fn_connection_postlude
}

# source environment variables
source ./.env

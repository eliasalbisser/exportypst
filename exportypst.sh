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

fn_display_usage() {
    echo "Usage: $(basename "$0") [-h | --help] [ARGUMENT]... "
    echo ""
    echo "-h, --help        Display this help"
    echo ""
    echo "export example    export pdf for the folder 'example'"
    echo "export_all        export pdfs for all folders in project root"
    echo ""
    echo "push exports      upload exported pdf to the remote"
    echo ""
    echo "push files        upload relevant files to the remote"
    echo "pull files        download relevant files from the remote"
    echo ""
}

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

    # create export directory
    EXPORT_PATH="$PROJECT_ROOT/export"
    mkdir -p $EXPORT_PATH

    NOTES_SUBDIR="notes"

    # TODO: check first if info.toml exists. If not, throw error and exit

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

    # TODO: make a global var containing those folders
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
    RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_NOTES"/ ./ --update
    fn_connection_postlude
}

# push all relevant files to remote
fn_push_remote_files() {
    fn_connection_prelude
    RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz ./ \
        --exclude=".git" \
        --include="*/ */* */*.typ *.typ *.sh" \
        --exclude="*" \
        rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_NOTES"/ \
        --delete
    fn_connection_postlude
}

# source environment variables
source ./.env

if [[ $# -eq 0 ]]; then
    fn_display_usage
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        fn_display_usage
        exit 0
        ;;
    export)
        fn_export_pdf $2
        exit 0
        ;;
    export_all)
        fn_export_pdf_all
        exit 0
        ;;
    pull)
        fn_pull_remote_files
        exit 0
        ;;
    push)
        case $2 in
        exports)
            fn_push_exports
            exit 0
            ;;
        files)
            fn_push_remote_files
            exit 0
            ;;
        esac
        ;;
    *)
        fn_display_usage
        exit 0
        ;;
    esac
done

#!/bin/bash

# This script exports all folders

ABS_PATH=$(dirname $(realpath "$0"))

DIRECTORIES=()

for d in $(ls "$ABS_PATH"); do
    if [[ -d $d ]]; then
        DIRECTORIES=("${DIRECTORIES[@]}" "$d")
    fi
done

# remove certain folders from DIRECTORIES array
exclude_dirs=(".git" "export") # ADD EXCLUDED DIRECTORIES HERE
for exclude in ${exclude_dirs[@]}; do
    DIRECTORIES=("${DIRECTORIES[@]/$exclude/}") #Quotes when working with strings
done

for module_dir in ${DIRECTORIES[@]}; do
    echo "Exporting \"$module_dir\"..."
    bash ./export.sh $module_dir
done

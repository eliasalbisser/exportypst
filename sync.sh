#!/bin/bash

# Upload the whole repository onto a remote
# (customize this script to your needs!, you could replace rsync with rclone to upload it into e.g. dropbox)

# connect to a vpn or similar things here
prelude() {
    echo "Opening connections..."
    echo
}

# close connections etc.
postlude() {
    echo "Closing connections..."
    echo
}

source ./.env

prelude

RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avzu . --exclude-from=".rsync_exclude" rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_NOTES"

postlude

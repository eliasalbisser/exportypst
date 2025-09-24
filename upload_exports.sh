#!/bin/bash

# Upload the exported files onto some kind of server via rsync
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

RSYNC_PASSWORD=$RSYNC_PASSWORD rsync -avz ./export/*.pdf rsync://"$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DESTINATION_EXPORT"

postlude

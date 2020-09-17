#!/bin/sh

#H#
#H# virtualizor.sh — Manages different tasks around the container.
#H#
#H# Examples:
#H#   sh virtualizor.sh start
#H#   sh virtualizor.sh reinstall
#H#
#H# Options:
#H#   start     Starts the container / installs it on the first run
#H#   stop      Stops the container
#H#   reinstall Deletes all panel data and installs a fresh panel
#H#   rebuild   Rebuilds the image
#H#   backup <backup_directory>     Takes a backup of the whole container
#H#   run <command>     Runs a command inside the panel's container
#H#   help              Shows this message.

help() {
    sed -rn 's/^#H# ?//;T;p' "$0"
}

help
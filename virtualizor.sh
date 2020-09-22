#!/bin/sh

#H#
#H# virtualizor.sh — A tool to easily control your virtualizor instance.
#H#
#H# Examples:
#H#   sh virtualizor.sh start
#H#   sh virtualizor.sh reinstall
#H#
#H# Options:
#H#   start     Starts the container
#H#   stop      Stops the container
#H#   install   Creates a container and runs the installation script
#H#   reinstall Deletes all panel data and installs a fresh panel
#H#   uninstall Completely removes all traces of virtualizor
#H#   build     Rebuilds the image
#H#   shell     Starts a shell inside the panel's container
#H#   help      Shows this message

help() {
    sed -rn 's/^#H# ?//;T;p' "$0"
}

[ "$1" = "help" ] && help && exit 0


# taken from: https://unix.stackexchange.com/questions/222974/ask-for-a-password-in-posix-compliant-shell
read_password() {
  REPLY="$(
    exec < /dev/tty || exit # || exit only needed for bash
    tty_settings=$(stty -g) || exit
    trap 'stty "$tty_settings"' EXIT INT TERM
    stty -echo || exit
    printf "Password: " > /dev/tty
    IFS= read -r password; ret=$?
    echo > /dev/tty
    printf '%s\n' "$password"
    exit "$ret"
  )"
}

project_root=$(dirname "$(realpath "$0")")
# shellcheck source=/dev/null
. "$project_root/config.sh"

if ! [ -x "$(command -v "docker")" ]; then
    echo "ERROR: Docker is not installed." >&2
    exit 1
fi

docker info > /dev/null 2>&1

if [ "$?" -eq 1 ]; then
    echo "ERROR: You need to run docker with escalated privileges." >&2
    exit 1
fi


if [ "$1" = "build" ]; then

    docker build -t virtualizor "$project_root"

elif [ "$1" = "install" ]; then

    mkdir -p "$PANEL_DIR"
    if [ ! -d "$PANEL_DIR" ]; then
        echo "ERROR: The directory was not created: $PANEL_DIR"
        exit 1
    fi

    echo "Create a root password for the panel."
    read_password

    docker create \
        --name virtualizor \
        -p "$USER_HTTP_PORT":4082 \
        -p "$USER_HTTPS_PORT":4083 \
        -p "$ADMIN_HTTP_PORT":4084 \
        -p "$ADMIN_HTTPS_PORT":4085 \
        -e "$PUID"=1000 \
        -e "$PGID"=1000 \
        -e PASSWORD="$REPLY" \
        -e EMAIL="$EMAIL" \
        -v /etc/localtime:/etc/localtime:ro \
        -v "$PANEL_DIR/data":/usr/local/emps \
        -v "$PANEL_DIR/init":/etc/init.d \
        virtualizor

    [ "$?" -eq 1 ] && exit 1;
    docker start -a virtualizor

elif [ "$1" = "reinstall" ]; then

    while true; do
        printf "This will delete all data of the current installation! Do you want to proceed? (yes/no):"
        read -r yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo "Stopping container..."
    docker stop virtualizor
    echo "Deleting container..."
    docker rm virtualizor
    echo "Deleting contents of $PANEL_DIR ..."
    rm -rf "$PANEL_DIR"
    echo "Installing Virtualizor:"
    sh "$0" install

elif [ "$1" = "uninstall" ]; then

    while true; do
        printf "This will delete all data of the current installation! Do you want to proceed? (yes/no):"
        read -r yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    echo "Stopping container..."
    docker stop virtualizor
    echo "Deleting container..."
    docker rm virtualizor
    echo "Deleting contents of $PANEL_DIR ..."
    rm -rf "$PANEL_DIR"
    echo "Deleting image..."
    docker rmi virtualizor

elif [ "$1" = "start" ]; then

    docker start virtualizor
    [ "$?" -eq 1 ] && exit 1;
    echo "Container has been started."
    echo "Check its output via: docker logs virtualizor"

elif [ "$1" = "stop" ]; then

    docker stop virtualizor
    [ "$?" -eq 1 ] && exit 1;
    echo "Container has been stopped."

elif [ "$1" = "shell" ]; then

    docker exec -it virtualizor bash

fi
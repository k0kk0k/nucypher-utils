#!/bin/bash

BACKUP_NAME="nucypher"
# folder where nucypher-venv stored
NU_VENV_FOLDER=~/nucypher-venv
# folder where keys stored
NU_MAIN_FOLDER=~/.local/share/nucypher/
ETH_FOLDER=~/.ethereum
CURRENT_DATE=$(TZ=UTC-3 date +"%d-%m-%Y_%H-%M-%S")
green="\e[92m"
red="\e[91m"
normal="\e[39m"

check_path() {
    if [ -d "$1" ]; then
        echo -e $green"Backup folder exists $1"

    else
        echo -e $red "ERROR: $1 does not exists --> exit"
        exit 1
    fi
}

echo "Сhecking backup directories..."
for folder in $NU_VENV_FOLDER $ETH_FOLDER $NU_MAIN_FOLDER; do
    check_path $folder
done

echo -e $normal"Parse external node IP"
NODE_IP=$(curl -s api.ipify.org)

echo -e $normal"Getting current Nucypher version"
NU_VERSION=$(source $NU_VENV_FOLDER/bin/activate && nucypher --version | grep version | sed -r 's/^version //')
echo -e $green "NODE_IP: $NODE_IP\n Nucypher version: $NU_VERSION"

echo -e $normal"Creating tar.gz archive"
tar --exclude='*.tar.gz' --exclude='lightchaindata/*' --exclude='chaindata/*' -zcf ~/$BACKUP_NAME\_$NU_VERSION\_$NODE_IP\_$CURRENT_DATE.tar.gz \
-C ~ .local -C ~ .ethereum

echo -e $normal"$CURRENT_DATE Backup completed."

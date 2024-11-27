#!/bin/bash

# Define directories
STEAMCMD_DIR="/steamcmd"
DAYZ_SERVER_DIR="/dayzserver"

# Check if required environment variables are set


if [[ "$UPDATE_SERVER" == "true" ]]; then
    if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
      echo "Error: You must supply the SteamCMD login credentials."
      echo "Set the USERNAME and PASSWORD environment variables."
      exit 1
    fi
    echo "Updating DayZ server..."
    $STEAMCMD_DIR/steamcmd.sh +force_install_dir $DAYZ_SERVER_DIR +login $USERNAME $PASSWORD $CODE +app_update 223350 +workshop_download_item 221100 1559212036 +workshop_download_item 221100 1564026768 +workshop_download_item 221100 2418079817 +quit
    ln -s $DAYZ_SERVER_DIR/steamapps/workshop/content/221100/1559212036 $DAYZ_SERVER_DIR/1559212036
    ln -s $DAYZ_SERVER_DIR/steamapps/workshop/content/221100/1564026768 $DAYZ_SERVER_DIR/1564026768
    ln -s $DAYZ_SERVER_DIR/steamapps/workshop/content/221100/2418079817 $DAYZ_SERVER_DIR/2418079817
    ln -s $DAYZ_SERVER_DIR/steamapps/workshop/content/221100/1559212036/keys/* $DAYZ_SERVER_DIR/keys/
    ln -s $DAYZ_SERVER_DIR/steamapps/workshop/content/221100/2418079817/keys/* $DAYZ_SERVER_DIR/keys/
fi
echo "Starting DayZ server..."
cd $DAYZ_SERVER_DIR
exec ./DayZServer -config=serverDZ.cfg -port=2302 "-mod=1559212036;1564026768;2418079817;" -BEpath=battleye -profiles=profiles -dologs -adminlog -netlog

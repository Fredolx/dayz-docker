#!/bin/bash

# Define directories
STEAMCMD_DIR="/steamcmd"
DAYZ_SERVER_DIR="/dayzserver"
CONFIG_DIR="/data/config"
PROFILES_DIR="/data/profiles"
STORAGE_DIR="/data/storage"
EXAMPLES_DIR="/examples"

if [ ! -d "$CONFIG_DIR" ] || [ ! -d "$PROFILES_DIR" ] || [ ! -d "$STORAGE_DIR" ]; then
  echo "Creating data folders";
  mkdir -p "$CONFIG_DIR" "$PROFILES_DIR" "$STORAGE_DIR"
fi

if [ ! -f "$CONFIG_DIR/launch.env" ]; then
  cp "$EXAMPLES_DIR/launch.env" "$CONFIG_DIR/"
fi

if [ ! -f "$CONFIG_DIR/serverDZ.cfg" ]; then
  cp "$EXAMPLES_DIR/serverDZ.cfg" "$CONFIG_DIR/"
fi

source $CONFIG_DIR/launch.env

if [[ "$UPDATE_SERVER" == "true" ]]; then
  if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "Error: You must supply the SteamCMD login credentials."
    echo "Set the USERNAME and PASSWORD environment variables."
    exit 1
  fi
  echo "Updating DayZ server..."
  DAYZ_MODS_TRIMMED="${DAYZ_MODS%;}" # Removes the trailing semicolon
  IFS=';' read -ra MOD_IDS <<<"$DAYZ_MODS_TRIMMED"
  WORKSHOP_ITEMS=""
  for MOD_ID in "${MOD_IDS[@]}"; do
    WORKSHOP_ITEMS+=" +workshop_download_item $MOD_ID"
  done

  if ! $STEAMCMD_DIR/steamcmd.sh +force_install_dir $DAYZ_SERVER_DIR +login "$USERNAME" "$PASSWORD" "$STEAM_GUARD_CODE" +app_update 223350"$WORKSHOP_ITEMS" +quit; then
    echo "SteamCMD update failed. Exiting."
    exit 1
  fi

  MODS_FOLDER="$DAYZ_SERVER_DIR/steamapps/workshop/content/221100"
  KEYS_TARGET_DIR="$DAYZ_SERVER_DIR/keys"
  if [ ! -d "$KEYS_TARGET_DIR" ]; then
    mkdir -p "$KEYS_TARGET_DIR"
    echo "Created keys target directory: $KEYS_TARGET_DIR"
  fi
  for folder in "$MODS_FOLDER"/*; do
    if [ -d "$folder" ]; then
      folder_name=$(basename "$folder")
      ln -s "$folder" "$DAYZ_SERVER_DIR/$folder_name"
      echo "Created symlink: $DAYZ_SERVER_DIR/$folder_name -> $folder"
      keys_dir="$folder/keys"
      if [ -d "$keys_dir" ]; then
        for key_file in "$keys_dir"/*; do
          if [ -f "$key_file" ]; then
            ln -s "$key_file" "$KEYS_TARGET_DIR/"
            echo "Created symlink: $KEYS_TARGET_DIR/$(basename "$key_file") -> $key_file"
          fi
        done
      fi
    fi
  done
fi
echo "Starting DayZ server..."
if [ ! -f "$DAYZ_SERVER_DIR/DayZServer" ]; then
    echo "Couldn't launch the Dayz Server. Please update your launch.env in config. If this is your first run, you need to set your steam credentials and update_server to true in launch.env to fetch the dedicated server files."
    exit 1
fi
cd $DAYZ_SERVER_DIR
if ! exec ./DayZServer -config=$CONFIG_DIR/serverDZ.cfg -port="$SERVER_PORT" ${DAYZ_MODS:+"-mod=$DAYZ_MODS"} -BEpath=battleye -profiles="$PROFILES_DIR" -storage="$STORAGE_DIR" -dologs -adminlog -netlog "$CUSTOM_FLAGS"; then
  echo "Couldn't launch the Dayz Server. Please update your launch.env in config. If this is your first run, you need to set your steam credentials and update_server to true in launch.env to fetch the dedicated server files."
  exit 1
fi

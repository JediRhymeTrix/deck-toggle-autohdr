#!/bin/bash

# Determine the script's directory
script_dir=$(dirname "$BASH_SOURCE")/AUTOHDR/autohdr_32bit

# Initialize appid variable
appid=""

# Loop through all arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -i) # If -i is found, the next argument is its value
    appid="$2"
    shift # Move past the argument's value
    ;;
  *) # For any other argument, just skip
    ;;
  esac
  shift # Move to the next key or value
done

# Check if appid is empty
if [[ -z $appid ]]; then
  echo "Error: -i option is required with an application ID as its argument." >&2
  exit 1
fi

# Define search paths
search_paths=("/home/deck/.steam/steam/steamapps" "/run/media/mmcblk0p1/steamapps")

# Initialize output by printing directly to stdout
echo "Script run started at $(date)"

# Since we're ignoring other args, no need to shift and print them
# Just focusing on the appid usage

# Find the appmanifest file and print output directly
for path in "${search_paths[@]}"; do
  manifest_file=$(find "$path" -name "appmanifest_${appid}.acf" 2>&1)
  if [[ -n $manifest_file ]]; then
    found_path=$path
    break
  fi
done

if [[ -z $manifest_file ]]; then
  echo "appmanifest_${appid}.acf not found."
  exit 1
fi

# Extract installdir and print output directly
installdir=$(grep '"installdir"' "$manifest_file" | cut -d'"' -f4)

if [[ -z $installdir ]]; then
  echo "installdir not found in manifest."
  exit 1
fi

# Construct the game directory path
game_dir="${found_path}/common/$installdir"

# Check for toggle_autohdr.sh, run or copy and run, printing output directly
if [[ -f "${game_dir}/toggle_autohdr.sh" ]]; then
  echo "Running existing toggle_autohdr.sh..."
  bash "${game_dir}/toggle_autohdr.sh" 2>&1
else
  echo "Copying toggle_autohdr.sh to ${game_dir}..."
  cp "${script_dir}/toggle_autohdr.sh ${game_dir}/" 2>&1
  echo "Running toggle_autohdr.sh..."
  bash "${game_dir}/toggle_autohdr.sh ${script_dir}/autohdr" 2>&1
fi

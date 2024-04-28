#!/bin/bash

# Default SOURCE_DIR if not provided as an argument
DEFAULT_SOURCE_DIR="/home/deck/Downloads/deck-toggle-autohdr/AUTOHDR/autohdr_64bit/autohdr"
SOURCE_DIR="${1:-$DEFAULT_SOURCE_DIR}"

SCRIPT_DIR=$(dirname "$0")
TARGET_DIR="$SCRIPT_DIR" # Use script location as the target
FLAG_FILE="$TARGET_DIR/.symlinks_created_flag"
LOG_FILE="$TARGET_DIR/.created_symlinks.log"

# Function to create symlinks recursively
create_symlinks() {
    # Create symlinks for files
    find "$SOURCE_DIR" -type f | while read -r src; do
        rel_path="${src#$SOURCE_DIR/}" # Get the relative path
        target="$TARGET_DIR/$rel_path"
        mkdir -p "$(dirname "$target")" # Ensure the target directory exists
        ln -s "$src" "$target" && echo "$target" >>"$LOG_FILE"
    done

    # Create directories (This might be redundant if all files include their directories)
    find "$SOURCE_DIR" -type d | while read -r src; do
        rel_path="${src#$SOURCE_DIR/}" # Get the relative path
        target="$TARGET_DIR/$rel_path"
        mkdir -p "$target" && echo "$target" >>"$LOG_FILE"
    done

    touch "$FLAG_FILE"
    echo "Symlinks and directories created."
}

# Function to remove symlinks and directories
remove_symlinks() {
    if [ -f "$LOG_FILE" ]; then
        # Remove files (symlinks) listed in the log file
        while IFS= read -r line; do
            if [ -L "$line" ]; then # Ensure it's a symlink before deleting
                rm -f "$line"
            fi
        done <"$LOG_FILE"

        # Remove directories, avoiding non-empty directories
        tac "$LOG_FILE" | while IFS= read -r line; do
            if [ -d "$line" ]; then
                rmdir "$line" 2>/dev/null || true # Ignore errors if directory is not empty
            fi
        done

        # Cleanup
        rm -f "$LOG_FILE"
        rm -f "$FLAG_FILE"
        echo "Symlinks and directories removed."
    else
        echo "No log file found. Nothing to remove."
    fi
}

# Main logic to toggle the creation and removal of symlinks
if [ -f "$FLAG_FILE" ]; then
    remove_symlinks
else
    create_symlinks
fi

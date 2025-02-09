#!/bin/bash

NOTES_DIR="$HOME/notes"
SYNC_SUCCESS=true

# Function for notifications
notify() {
    local title="$1"
    local message="$2"
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$message"
    else
        echo -e "\n$title: $message"
    fi
}

# Check if notes directory exists
if [ ! -d "$NOTES_DIR" ]; then
    notify "Notes Error" "Directory not found: $NOTES_DIR"
    exit 1
fi

cd "$NOTES_DIR" || exit 1

# Perform git pull
echo -e "\n\033[1;34mSyncing remote changes...\033[0m"
if git pull; then
    notify "Notes Sync" "Successfully pulled latest changes"
else
    notify "Notes Sync Error" "Failed to pull remote changes"
    SYNC_SUCCESS=false
fi

# Open Neovim
echo -e "\n\033[1;34mOpening Neovim...\033[0m"
nvim .

# Commit changes
echo -e "\n\033[1;34mCommitting changes...\033[0m"
git add . 
if [ $? -ne 0 ]; then
    notify "Notes Error" "Failed to stage changes"
    SYNC_SUCCESS=false
fi

if [ -n "$(git status --porcelain)" ]; then
    COMMIT_MSG="Modified on $(date +'%Y-%m-%d at %H:%M:%S')"
    if git commit -m "$COMMIT_MSG"; then
        echo -e "\n\033[1;32mLatest commit:\033[0m"
        git log -n 1 --pretty=format:"%C(yellow)%h%Creset - %s %Cgreen(%ad)%Creset" --date=local
        
        # Push changes
        echo -e "\n\033[1;34mPushing changes...\033[0m"
        if git push; then
            notify "Notes Sync" "Successfully pushed changes"
        else
            notify "Notes Sync Error" "Failed to push changes"
            SYNC_SUCCESS=false
        fi
    else
        notify "Notes Error" "Failed to commit changes"
        SYNC_SUCCESS=false
    fi
else
    echo -e "\n\033[1;33mNo changes to commit\033[0m"
fi

# Final status
if $SYNC_SUCCESS; then
    echo -e "\n\033[1;32mNotes sync successful!\033[0m"
    notify "Notes Sync" "Successfully synchronized notes"
else
    echo -e "\n\033[1;31mNotes sync completed with errors\033[0m"
    notify "Notes Sync Error" "Completed with errors - check console"
fi

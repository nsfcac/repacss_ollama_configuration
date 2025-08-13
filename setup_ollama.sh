#!/bin/bash

# Simple Ollama setup script on REPACSS
echo "Setting up Ollama..."

# Set download directory to parent directory
DOWNLOAD_DIR=".."
OLLAMA_SIF_PATH="../ollama.sif"

# Get absolute paths for display
ABSOLUTE_DOWNLOAD_DIR=$(realpath "$DOWNLOAD_DIR")
ABSOLUTE_OLLAMA_SIF_PATH=$(realpath "$OLLAMA_SIF_PATH")

# Pull Ollama container (version 0.6.8 recommended)
echo "🚀 Step 1: Pulling Ollama container (version 0.6.8 recommended) to $ABSOLUTE_DOWNLOAD_DIR"
apptainer pull "$OLLAMA_SIF_PATH" docker://ollama/ollama:0.6.8
echo "✅ Step 1 finished!"

# Set Up The directory for Ollama  
echo "🚀 Step 2: Setting up the directory for Ollama"

# Auto-detect group name by checking where user's home directory is located

# # Method 1: Check if user's home is under /mnt structure
# USER_HOME_PATH=$(eval echo ~$USER)
# if [[ "$USER_HOME_PATH" == /mnt/*/home/* ]]; then
#     GROUP_NAME=$(echo "$USER_HOME_PATH" | cut -d'/' -f3)
#     echo "Detected group name from home directory: $GROUP_NAME"
# else
#     # Method 2: Look for user directory in /mnt/*/home/
#     POSSIBLE_PATH=$(find /mnt -type d -path "*/home/$USER" 2>/dev/null | head -1)
#     if [ -n "$POSSIBLE_PATH" ]; then
#         GROUP_NAME=$(echo "$POSSIBLE_PATH" | cut -d'/' -f3)
#         echo "Found group name by searching: $GROUP_NAME"
#     else
#         # Method 3: Fallback - ask user
#         read -p "Please enter your group name: " GROUP_NAME
#     fi
# fi

# Step 2: Export environment variable - use parent directory
export SCRATCH_BASE=".."
ABSOLUTE_SCRATCH_BASE=$(realpath "$SCRATCH_BASE")
echo "✅ Step 2 finished!"

# Step 3: This function will pick an available random port and start Ollama server:
echo "🚀 Step 3: Try to configure the environment for Ollama"
source ollama.sh


if [ $? -ne 0 ]; then
    echo "Error: Failed to source ollama.sh"
    exit 1
fi
sleep 3
echo "✅ Step 3 finished!"

# Step 4: Start ollama serve in background
echo "🚀 Step 4: Trying to start Ollama server:"
ollama serve > "${SCRATCH_BASE}/ollama/ollama.log" 2>&1 &
echo "✅ Step 4: Ollama server started in background."
echo "🎉 It is ready to use now!"
echo "📋 Try to use 'ollama list' to see the available models."
echo "🏃 Try to use 'ollama run <model_name>' to run the model."

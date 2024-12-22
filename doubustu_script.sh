#!/bin/bash
# Exit script on error
set -e
# Define repository and directories
REPO_URL="https://github.com/EnragedAntelope/comfyui-doubutsu-describer.git" 
CUSTOM_NODES_DIR="ComfyUI/custom_nodes" 
REPO_DIR="$CUSTOM_NODES_DIR/ComfyUI-Doubutsu-Describer" 
MODELS_DIR="$REPO_DIR/models" 
MODEL_PT_DIR="$MODELS_DIR/qresearch/doubutsu-2b-pt-756" 
MODEL_LORA_DIR="$MODELS_DIR/qresearch/doubutsu-2b-lora-756-docci"
# Clone the repository
echo "Cloning repository into $CUSTOM_NODES_DIR..." 
cd "$CUSTOM_NODES_DIR"
git clone "$REPO_URL"
mv comfyui-doubutsu-describer/ ComfyUI-Doubutsu-Describer
cd "ComfyUI-Doubutsu-Describer"
# Install dependencies
echo "Installing dependencies..." pip install -r requirements.txt
# Create models directory
echo "Creating models directory structure..." mkdir "models"
# Download model files using Hugging Face CLI
echo "Downloading model files..." 
huggingface-cli download qresearch/doubutsu-2b-pt-756 --local-dir models/qresearch/doubutsu-2b-pt-756
huggingface-cli download qresearch/doubutsu-2b-lora-756-docci --local-dir models/qresearch/doubutsu-2b-lora-756-docci

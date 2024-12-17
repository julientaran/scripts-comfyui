#!/bin/bash
# Dossier cible
DIRECTORY="ComfyUI/models/style_models"
# Nom du fichier a verifier
FILE="$DIRECTORY/flux1-redux-dev.safetensors"
# URL du modele Hugging Face
URL="https://huggingface.co/black-forest-labs/FLUX.1-Redux-dev/resolve/main/flux1-redux-dev.safetensors"
# Verifier si le dossier existe, sinon le creer
if [ ! -d "$DIRECTORY" ]; then echo "Le dossier '$DIRECTORY' n'existe pas. Creation du dossier..." mkdir -p "$DIRECTORY"
fi
# Verifier si le fichier existe deja dans le dossier
if [ -f "$FILE" ]; then echo "Le fichier '$FILE' existe deja. Telechargement non necessaire." exit 0 else echo "Le fichier 
    '$FILE' n'existe pas. Telechargement en cours..."
fi
# Demander le token a l'utilisateur
read -p "Entrez votre token Hugging Face : " HF_TOKEN echo
# Verifier si le token a ete entre
if [ -z "$HF_TOKEN" ]; then echo "Erreur : Aucun token n'a ete fourni. Telechargement annule." exit 1 
fi
# Telecharger le fichier avec wget
wget --header="Authorization: Bearer $HF_TOKEN" -O "$FILE" "$URL"


# Dossier cible
DIRECTORY="ComfyUI/models/clip_vision"
# Nom du fichier a verifier
FILE="$DIRECTORY/sigclip_vision_patch14_384.safetensors"
# URL du modele Hugging Face
URL="https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors"
# Verifier si le dossier existe, sinon le creer
if [ ! -d "$DIRECTORY" ]; then echo "Le dossier '$DIRECTORY' n'existe pas. Creation du dossier..." mkdir -p "$DIRECTORY"
fi
# Verifier si le fichier existe deja dans le dossier
if [ -f "$FILE" ]; then echo "Le fichier '$FILE' existe deja. Telechargement non necessaire." exit 0 else echo "Le fichier 
    '$FILE' n'existe pas. Telechargement en cours..."
fi
# Verifier si le token a ete entre
if [ -z "$HF_TOKEN" ]; then echo "Erreur : Aucun token n'a ete fourni. Telechargement annule." exit 1 
fi
# Telecharger le fichier avec wget
wget "$FILE" "$URL"


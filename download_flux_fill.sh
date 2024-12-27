#!/bin/bash

# Dossier cible
DIRECTORY="ComfyUI/models/unet"

# Nom du fichier à vérifier
FILE="$DIRECTORY/flux1-fill-dev.safetensors"

# URL du modèle Hugging Face
URL="https://huggingface.co/black-forest-labs/FLUX.1-Fill-dev/resolve/main/flux1-fill-dev.safetensors"

# Token par défaut (modifiez ici si besoin)
DEFAULT_HF_TOKEN=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

# Vérifier si le dossier existe, sinon le créer
if [ ! -d "$DIRECTORY" ]; then 
    echo "Le dossier '$DIRECTORY' n'existe pas. Création du dossier..."
    mkdir -p "$DIRECTORY"
fi

# Vérifier si le fichier existe déjà dans le dossier
if [ -f "$FILE" ]; then 
    echo "Le fichier '$FILE' existe déjà. Téléchargement non nécessaire."
    exit 0
else 
    echo "Le fichier '$FILE' n'existe pas. Téléchargement en cours..."
fi

# Fonction pour tenter le téléchargement avec un token donné
download_with_token() {
    local TOKEN=$1
    wget --header="Authorization: Bearer $TOKEN" -O "$FILE" "$URL"
    return $?
}

# Essayer avec le token par défaut
if ! download_with_token "$DEFAULT_HF_TOKEN"; then
    echo "Le token par défaut n'est pas valide. Veuillez fournir un autre token."
    
    # Demander le token à l'utilisateur
    read -p "Entrez votre token Hugging Face : " HF_TOKEN
    echo

    # Vérifier si le token a été entré
    if [ -z "$HF_TOKEN" ]; then 
        echo "Erreur : Aucun token n'a été fourni. Téléchargement annulé."
        exit 1
    fi

    # Réessayer avec le token fourni par l'utilisateur
    if ! download_with_token "$HF_TOKEN"; then
        echo "Erreur : Le téléchargement a échoué avec le token fourni."
        exit 1
    fi
fi

echo "Téléchargement terminé avec succès."

# wget --header="Authorization: Bearer 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" -O "vae2.safetensors".safetensors" "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/vae/diffusion_pytorch_model.safetensors"
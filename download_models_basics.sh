#!/bin/bash

# Liste des couples URL/emplacement de fichier
MODEL_INFO=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors ComfyUI/models/clip/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors ComfyUI/models/clip/t5xxl_fp16.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/vae/diffusion_pytorch_model.safetensors ComfyUI/models/vae/vae.safetensors"
    "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors ComfyUI/models/controlnet/diffusion_pytorch_models.safetensors"
    "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth ComfyUI/models/upscale_models/4x-ClearRealityV1.pth"
)

# Vérifier si un nouveau modèle est fourni en argument
if [ "$#" -eq 2 ]; then
    NEW_URL="$1"
    NEW_DEST="$2"
    MODEL_INFO+=("$NEW_URL $NEW_DEST")
    echo "Nouveau modèle ajouté : $NEW_URL vers $NEW_DEST"
fi

# Installation des modèles
for MODEL in "${MODEL_INFO[@]}"; do
    # Séparer l'URL et le chemin du fichier
    URL=$(echo $MODEL | cut -d' ' -f1)
    DEST=$(echo $MODEL | cut -d' ' -f2)

    # Vérifier si le dossier de destination existe, sinon le créer
    DEST_DIR=$(dirname "$DEST")
    if [ ! -d "$DEST_DIR" ]; then
        echo "Le dossier '$DEST_DIR' n'existe pas. Création du dossier..."
        mkdir -p "$DEST_DIR"
    fi

    # Vérifier si le fichier existe déjà
    if [ -f "$DEST" ]; then
        echo "Le fichier '$DEST' existe déjà. Téléchargement non nécessaire."
    else
        echo "Téléchargement du modèle depuis '$URL' vers '$DEST'..."
        wget -O "$DEST" "$URL"

        # Vérifier si le téléchargement a réussi
        if [ $? -eq 0 ]; then
            echo "Téléchargement réussi : '$DEST'."
        else
            echo "Erreur lors du téléchargement de '$URL'."
        fi
    fi
done

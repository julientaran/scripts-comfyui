#!/bin/bash

# Liste des couples URL/emplacement de fichier
MODEL_INFO=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors ComfyUI/models/clip/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors ComfyUI/models/clip/t5xxl_fp16.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors ComfyUI/models/vae/ae.safetensors"
    "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors ComfyUI/models/controlnet/diffusion_pytorch_models.safetensors"
    "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth ComfyUI/models/upscale_models/4x-ClearRealityV1.pth"
    "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.0.safetensors ComfyUI/models/pulid/pulid_flux_v0.9.0.safetensors"
)


# Demander à l'utilisateur s'il souhaite installer les modèles un par un
read -p "Voulez-vous installer chaque modèle un par un (oui/non) ? " INSTALL_ONE_BY_ONE

# Installation des modèles
for MODEL in "${MODEL_INFO[@]}"; do
    # Séparer l'URL et le chemin du fichier
    URL=$(echo $MODEL | cut -d' ' -f1)
    DEST=$(echo $MODEL | cut -d' ' -f2)

    # Si l'utilisateur veut installer les modèles un par un
    if [[ "$INSTALL_ONE_BY_ONE" =~ ^[Oo][Uu][Ii]$ || "$INSTALL_ONE_BY_ONE" =~ ^[Yy][Ee][Ss]$ ]]; then
        read -p "Souhaitez-vous installer le modèle '$DEST' depuis '$URL' (oui/non) ? " INSTALL_MODEL
        if [[ ! "$INSTALL_MODEL" =~ ^[Oo][Uu][Ii]$ || ! "$INSTALL_MODEL" =~ ^[Yy][Ee][Ss]$ ]]; then
            echo "Installation du modèle '$DEST' annulée."
            continue
        fi
    fi

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

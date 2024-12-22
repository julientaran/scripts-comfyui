#!/bin/bash

# Liste des couples URL/emplacement de fichier
MODEL_INFO=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors ComfyUI/models/clip/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors ComfyUI/models/clip/t5xxl_fp16.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors ComfyUI/models/vae/ae.safetensors"
    "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors ComfyUI/models/controlnet/diffusion_pytorch_models.safetensors"
    "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth ComfyUI/models/upscale_models/4x-ClearRealityV1.pth"
)

# Installation des modeles
for MODEL in "${MODEL_INFO[@]}"; do
    # Separer l'URL et le chemin du fichier
    URL=$(echo $MODEL | cut -d' ' -f1)
    DEST=$(echo $MODEL | cut -d' ' -f2)

    # Verifier si le dossier de destination existe, sinon le creer
    DEST_DIR=$(dirname "$DEST")
    if [ ! -d "$DEST_DIR" ]; then
        echo "Le dossier '$DEST_DIR' n'existe pas. Creation du dossier..."
        mkdir -p "$DEST_DIR"
    fi

    # Verifier si le fichier existe deja
    if [ -f "$DEST" ]; then
        echo "Le fichier '$DEST' existe deja. Telechargement non necessaire."
    else
        echo "Telechargement du modele depuis '$URL' vers '$DEST'..."
        wget -O "$DEST" "$URL"

        # Verifier si le telechargement a reussi
        if [ $? -eq 0 ]; then
            echo "Telechargement reussi : '$DEST'."
        else
            echo "Erreur lors du telechargement de '$URL'."
        fi
    fi
done

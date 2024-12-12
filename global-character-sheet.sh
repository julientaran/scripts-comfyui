#!/bin/bash
read -p "Pour Flux, entrez votre token Hugging Face : " HF_TOKEN echo
apt update
apt-get install unzip
python -m venv 00-env
source 00-env/bin/activate
python -m pip install -r scripts-comfyui/requirements.txt
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
python -m pip install -r ComfyUI-Manager/requirements.txt
git clone https://github.com/balazik/ComfyUI-PuLID-Flux.git
python -m pip install -r ComfyUI-PuLID-Flux/requirements.txt
cd ..
git reset --hard cc9cf6d1bd957d764ad418258b61d7e08187573b
cd ..

# Dossier cible
DIRECTORY="ComfyUI/models/unet"
# Nom du fichier a verifier
FILE="$DIRECTORY/flux1-dev.safetensors"
# URL du modele Hugging Face
URL="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"
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
wget --header="Authorization: Bearer $HF_TOKEN" -O "$FILE" "$URL"


# Liste des couples URL/emplacement de fichier
MODEL_INFO=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors ComfyUI/models/clip/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors ComfyUI/models/clip/t5xxl_fp16.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors ComfyUI/models/vae/ae.safetensors"
    "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors ComfyUI/models/controlnet/diffusion_pytorch_models.safetensors"
    "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth ComfyUI/models/upscale_models/4x-ClearRealityV1.pth"
    "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.0.safetensors ComfyUI/models/pulid/pulid_flux_v0.9.0.safetensors"
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip ComfyUI/models/insightface/models/antelopev2.zip"
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
cd ComfyUI/models/insightface/models/
unzip antelopev2.zip
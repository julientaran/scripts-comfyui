#!/bin/bash

echo "Début du script d'installation."

# Demande de token Hugging Face
echo "Étape 1 : Demande du token Hugging Face."
read -p "Pour Flux, entrez votre token Hugging Face : " HF_TOKEN echo
if [ -z "$HF_TOKEN" ]; then
    echo "Erreur : Aucun token n'a été fourni. Téléchargement annulé."
    exit 1
fi

echo "Étape 2 : Mise à jour des paquets."
apt update

echo "Étape 3 : Installation de unzip."
apt-get install unzip

echo "Étape 4 : Création d'un environnement virtuel Python."
python -m venv 00-env

echo "Étape 5 : Activation de l'environnement virtuel."
source 00-env/bin/activate

echo "Étape 6 : Installation des dépendances."
python -m pip install -r scripts-comfyui/requirements.txt

echo "Étape 7 : Clonage de ComfyUI."
git clone https://github.com/comfyanonymous/ComfyUI.git

echo "Étape 8 : Installation de ComfyUI Manager."
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
python -m pip install -r ComfyUI-Manager/requirements.txt

echo "Étape 9 : Installation de ComfyUI PuLID Flux."
git clone https://github.com/balazik/ComfyUI-PuLID-Flux.git
python -m pip install -r ComfyUI-PuLID-Flux/requirements.txt

echo "Étape 10 : Réinitialisation à une version spécifique de ComfyUI."
cd ..
git reset --hard cc9cf6d1bd957d764ad418258b61d7e08187573b
cd ..

# Dossier cible
DIRECTORY="ComfyUI/models/unet"
FILE="$DIRECTORY/flux1-dev.safetensors"
URL="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

echo "Étape 11 : Vérification et création du dossier cible."
if [ ! -d "$DIRECTORY" ]; then
    echo "Le dossier '$DIRECTORY' n'existe pas. Création en cours..."
    mkdir -p "$DIRECTORY"
fi

echo "Étape 12 : Vérification de l'existence du fichier."
if [ -f "$FILE" ]; then
    echo "Le fichier '$FILE' existe déjà. Téléchargement non nécessaire."
    exit 0
else
    echo "Le fichier '$FILE' n'existe pas. Téléchargement en cours..."
fi

echo "Étape 14 : Téléchargement du fichier principal."
wget --header="Authorization: Bearer $HF_TOKEN" -O "$FILE" "$URL"

MODEL_INFO=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors ComfyUI/models/clip/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors ComfyUI/models/clip/t5xxl_fp16.safetensors"
    "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors ComfyUI/models/vae/ae.safetensors"
    "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors ComfyUI/models/controlnet/diffusion_pytorch_models.safetensors"
    "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth ComfyUI/models/upscale_models/4x-ClearRealityV1.pth"
    "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.0.safetensors ComfyUI/models/pulid/pulid_flux_v0.9.0.safetensors"
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip ComfyUI/models/insightface/models/antelopev2.zip"
)

echo "Étape 15 : Téléchargement des modèles supplémentaires."
for MODEL in "${MODEL_INFO[@]}"; do
    URL=$(echo $MODEL | cut -d' ' -f1)
    DEST=$(echo $MODEL | cut -d' ' -f2)
    DEST_DIR=$(dirname "$DEST")

    if [ ! -d "$DEST_DIR" ]; then
        echo "Le dossier '$DEST_DIR' n'existe pas. Création en cours..."
        mkdir -p "$DEST_DIR"
    fi

    if [ -f "$DEST" ]; then
        echo "Le fichier '$DEST' existe déjà. Téléchargement non nécessaire."
    else
        echo "Téléchargement du modèle depuis '$URL' vers '$DEST'..."
        wget -O "$DEST" "$URL"

        if [ $? -eq 0 ]; then
            echo "Téléchargement réussi : '$DEST'."
        else
            echo "Erreur lors du téléchargement de '$URL'."
        fi
    fi
done

echo "Étape 16 : Extraction du fichier antelope ZIP."
cd ComfyUI/models/insightface/models/
unzip antelopev2.zip
cd insightface/models/antelopev2/antelopev2
mv * ..

echo "Script terminé avec succès."

#!/bin/bash

set -x

read -p "Avez-vous activé le port de Comfyui? (Tapez n'import quelle touche)" a echo
read -p "Avez-vous mis assez d'espace de stockage?" a echo

cd /workspace
mv scripts_comfyui/* .
chmod +x *
git clone https://github.com/comfyanonymous/ComfyUI.git
pip install -r requirements.txt
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
cd ComfyUI-Manager
pip install -r requirements.txt
cd ../..

echo "###########################"
echo "Telechargement de flux"
echo "###########################"
./download_flux.sh
echo "###########################"
echo "Telechargement de doubustu"
echo "###########################"
./doubutsu_script.sh
echo "###########################"
echo "Telechargement des autres modèles"
echo "###########################"
./download_models_basics.sh

set +x

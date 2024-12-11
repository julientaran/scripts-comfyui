# ./venv_p39.sh
# ./comfyui_v320
# ./pull_id_install.sh
# ./download_flux.sh
# ./download_models.sh

#!/bin/bash

# Fonction pour demander une réponse oui/non
ask_user() {
    local script_name=$1
    read -p "Voulez-vous exécuter le script '$script_name' ? (o/n) : " choice
    case "$choice" in
        [oO]|[oO][uU][iI]) 
            return 0  # Oui
            ;;
        [nN]|[nN][oO][nN]) 
            return 1  # Non
            ;;
        *) 
            echo "Réponse non reconnue. Considéré comme 'non'."
            return 1
            ;;
    esac
}

# Liste des scripts
scripts=(".venv_p39.sh" ".comfyui_v320" ".pull_id_install.sh" ".download_flux.sh" ".download_models.sh")

# Table pour stocker les décisions
declare -A execute_scripts

# Demander pour chaque script au début
for script in "${scripts[@]}"; do
    if ask_user "$script"; then
        execute_scripts["$script"]=true
    else
        execute_scripts["$script"]=false
    fi
done

# Exécuter les scripts sélectionnés
for script in "${scripts[@]}"; do
    if [[ ${execute_scripts["$script"]} == true ]]; then
        echo "Exécution de $script..."
        ./$script
    else
        echo "Le script $script a été ignoré."
    fi
done

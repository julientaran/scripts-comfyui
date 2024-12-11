# ./download_flux.sh
# ./download_models.sh
# ./doubustu_script.sh

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
scripts=(".download_flux.sh" ".download_models.sh" ".doubustu_script.sh")

# Tableau pour stocker les décisions
execute_scripts=()

# Demander pour chaque script au début
for script in "${scripts[@]}"; do
    if ask_user "$script"; then
        execute_scripts+=("$script")  # Ajouter à la liste des scripts à exécuter
    fi
done

# Exécuter les scripts sélectionnés
for script in "${execute_scripts[@]}"; do
    echo "Exécution de $script..."
    ./$script
done

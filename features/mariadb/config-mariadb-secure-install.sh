#!/bin/bash
#
# Script : config-mariadb-secure-install.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_MARIADB/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME
# Changer le mot de passe root : N
# Supprimer les utilisateurs anonymes : Y
# Désactiver les connexions distantes : Y
# Supprimer la base de données test et les accès : Y
# Recharger les privilèges : Y

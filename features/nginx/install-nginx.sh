#!/bin/bash
#
# Script : install-nginx.sh
#
# Version : 1.0

PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_NGINX/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME
aff_titre "Installation de NGINX"
# Importation de la clé GPG permettant de vérifier l'intégrité des fichiers qui seront téléchargés.
exec_import_gpg_apt "$NGINX_GPG"
# Ajout du dépôt STABLE de NGINX.
exec_apt_add_depot "$NGINX_SOURCES_LIST"
# Installer NGINX
exec_apt_install_uniq "$NGINX"

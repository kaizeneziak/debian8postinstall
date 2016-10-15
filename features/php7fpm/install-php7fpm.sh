#!/bin/bash
#
# Script : install-php7fpm.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_PHP7FPM/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME

aff_titre "Installation de PHP7-FPM"
exec_import_pgp_url "$PHP7FPM_GPG"
exec_apt_add_depot "$PHP7FPM_SOURCES_LIST" 
exec_apt_install_multi "$PHP7FPM" "$PHP7FPM_APT"


#!/bin/bash
#
# Script : config-.sh
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
. $PATH_DEBIAN8POSTINSTALL/functions/functions_whiptail.sh

# PROGRAMME

aff_titre "Configuration de PHP7-FPM"
# Remplacer le fichier /etc/php/7.0/fpm/php.ini
#aff_message "debug" "$PATH_PHP7_MODS"
exec_copy_file "$PHP7FPM_CONF_INI" "$PHP7FPM_INI"
# Copier le fichier $PHP7FPM_NGINX_CONF dans le dossier /etc/nginx/conf.d/
exec_copy_file "$PHP7FPM_CONF_PHP_CONF" "$PATH_NGINX_CONF_D"
# Copier le fichier opcache.ini dans le dossier /etc/php/7.0/mods-available/
exec_copy_file "$PHP7FPM_OPCACHE" "$PATH_PHP7_MODS/opcache.ini"
# Redémarrer le service php
exec_service_restart "$PHP7FPM"

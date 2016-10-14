#!/bin/bash
#
# Script : install-nginx.sh
#
# Version : 1.0

PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/var/debian8postinstall
. $PATH_DEBIAN8POSTINSTALL/var/nginx
# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/generals.sh

# PROGRAMME
function_title "Installation de NGINX"
# Importation de la clé GPG permettant de vérifier l'intégrité des fichiers qui seront téléchargés.
function_import_gpg_url "$NGINX_GPG"
# Ajout du dépôt STABLE de NGINX.
function_add_depot "$NGINX_SOURCES_LIST"
# Installer NGINX
function_apt_install "$NGINX"
